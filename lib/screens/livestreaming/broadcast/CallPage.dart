import 'dart:async';
import 'dart:convert';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/model/login/PrefranceData.dart';
import 'package:evidya/network/repository/api_repository.dart';
import 'package:evidya/screens/bottom_navigation/bottom_navigaction_bar.dart';
import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:evidya/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pip_view/pip_view.dart';
import 'package:sizer/sizer.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';

class CallPage extends StatefulWidget {
  final String channelName;
  final String token;
  final String app_id;
  final String role;
  final String id;
  final String video;
  final String audio;
  final int userid;
  final String meetingid;
  final String userName;
  final String rtmUser;
  final String rtmToken;

  const CallPage({
    Key key,
    this.channelName,
    this.token,
    this.app_id,
    this.role,
    this.id,
    this.audio,
    this.video,
    this.userid,
    this.meetingid,
    this.userName,
    this.rtmUser,
    this.rtmToken,
  }) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  AgoraRtmClient _client;
  AgoraRtmChannel _channel;
  var mamberid = "";
  static final _users = <int>[];
  Map<int, User> _userMap = new Map<int, User>();
  int _localUid;
  final _infoStrings = <String>[];
  bool muted = false;
  bool volume = false;
  bool camera = false;
  bool allMuted = true;
  bool remoteMute = true;
  bool remoteCamera = true;
  dynamic userdata;
  var localdata;
  var name = " ";
  Map<String, String> userNameList = Map<String, String>();
  RtcEngine _engine;
  String audioasset = "assets/audio/Basic.mp3";
  String AppId, channelName;
  int indexValue = 0;
  bool hostMute = false, hostCamera = false;
  AudioPlayer player = AudioPlayer();
  static const String method_channel = 'test_activity';
  static const platform = MethodChannel(method_channel);

  final _stopWatchTimer = StopWatchTimer(
    onChange: (value) {
      final displayTime = StopWatchTimer.getDisplayTime(value);
    },
    onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
    onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
  );

  @override
  void dispose() {
    if (widget.role == "host") {
      _leaveapi(widget.id);
    }
    _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
    // clear users
    _users.clear();
    _userMap.clear();
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  var userAudio = [], userVideo = [];

  @override
  void initState() {
    super.initState();
    //  localData();
    print('audio ${widget.audio}  &Video${widget.video}');
    muted = (widget.audio == '0') ? true : false;
    camera = (widget.video == '0') ? true : false;
    indexValue = 0;
    AppId = widget.app_id;
    channelName = widget.channelName;
    print(
        "APP ID  $AppId,channel ID $channelName  meeting Id ${widget.meetingid}, ${widget.id}");
    print("RTM User ${widget.rtmUser} && RTM Token ${widget.rtmToken}");
    if (widget.role != "host") {
      Timer.periodic(const Duration(seconds: 10), (timer) {
        _statusapi(widget.id);
      });
    }

    _createClient();
    fetchUserName();
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    var stream = (StreamController<int>.broadcast()..add(1)).stream;
    stream.listen(print);
  }

  void _createClient() async {
    //  RTC
    _client = await AgoraRtmClient.createInstance(widget.app_id);
    _client.onMessageReceived = (AgoraRtmMessage message, String peerId) async {
      // RegExp fileExp =
      //     RegExp(r"(http(s?):)([/|.|\w|\s|-])*\.(?:jpg|gif|png|jpeg)");
      // dynamic isfile = fileExp.hasMatch(message.text);
      print("Peer ID $peerId");
      print("onMessageReceived:${message.text}");
      if (message.text == "mic_off") {
        setState(() {
          hostMute = true;
        });
        EasyLoading.showToast("You are muted by host.",
            duration: const Duration(seconds: 3),
            toastPosition: EasyLoadingToastPosition.bottom);
        await _engine.muteLocalAudioStream(true);
      } else if (message.text == "mic_on") {
        setState(() {
          hostMute = false;
        });
        await _engine.muteLocalAudioStream(false);
        EasyLoading.showToast(
            "Host un-muted you.\n Now you can enable your mic.",
            duration: Duration(seconds: 3),
            toastPosition: EasyLoadingToastPosition.bottom);
      } else if (message.text == "videocam_off") {
        setState(() {
          hostCamera = true;
        });
        EasyLoading.showToast("Host disabled your camera",
            duration: Duration(seconds: 3),
            toastPosition: EasyLoadingToastPosition.bottom);
        await _engine.muteLocalVideoStream(true);
      } else if (message.text == "videocam_on") {
        setState(() {
          hostCamera = false;
        });
        await _engine.muteLocalVideoStream(false);
        EasyLoading.showToast("You can enable your camera now",
            duration: Duration(seconds: 3),
            toastPosition: EasyLoadingToastPosition.bottom);
      }
    };
    initialize();
    try {
      await _client.login(widget.rtmToken, widget.rtmUser);
      print('Login success: ' + widget.app_id);
      await _joinChannel(context);

      /// RTM
    } catch (errorCode) {
      print('Login error: ' + errorCode.toString());
    }
  }

  void _joinChannel(BuildContext context) async {
    String channelId = widget.channelName;
    if (channelId.isEmpty) {
      return;
    }
    try {
      _channel = await _createChannel(channelId);
      await _channel.join();
      print('Join channel success.');
    } catch (errorCode) {
      print('Join channel error: ' + errorCode.toString());
    }
  }

  Future<AgoraRtmChannel> _createChannel(String name) async {
    _channel = await _client.createChannel(name);
    _channel.onMemberJoined = (AgoraRtmMember member) {
      var parts = member.userId.split('(');
      var prefix = parts[0].trim();
      mamberid = "Member joined:" + prefix;
    };

    _channel.onMemberLeft = (AgoraRtmMember member) {
      var parts = member.userId.split('(');
      var prefix = parts[0].trim();
      mamberid = "Member left:" + prefix;
    };
    _channel.onMessageReceived =
        (AgoraRtmMessage message, AgoraRtmMember member) {
      print("message $message");
      var parts = member.userId.split('(');
      var prefix = parts[0].trim();
      mamberid = prefix;
    };
    return _channel;
  }

  void fetchUserName() async {
    await PreferenceConnector.getJsonToSharedPreferencetoken(
            StringConstant.Userdata)
        .then((value) => {
              if (value != null)
                {
                  userdata = jsonDecode(value.toString()),
                  setState(() {
                    localdata = PrefranceData.fromJson(userdata);
                    name = localdata.name;
                  })
                }
            });
  }

  Future<void> initialize() async {
    if (widget.app_id.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    //_addAgoraEventHandlers1();
    await _engine.joinChannel(
        widget.token, widget.channelName, null, 1000000 + widget.userid);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    await [Permission.camera, Permission.microphone].request();
    _engine = await RtcEngine.create(widget.app_id /*appID*/);
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.Communication);
    await _engine.enableAudioVolumeIndication(250, 3, true);
    await _engine.muteLocalAudioStream(muted);
    await _engine.muteLocalVideoStream(camera);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        print("I am here");
        _infoStrings.add(info);
        _localUid = uid;
        userNameList[0.toString()] = "${widget.userName.toUpperCase()}";
        _userMap.addAll({uid: User(uid, false)});
        RTMUser();
      });
    }, videoSubscribeStateChanged: (_, __, ___, ____, ______) async {
      print("Here");
      RTMUser();
    }, leaveChannel: (stats) {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
        _userMap.clear();
        Navigator.pop(context);
      });
    }, userJoined: (uid, elapsed) {
      RTMUser();
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);

        //userNameList[uid.toString()]= "UserJoined";
        _userMap.addAll({uid: User(uid, false)});
      });
    }, userOffline: (uid, reason) {
      setState(() {
        final info = 'userOffline: $uid , reason: $reason';
        _infoStrings.add(info);
        if (uid == 10000) {
          screenshareid = 0;
        }
        _users.remove(uid);
        _userMap.remove(uid);
      });
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      setState(() {
        final info = 'firstRemoteVideoFrame: $uid';
        _infoStrings.add(info);
        RTMUser();
      });
    }, audioVolumeIndication: (volumeInfo, v) {
      volumeInfo.forEach((speaker) {
        //detecting speaking person whose volume more than 5
        if (speaker.volume > 5) {
          try {
            _userMap.forEach((key, value) {
              //Highlighting local user
              //In this callback, the local user is represented by an uid of 0.
              if ((_localUid?.compareTo(key) == 0) && (speaker.uid == 0)) {
                setState(() {
                  _userMap.update(key, (value) => User(key, true));
                });
              }

              //Highlighting remote user
              else if (key.compareTo(speaker.uid) == 0) {
                setState(() {
                  _userMap.update(key, (value) => User(key, true));
                });
              } else {
                setState(() {
                  _userMap.update(key, (value) => User(key, false));
                });
              }
            });
          } catch (error) {
            print('Error:${error.toString()}');
          }
        }
      });
    }));
  }

  dynamic memberList = "";

  void RTMUser() async {
    dynamic list = await _channel.getMembers();
    _channel.onMessageReceived =
        (AgoraRtmMessage message, AgoraRtmMember member) {
      print("message ${message.text}");
    };
    memberList = list;
    print("RTM List $list");
    dynamic json = memberList;
    print("Joiner ${memberList[0].runtimeType}");
    print("json  $json");
    String jsonArry = jsonEncode(json);
    print("jsonArry $jsonArry");

    List jsonData = jsonDecode(jsonArry);
    print("jsonData $jsonData");
    for (int i = 0; i < jsonData.length; i++) {
      Future.delayed(
          const Duration(milliseconds: 5000),
          () => {
                setState(() {
                  userNameList[(jsonData[i]['userId'])
                          .toString()
                          .split(":")[0]
                          .toString()] =
                      "${(jsonData[i]['userId']).toString().split(":")[1]}";
                })
              });
    }
  }

  ///   Another Method ==============
  void _addAgoraEventHandlers1() {
    _engine.setEventHandler(
      RtcEngineEventHandler(error: (code) {
        print("error occurred $code");
      }, joinChannelSuccess: (channel, uid, elapsed) {
        setState(() {
          _localUid = uid;
          _userMap.addAll({uid: User(uid, false)});
        });
      }, leaveChannel: (stats) {
        setState(() {
          _userMap.clear();
        });
      }, userJoined: (uid, elapsed) {
        setState(() {
          _userMap.addAll({uid: User(uid, false)});
        });
      }, userOffline: (uid, elapsed) {
        setState(() {
          _userMap.remove(uid);
        });
      },

          /// Detecting active speaker by using audioVolumeIndication callbac
          audioVolumeIndication: (volumeInfo, v) {
        volumeInfo.forEach((speaker) {
          //detecting speaking person whose volume more than 5
          if (speaker.volume > 5) {
            try {
              _userMap.forEach((key, value) {
                //Highlighting local user
                //In this callback, the local user is represented by an uid of 0.
                if ((_localUid?.compareTo(key) == 0) && (speaker.uid == 0)) {
                  setState(() {
                    _userMap.update(key, (value) => User(key, true));
                  });
                }

                //Highlighting remote user
                else if (key.compareTo(speaker.uid) == 0) {
                  setState(() {
                    _userMap.update(key, (value) => User(key, true));
                  });
                } else {
                  setState(() {
                    _userMap.update(key, (value) => User(key, false));
                  });
                }
              });
            } catch (error) {
              print('Error:${error.toString()}');
            }
          }
        });
      }),
    );
  }

  /// Toolbar layout
  Widget _toolbar() {
    // print("Muted $muted");
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
              onTap: () {
                if (hostCamera == true) {
                  EasyLoading.showToast("Your camera disabled by host.",
                      duration: Duration(seconds: 5),
                      toastPosition: EasyLoadingToastPosition.bottom);
                } else {
                  toggleCamera();
                }
              },
              child: camera == true
                  ? Image.asset(
                      'assets/icons/svg/video_camera.png',
                      height: 3.h,
                      width: 3.h,
                    )
                  : SvgPicture.asset(
                      'assets/icons/svg/video_camera.svg',
                      height: 3.h,
                      width: 3.h,
                    )),
          GestureDetector(
              onTap: () {
                if (hostMute == true) {
                  EasyLoading.showToast("Your are muted by host",
                      duration: Duration(seconds: 5),
                      toastPosition: EasyLoadingToastPosition.bottom);
                } else {
                  _onToggleMute();
                }
              },
              child: muted
                  ? Image.asset(
                      'assets/icons/svg/mic_off.png',
                      height: 3.h,
                      width: 3.h,
                    )
                  : SvgPicture.asset(
                      'assets/icons/svg/mic_icon.svg',
                      height: 3.h,
                      width: 3.h,
                    )),
          GestureDetector(
              onTap: () {
                _onShareWithEmptyFields(context, widget.meetingid, 'Meeting');
              },
              child: Image.asset(
                'assets/images/share.png',
                height: 3.h,
                width: 3.h,
                color: Colors.white,
              )),
          GestureDetector(
              onTap: () {
                try {
                  platform.invokeMethod('startNewActivity', {
                    "rtcchannal": channelName,
                    "rtctoken": widget.token,
                    "stop": "share"
                  });
                } on PlatformException catch (e) {
                  print(e.message);
                }
              },
              child: Image.asset(
                'assets/icons/svg/screen_share.png',
                height: 3.h,
                width: 3.h,
                color: Colors.white,
              )),
          GestureDetector(
              onTap: () {
                _participantsList(memberList);
              },
              child: Container(
                height: 5.h,
                child: Stack(
                  children: [
                    Positioned(
                      left: 3.1.h,
                      child: Container(
                        alignment: Alignment.topRight,
                        child: Text("${memberList.length ?? "1"}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 8.sp,
                                letterSpacing: .5,
                                color: Colors.white)),
                      ),
                    ),
                    Container(
                      width: 5.h,
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/icons/svg/users.svg',
                        height: 3.h,
                        width: 3.h,
                      ),
                    )
                  ],
                ),
              )),
          GestureDetector(
              onTap: () {
                _addMoreDetails(context);
              },
              child: SvgPicture.asset(
                'assets/icons/svg/dots.svg',
                height: 3.h,
                width: 3.h,
              )),
        ],
      ),
    );
  }

  ///========== BottomSheet ==========
  _showDetails() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding:
                  EdgeInsets.only(top: 10, bottom: 30, left: 20, right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.black,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    "${name}'s Meeting Room",
                    style: TextStyle(
                        fontSize: 15.sp,
                        letterSpacing: .5,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Meeting ID",
                          style: TextStyle(
                              fontSize: 10.sp,
                              letterSpacing: .5,
                              color: Colors.grey),
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: Text(
                            "${widget.meetingid}",
                            style: TextStyle(
                                fontSize: 10.sp,
                                letterSpacing: .5,
                                color: Colors.white),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Host ID",
                          style: TextStyle(
                              fontSize: 10.sp,
                              letterSpacing: .5,
                              color: Colors.grey),
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: Text(
                            "${widget.channelName}",
                            style: TextStyle(
                                fontSize: 10.sp,
                                letterSpacing: .5,
                                color: Colors.white),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Invite Link",
                          style: TextStyle(
                              fontSize: 10.sp,
                              letterSpacing: .5,
                              color: Colors.grey),
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: Text(
                            "Not Available",
                            style: TextStyle(
                                fontSize: 10.sp,
                                letterSpacing: .5,
                                color: Colors.white),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Encryption",
                          style: TextStyle(
                              fontSize: 10.sp,
                              letterSpacing: .5,
                              color: Colors.grey),
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: Text(
                            "Enable",
                            style: TextStyle(
                                fontSize: 10.sp,
                                letterSpacing: .5,
                                color: Colors.white),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                ],
              )),
        );
      },
    );
  }

  ///================add More BottomSheet =========

  _addMoreDetails(BuildContext cnx) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding:
                    EdgeInsets.only(top: 10, bottom: 30, left: 20, right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Color(0xff4d4d4d),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 2.h,
                    ),
                    Card(
                        color: Color(0xff696969),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            GestureDetector(
                                child: Card(
                                  elevation: 0,
                                  color: Color(0xff696969),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                      child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              allMuted
                                                  ? Text(
                                                      "Mute All",
                                                      style: TextStyle(
                                                          fontSize: 10.sp,
                                                          letterSpacing: .5,
                                                          color: allMuted
                                                              ? Colors.red
                                                              : Colors.white),
                                                    )
                                                  : Text(
                                                      "UnMute All",
                                                      style: TextStyle(
                                                          fontSize: 10.sp,
                                                          letterSpacing: .5,
                                                          color: allMuted
                                                              ? Colors.red
                                                              : Colors.white),
                                                    ),
                                              allMuted
                                                  ? Image.asset(
                                                      'assets/icons/svg/mic_off.png',
                                                      height: 2.h,
                                                      width: 2.h,
                                                    )
                                                  : SvgPicture.asset(
                                                      'assets/icons/svg/mic_icon.svg',
                                                      height: 2.h,
                                                      width: 2.h,
                                                    )
                                            ],
                                          ))),
                                ),
                                onTap: () {
                                  setState(() {
                                    _onToggleAllMute();
                                  });
                                }),
                            // Divider(
                            //   height: 1,
                            //   thickness: 2,
                            // ),

                            Divider(
                              height: 1,
                              thickness: 2,
                            ),
                            GestureDetector(
                                child: Card(
                                  elevation: 0,
                                  color: Color(0xff696969),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                      child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Share link",
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    letterSpacing: .5,
                                                    color: Colors.white),
                                              ),
                                              Image.asset(
                                                'assets/images/share.png',
                                                height: 2.h,
                                                width: 2.h,
                                                color: Colors.white,
                                              )
                                            ],
                                          ))),
                                ),
                                onTap: () {
                                  setState(() {
                                    _onShareWithEmptyFields(
                                        context, widget.meetingid, 'Meeting');
                                  });
                                }),
                            Divider(
                              height: 1,
                              thickness: 2,
                            ),
                            GestureDetector(
                                child: Card(
                                  elevation: 0,
                                  color: Color(0xff696969),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                      child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Disconnect joiner",
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    letterSpacing: .5,
                                                    color: Colors.white),
                                              ),
                                              Image.asset(
                                                'assets/icons/svg/disconnect.png',
                                                height: 2.h,
                                                width: 2.h,
                                                color: Colors.white,
                                              )
                                            ],
                                          ))),
                                ),
                                onTap: () {
                                  setState(() {
                                    EasyLoading.showInfo(
                                      "This is not available yet.",
                                    );
                                    //  _onShareWithEmptyFields(context, widget.meetingid);
                                  });
                                }),
                            Divider(
                              height: 1,
                              thickness: 2,
                            ),
                            GestureDetector(
                                child: Card(
                                  elevation: 0,
                                  color: Color(0xff696969),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                      child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Record video",
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    letterSpacing: .5,
                                                    color: Colors.white),
                                              ),
                                              Image.asset(
                                                'assets/icons/svg/recorder.png',
                                                height: 2.h,
                                                width: 2.h,
                                                color: Colors.white,
                                              )
                                            ],
                                          ))),
                                ),
                                onTap: () {
                                  setState(() {
                                    EasyLoading.showInfo(
                                      "This is not available yet.",
                                    );
                                    //  _onShareWithEmptyFields(context, widget.meetingid);
                                  });
                                }),
                          ],
                        )),
                    SizedBox(
                      height: 1.h,
                    ),
                    GestureDetector(
                      child: Card(
                        elevation: 0,
                        color: Color(0xff696969),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                            child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text("Cancel",
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  letterSpacing: .5,
                                  color: Colors.white)),
                        )),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                  ],
                )),
          );
        });
      },
    );
  }

  /// ==========  Meeting Joiner Users ==============
  _participantsList(dynamic joiner) {
    dynamic json = joiner;
    //print("Joiner ${joiner[0].runtimeType}");
    print("json  $json");
    String jsonArry = jsonEncode(json);
    print("jsonArry $jsonArry");

    List jsonData = jsonDecode(jsonArry);
    print("jsonData $jsonData");
    for (int i = 0; i < jsonData.length; i++) {
      userAudio.add(false);
      userVideo.add(false);
    }
    // print("Joiner $joiner");
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: 100.h,
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.only(top: 5, bottom: 30, left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Color(0xff4d4d4d),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 1.h,
                ),
                Container(
                  height: .7.h,
                  child: Container(
                    height: 3,
                    width: 80,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                SizedBox(
                    height: 48.h,
                    child: SingleChildScrollView(
                      child: ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Card(
                                color: Color(0xff696969),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${(jsonData[index]['userId']).toString().split(":")[1]}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                      widget.role == "host"
                                          ? Row(
                                              children: [
                                                GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        if (userVideo[index] ==
                                                            false) {
                                                          userVideo[index] =
                                                              true;
                                                          AgoraRtmMessage
                                                              message =
                                                              AgoraRtmMessage
                                                                  .fromText(
                                                                      "videocam_off");
                                                          _client.sendMessageToPeer(
                                                              (jsonData[index][
                                                                      'userId'])
                                                                  .toString(),
                                                              message,
                                                              true,
                                                              false);
                                                        } else {
                                                          userVideo[index] =
                                                              false;
                                                          AgoraRtmMessage
                                                              message =
                                                              AgoraRtmMessage
                                                                  .fromText(
                                                                      "videocam_on");
                                                          print(
                                                              "Peer ID ${(jsonData[index]['userId']).toString()}");
                                                          _client.sendMessageToPeer(
                                                              (jsonData[index][
                                                                      'userId'])
                                                                  .toString(),
                                                              message,
                                                              true,
                                                              false);
                                                        }
                                                        // _onToggleRemoteCamera(int
                                                        //     .parse((jsonData[index]
                                                        // ['userId'])
                                                        //     .toString()
                                                        //     .split(":")[0]));
                                                      });
                                                    },
                                                    child: userVideo[index] ==
                                                            false
                                                        ? SvgPicture.asset(
                                                            'assets/icons/svg/video_camera.svg',
                                                            height: 3.h,
                                                            width: 3.h,
                                                          )
                                                        : Image.asset(
                                                            'assets/icons/svg/video_camera.png',
                                                            height: 3.h,
                                                            width: 3.h,
                                                          )),
                                                SizedBox(width: 10),
                                                GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        if (userAudio[index] ==
                                                            false) {
                                                          userAudio[index] =
                                                              true;
                                                          AgoraRtmMessage
                                                              message =
                                                              AgoraRtmMessage
                                                                  .fromText(
                                                                      "mic_off");
                                                          _client.sendMessageToPeer(
                                                              (jsonData[index][
                                                                      'userId'])
                                                                  .toString(),
                                                              message,
                                                              true,
                                                              false);
                                                        } else {
                                                          userAudio[index] =
                                                              false;
                                                          AgoraRtmMessage
                                                              message =
                                                              AgoraRtmMessage
                                                                  .fromText(
                                                                      "mic_on");
                                                          _client.sendMessageToPeer(
                                                              (jsonData[index][
                                                                      'userId'])
                                                                  .toString(),
                                                              message,
                                                              true,
                                                              false);
                                                        }
                                                        // _onToggleRemoteMute(int
                                                        //     .parse((jsonData[index]
                                                        // ['userId'])
                                                        //     .toString()
                                                        //     .split(":")[0]));
                                                      });
                                                    },
                                                    child: userAudio[index] ==
                                                            false
                                                        ? SvgPicture.asset(
                                                            'assets/icons/svg/mic_icon.svg',
                                                            height: 3.h,
                                                            width: 3.h,
                                                          )
                                                        : Image.asset(
                                                            'assets/icons/svg/mic_off.png',
                                                            height: 3.h,
                                                            width: 3.h,
                                                          )),
                                              ],
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ));
                          },
                          separatorBuilder: (_, __) => SizedBox(
                                height: 1.h,
                              ),
                          itemCount: jsonData.length),
                    ))
              ],
            ),
          );
        });
      },
    );
  }

  /// =====GridView =========
  _buildGridVideoView() {
    if (_userMap.length < 8) {
      if (screenshareid == 1000) {
        return RtcRemoteView.SurfaceView(uid: 10000);
      } else {
        return _viewRows();
      }
    } else {
      return GridView.builder(
          shrinkWrap: true,
          itemCount: _userMap.length,
          scrollDirection: Axis.vertical,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 9 / 12, crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            return Flex(
              direction: Axis.vertical,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Container(
                            child: Container(
                                color: Colors.white,
                                child: (_userMap.entries.elementAt(index).key ==
                                        _localUid)
                                    ? RtcLocalView.SurfaceView()
                                    : RtcRemoteView.SurfaceView(
                                        uid: _userMap.entries
                                            .elementAt(index)
                                            .key)),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: _userMap.entries
                                          .elementAt(index)
                                          .value
                                          .isSpeaking
                                      ? Colors.blue
                                      : Colors.grey,
                                  width: 1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(1.0),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            indexValue = index;
                          });
                        },
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "${userNameList[(_userMap.entries.elementAt(index).key).toString()] ?? "User"}",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          });
    }
  }

  ///=========== Build Function ===============
  @override
  Widget build(BuildContext context) {
    // print("userMap ${_userMap.length}");
    //RTMUser();
    return PIPView(builder: (context, isFloating) {
      return Scaffold(
        resizeToAvoidBottomInset: !isFloating,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                      onTap: _onSwitchCamera,
                      child: Image.asset(
                        'assets/icons/svg/camera_flip.png',
                        height: 3.h,
                        width: 3.h,
                      )),
                  SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                      onTap: _onToggleVolume,
                      child: volume
                          ? Image.asset(
                              'assets/icons/svg/volume_off.png',
                              height: 3.h,
                              width: 3.h,
                            )
                          : SvgPicture.asset(
                              'assets/icons/svg/volume.svg',
                              height: 3.h,
                              width: 3.h,
                            )),
                ],
              ),
              GestureDetector(
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'b',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 12.sp),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Meet',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 12.sp),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 25,
                    ),
                  ],
                ),
                onTap: _showDetails,
              ),
              GestureDetector(
                child: Container(
                    decoration: BoxDecoration(
                        color: const Color(0xffca2424),
                        borderRadius: BorderRadius.circular(5)),
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.h, vertical: .5.h),
                    child: Text(
                      "END",
                      style: TextStyle(
                          fontSize: 12.sp,
                          letterSpacing: .5,
                          fontWeight: FontWeight.w700),
                    )),
                onTap: () {
                  _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                  _onCallEnd(context);
                },
              )
            ],
          ),
        ),
        body: Center(
          child: Stack(
            children: <Widget>[
              _userMap.isNotEmpty ? _buildGridVideoView() : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.topLeft,
                    child: StreamBuilder<int>(
                      stream: _stopWatchTimer.rawTime,
                      initialData: _stopWatchTimer.rawTime.value,
                      builder: (context, snap) {
                        final value = snap.data;
                        final displayTime = StopWatchTimer.getDisplayTime(value,
                            hours: true, second: true, milliSecond: false);
                        return Row(
                          children: <Widget>[
                            const Icon(
                              Icons.timer,
                              size: 20,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              displayTime,
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white,
                                  fontFamily: 'Helvetica',
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      alignment: Alignment.topRight,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10)),
                      child: Icon(
                        Icons.close_fullscreen_outlined,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      SystemChrome.setPreferredOrientations(
                          [DeviceOrientation.portraitUp]);
                      PIPView.of(context).presentBelow(BottomNavbar(
                        index: 0,
                      ));
                    },
                  ),
                ],
              )
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.only(top: 0),
          height: 10.h,
          color: Colors.black,
          child: _toolbar(),
        ),
      );
    });
  }

  var screenshareid;

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    list.add(RtcLocalView.SurfaceView());
    for (var uid in _users) {
      if (uid == 10000) {
        screenshareid = 1000;
      }
      list.add(RtcRemoteView.SurfaceView(uid: uid));
    }
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(
        child: Stack(
      children: [
        Container(
            padding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
            child: view),
        Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${userNameList[(view.uid).toString()] ?? "User"}",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        )
      ],
    ));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    //print('user list $_users,views.length ${views.length}');

    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[
            _videoView(views[0])
            // _expandedVideoRow([views[0]]),
          ],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));

      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));

      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));

      case 5:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4)),
            _expandedVideoRow(views.sublist(4, 5))
          ],
        ));

      case 6:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4)),
            _expandedVideoRow(views.sublist(4, 6))
          ],
        ));
      case 7:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4)),
            _expandedVideoRow(views.sublist(4, 6)),
            _expandedVideoRow(views.sublist(6, 7))
          ],
        ));
      case 8:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4)),
            _expandedVideoRow(views.sublist(4, 6)),
            _expandedVideoRow(views.sublist(6, 8))
          ],
        ));
      case 9:
        return _buildGridVideoView();
      default:
    }
    return Container();
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    print('mute $muted');
    _engine.muteLocalAudioStream(muted);
  }

  void _onToggleRemoteMute(int joinerUID) {
    _engine.muteRemoteAudioStream(joinerUID, remoteMute);
    setState(() {
      remoteMute = !remoteMute;
    });
    print('mute $remoteMute');
  }

  void _onToggleRemoteCamera(int joinerUID) {
    _engine.muteRemoteVideoStream(joinerUID, remoteCamera);
    setState(() {
      remoteCamera = !remoteCamera;
    });
    print('remoteCamera $remoteCamera');
  }

  void _onToggleAllMute() {
    _engine.muteAllRemoteAudioStreams(allMuted);
    setState(() {
      allMuted = !allMuted;
    });
    print('mute $allMuted');
  }

  void _onToggleVolume() {
    setState(() {
      volume = !volume;
    });
    _engine.muteLocalAudioStream(volume);
  }

  Future<void> toggleCamera() async {
    setState(() {
      camera = !camera;
    });
    print('camera $camera');
    _engine.muteLocalVideoStream(camera);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  void _leaveapi(String id) {
    Helper.checkConnectivity().then((value) => {
          if (value)
            {
              PreferenceConnector.getJsonToSharedPreference(
                      StringConstant.loginData)
                  .then((value) => {
                        if (value != null)
                          {
                            print("id ${widget.id} value $value"),
                            ApiRepository()
                                .leavevideocall(value, widget.id.toString())
                                .then((value) {
                              if (value != null) {
                                if (value['status'] == "successfull") {
                                  if (mounted) {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BottomNavbar(index: 0)),
                                        (Route<dynamic> route) => false);
                                  }
                                } else {
                                  EasyLoading.showToast(
                                      "Something went wrong please logout and login again.",
                                      toastPosition:
                                          EasyLoadingToastPosition.bottom);
                                }
                              }
                            })
                          }
                        else
                          {
                            EasyLoading.showToast(
                                "Something went wrong please logout and login again.",
                                toastPosition: EasyLoadingToastPosition.bottom),
                          }
                      })
            }
          else
            {Helper.showNoConnectivityDialog(context)}
        });
  }

  void _statusapi(String id) async {
    PreferenceConnector.getJsonToSharedPreferencetoken(StringConstant.loginData)
        .then((value) async => {
              if (value != null)
                {
                  await ApiRepository()
                      .vidoecallstatus(value, id)
                      .then((value) {
                    if (value != null) {
                      if (value.status == "successfull") {
                        if (value.body.meeting.status == "scheduled") {
                          Navigator.pop(context);
                        }
                      } else {
                        EasyLoading.showToast(
                            "Something went wrong please logout and login again.",
                            toastPosition: EasyLoadingToastPosition.bottom);
                      }
                    }
                  })
                }
            });
  }

  _onShareWithEmptyFields(BuildContext context, String id, String type) async {
    Helper.checkConnectivity().then((value) => {
          if (value)
            {
              PreferenceConnector.getJsonToSharedPreference(
                      StringConstant.Userdata)
                  .then((value) => {
                        if (value != null)
                          {
                            userdata = jsonDecode(value.toString()),
                            localdata = PrefranceData.fromJson(userdata),
                            FlutterShare.share(
                                title: 'Meeting Id',
                                text:
                                    '${localdata.name} just invited you to a bvidya $type.\n'
                                    '$type code -$id\n'
                                    'To join, copy the code and enter it on the bvidya app or website.'),
                          }
                        else
                          {
                            Helper.showMessage(
                                "Something went wrong please logout and login again.")
                          }
                      })
            }
        });
  }

  void audioply() async {
    ByteData bytes = await rootBundle.load(audioasset); //load sound from assets
    Uint8List soundbytes =
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    int result = await player.playBytes(soundbytes);
    if (result == 1) {
      //play success
      print("Sound playing successful.");
    } else {
      print("Error while playing sound.");
    }
  }

  void localData() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      PreferenceConnector.getJsonToSharedPreferenceechatscreen(
              StringConstant.chatscreen)
          .then((value) => {
                if (value == "callscreen")
                  {
                    Navigator.pop(context),
                  }
              });
    });
  }
}

class User {
  int uid; //reference to user uid

  bool isSpeaking; // reference to whether the user is speaking

  User(this.uid, this.isSpeaking);

  @override
  String toString() {
    return 'User{uid: $uid, isSpeaking: $isSpeaking}';
  }
}
