import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:evidya/localdb/databasehelper.dart';
import 'package:evidya/model/login/autogenerated.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pip_view/pip_view.dart';
import 'package:sizer/sizer.dart';
import '../../../constants/string_constant.dart';
import '../../../network/repository/api_repository.dart';
import '../../../sharedpref/preference_connector.dart';
import '../../../utils/helper.dart';
import '../../bottom_navigation/bottom_navigaction_bar.dart';

class TestLiveStream extends StatefulWidget {
  final String channelName;
  final String userName;
  final String token;
  final String rtmChannel;
  final String rtmToken;
  final String rtmUser;
  final String appid;
  final String Callid;
  final String calleeName;
  final String userCallId;
  final String userFcmToken;
  final String userCallName;
  final String calleeFcmToken;
  final String devicefcmtoken,userprofileimage;

  const TestLiveStream(
      {this.appid,
      this.rtmChannel,
      this.rtmToken,
      this.rtmUser,
      this.channelName,
      this.token,
      this.userName,
      this.Callid,
        this.devicefcmtoken,
        this.userprofileimage,
        this.calleeName,
        this.userCallId,
        this.userCallName,
        this.userFcmToken,
        this.calleeFcmToken,
      Key key})
      : super(key: key);

  @override
  State<TestLiveStream> createState() => _TestLiveStreamState();
}

class _TestLiveStreamState extends State<TestLiveStream> {
  String APP_ID = '';
  var Logindata,userpeerid;
  dynamic profileJson,devicefcmtoken;
  final dbHelper = DatabaseHelper.instance;
  AudioPlayer player = AudioPlayer();
  Timer _timer;
  String Token = '', channalname = '', username = '',calleename="",rtmUser='',connectionstatus = "Calling";
  bool _joined = false;
  int _remoteUid = 0;
  bool _switch = false;
  RtcEngine _engine;
  bool muted = true;
  bool volume = false;
  bool camera = true;

  @override
  void initState() {
    super.initState();
    localData();
    if(widget.userFcmToken!=null){
      audioply();
    }

    _timer= Timer.periodic(const Duration(seconds: 30), (timer) {
      if (connectionstatus == "Calling") {
        Navigator.pop(context);
      }
    });

    if (widget.Callid != null) {
      getToken(widget.Callid);
    } else {
      callAPI(widget.userCallName,widget.userCallId);
    }


    PreferenceConnector.getJsonToSharedPreferenceefcmtoken(StringConstant.fcmtoken)
        .then((value) => {
      if (value != null)
        {
          devicefcmtoken = jsonDecode(value.toString()),
        }
    });
  }

  Future<void> initPlatformState(s) async {
    await [Permission.camera, Permission.microphone].request();

    // Create RTC client instance
    RtcEngineContext context = RtcEngineContext(APP_ID);
    var engine = await RtcEngine.createWithContext(context);
    //print("Engine $engine");
    _engine = engine;
    engine.setEventHandler(RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
      //print('joinChannelSuccess ${channel} ${uid}');
      Helper.showMessage('joinChannelSuccess ${channel} ${uid}');
      setState(() {
        _joined = true;
      });
    }, userJoined: (int uid, int elapsed) {
     // print('userJoined ${uid}');
      Helper.showMessage('userJoined ${uid}');
      setState(() {
        connectionstatus = "Connected";
      });

      player.stop();
      setState(() {
        _switch = !_switch;
        _remoteUid = uid;
      });
    }, userOffline: (int uid, UserOfflineReason reason) {
     // print('userOffline ${uid}');
      _engine.leaveChannel();
      _engine.destroy();
      _onCallEnd(s);
      Helper.showMessage('userOffline ${uid}');
      setState(() {
        _remoteUid = 0;
      });
      print("Yes Here");
    }));
    // Enable video
    await engine.enableVideo();
    await engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await engine.setClientRole(ClientRole.Broadcaster);
    await engine.muteLocalAudioStream(false);
   // await engine.muteLocalVideoStream(false);
    Helper.showMessage('joinChannel ${Token}${channalname}');
    await engine.joinChannel(Token, channalname, null, 0);
  }
  void localData() {
    PreferenceConnector.getJsonToSharedPreferencetoken(StringConstant.Userdata)
        .then((value) =>

    {
      if(value != null){
        profileJson = jsonDecode(value.toString()),
        setState(() {
          Logindata = LocalDataModal.fromJson(profileJson);
        })
      }
    });

    _timer= Timer.periodic(const Duration(seconds: 2), (timer) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      var call = prefs.getString(StringConstant.videoscreen);
      final int counter = prefs.getInt('counter');
      print("+bac123"+call);
      if (counter == 10){
        Navigator.pop(context);
      }
    });
  }

  void callAPI(String name, String id) {
    ApiRepository().videocallapi(name, id, widget.userFcmToken).then((value) {
      EasyLoading.dismiss();
      if (value != null) {
        if (value.status == "successfull") {
          setState(() {
            rtmUser = value.body.calleeName;
            APP_ID = value.body.appid;
            Token = value.body.callToken;
            channalname = value.body.callChannel;
            username = Logindata.id.toString();
          });
         // print("App Id $APP_ID, Token $Token");
          fcmapicall('video', widget.calleeFcmToken, '', value.body.callId, 'call_channel');
          _callinsert(value.body.calleeName, 'video', 'Dilled_Call');
          initPlatformState(context);
        }
        else {
          EasyLoading.showToast("Sorry, Network Issues! Please Connect Again.",
              toastPosition: EasyLoadingToastPosition.top,
              duration: Duration(seconds: 5)
          );
          Navigator.pop(context);
        }
      }
    });
  }

  callenamevalue() {
    var textvalue = "";
    if (rtmUser == "") {
      if (widget.userCallName != null) {
        textvalue = widget.userCallName[0];
      }
    } else {
      textvalue = rtmUser[0];
    }
    return Text(textvalue,
        style: TextStyle(color: Colors.white, fontSize: 60.sp));
  }

  textsetvalue() {
    var textvalue = "";
    if (rtmUser == '') {
      if (widget.userCallName != null) {
        textvalue = widget.userCallName[0];
      }
    } else {
      textvalue = rtmUser;
    }
    return Text(textvalue,
        style: TextStyle(
            fontSize: 17.sp, fontWeight: FontWeight.w500, color: Colors.white));
  }

  @override
  void dispose() async {
    super.dispose();
    _engine.leaveChannel();
    Wakelock.disable();
    _engine.destroy();
    player.stop();
    _timer.cancel();
   // PreferenceConnector().setvideocall("call");
    final prefs = await SharedPreferences.getInstance();
    final success = await prefs.remove('counter');
  }

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return PIPView(builder: (context, isFloating) {
      return Scaffold(
        resizeToAvoidBottomInset: !isFloating,
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: _switch ? _renderRemoteVideo() : _renderLocalPreview(),
            ),
            _switch == false ? Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.all(30),
                width: 200,
                height: 250,
                color: Colors.transparent,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _switch = !_switch;
                    });
                  },
                  child: Center(
                      child:Column(
                        children: [
                          const SizedBox(height: 10,),
                          Align(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 50.0,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: callenamevalue()
                                    // Text(rtmUser==''? "${widget.userCallName[0]}"
                                    //           : "${rtmUser[0]}",
                                    //     style: TextStyle(color: Colors.white, fontSize: 60.sp))
                                ),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          textsetvalue(),
                          // Text(rtmUser==''? "${widget.userCallName.split(" ")[0]}"
                          //           : "${rtmUser.split(" ")[0]}",style: TextStyle(
                          //     fontSize: 17.sp,
                          //     fontWeight: FontWeight.w500,
                          //     color: Colors.white
                          // ),),
                          SizedBox(height: 1.h),
                          Text(
                            'Calling',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13.sp
                            ),
                          ),
                        ],
                      )
                  ),
                ),
              ),
            ):
            Stack(
              children: [
                Center(
                  child: _renderRemoteVideo(),
                ),
                Align(
                alignment: Alignment.topLeft,
                child: Container(
                    margin: EdgeInsets.only(left: 10,top: 40,),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10)
                  ),
                     width: 150,
                    height: 200,
                  child:Container(
                    child:  _renderLocalPreview(),
                  )
              ))
              ],
            ),
          ],
        ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.h,vertical: 1.h),
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(0)
            ),
            height: 8.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                GestureDetector(
                    onTap: _onSwitchCamera,
                    child: Image.asset('assets/icons/svg/camera_flip.png',height: 3.h,width: 3.h,)
                ),
                GestureDetector(
                  child: camera == false
                  ?Image.asset("assets/icons/svg/video_camera.png",
                    height: 3.h,width: 3.h,
                  )
                  :Image.asset("assets/icons/svg/camera.png",
                    height: 3.h,width: 3.h,
                  )
                  ,
                  onTap:()=> toggleCamera(),
                ),
                GestureDetector(
                    onTap: _onToggleMute,
                    child: muted == false
                        ? Image.asset('assets/icons/svg/mic_off.png', height: 3.h, width: 3.h)
                        : Image.asset('assets/icons/svg/mic.png',height: 3.h, width: 3.h,)

                ),
                GestureDetector(
                  onTap: () => _onCallEnd(context),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xffca2424),
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/icons/svg/phone_call.png',
                            height: 3.h,
                            width: 3.h,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10,),
                          Text("Leave",style:
                          TextStyle(fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),)
                        ],
                      )),
                ),
                //  Text(_message),
              ],
            ),
          )
      );
    });
  }

  Widget _renderLocalPreview() {
    if (_joined) {
      return Container(
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.transparent
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: RtcLocalView.SurfaceView(),
        )
      );
    } else {
      return Text(
        'Please join channel first',
        textAlign: TextAlign.center,
      );
    }
  }

  void _onCallEnd(BuildContext context) {

    //Navigator.pop(context);

    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute( builder: (context) => const BottomNavbar(index: 2)),
            (Route<dynamic> route) => false);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }
  void _onToggleMute() {
    _engine.muteLocalAudioStream(muted);
    setState(() {
      muted = !muted;
    });
  }

  void _onToggleVolume() {
    setState(() {
      volume = !volume;
    });
    _engine.muteAllRemoteAudioStreams(volume);
  }

  Future<void> toggleCamera() async {
    _engine.muteLocalVideoStream(camera);
    setState(() {
      camera = !camera;
    });
  }

  // Remote preview
  Widget _renderRemoteVideo() {
    if (_remoteUid != 0) {
      return RtcRemoteView.SurfaceView(
        uid: _remoteUid,
        channelId: widget.channelName,
      );}
    else{
      return Container();
    }
  }

  void getToken(callId) async {
    PreferenceConnector.getJsonToSharedPreferencetoken(StringConstant.loginData)
        .then((value) => {
              if (value != null)
                {
                  EasyLoading.show(),
                  ApiRepository().receivevideocallapi(callId, value).then((value) {
                    EasyLoading.dismiss();
                    if (mounted) {
                      if (value != null) {
                        if (value.status == "successfull") {
                          setState(() {
                            APP_ID = value.body.appid;
                            Token = value.body.callToken;
                            channalname = value.body.callChannel;
                            calleename = value.body.calleeName;
                          });
                          initPlatformState(context);
                        }
                      }
                    }
                  })
                }
            });
  }

  void fcmapicall(String msg, String fcmtoken, image,call_id, type) {
    Helper.checkConnectivity().then((value) =>
    {
      if (value)
        {
          ApiRepository().fcmnotifiction(
              msg,
              Logindata.name,
              fcmtoken,
            image,
            call_id,
            type,
              widget.devicefcmtoken,
              widget.userprofileimage,"","senderpeerid","receiverpeerid"
              ).then((value) async {
          })
        }
      else
        {Helper.showNoConnectivityDialog(context)}
    });
  }

  Future<void> _callinsert(String calleeName, String calltype, String Calldrm) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.Id: null,
      DatabaseHelper.calleeName: calleeName,
      DatabaseHelper.timestamp: DateTime.now().toString(),
      DatabaseHelper.calltype: calltype,
      DatabaseHelper.Calldrm: Calldrm,
    };
    final id = await dbHelper.callinsert(row);
   // print('inserted row id: $id');
    return id;
  }

  void audioply() async{
    String audioasset = "assets/audio/Basic.mp3";
    ByteData bytes = await rootBundle.load(audioasset); //load sound from assets
    Uint8List  soundbytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    // int result = await player.earpieceOrSpeakersToggle();
    int result = await player.playBytes(soundbytes);
    if(result == 1){ //play success
     // print("Sound playing successful.");
    }else{
     // print("Error while playing sound.");
    }
  }
}
