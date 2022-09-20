import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:evidya/constants/color_constant.dart';
import 'package:evidya/resources/app_colors.dart';
import 'package:evidya/screens/bottom_navigation/bottom_navigaction_bar.dart';
import 'package:evidya/screens/livestreaming/broadcast/livechatscreen.dart';
import 'package:evidya/screens/livestreaming/live_stremaing_screen.dart';
import 'package:evidya/screens/livestreaming/livestreming_less.dart';
import 'package:evidya/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pip_view/pip_view.dart';
import 'package:sizer/sizer.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

import '../../utils/SizeConfigs.dart';
import '../../widget/back_toolbar_with_center_title.dart';

class LiveClass extends StatefulWidget {
  final String channelName;
  final String userName;
  final String token;
  final bool isBroadcaster;
  final String classname;
  final String appid;
  final String rtmChannel;
  final String rtmToken;
  final String rtmUser;
  final String liveStreamStatus;
  final String liveStreamDescription;
  final String liveStreamId;
  final String roomType;
  final String roomStatus;

  const LiveClass(
      {Key key,
      this.channelName,
      this.userName,
      this.token,
      this.isBroadcaster,
      this.classname,
      this.appid,
      this.rtmChannel,
      this.rtmToken,
      this.rtmUser,
      this.liveStreamStatus,
      this.liveStreamDescription,
        this.liveStreamId,
        this.roomStatus,
        this.roomType
      })
      : super(key: key);

  @override
  _liveClassState createState() => _liveClassState();
}

class _liveClassState extends State<LiveClass> with WidgetsBindingObserver, SingleTickerProviderStateMixin{
  bool chatvisibility = true;
 // var appId = "d6306b59624c4e458883be16f5e6cbd2";
  final _users = <int>[];
  final _infoStrings = <String>[];
  RtcEngine _engine;
  bool muted = false;
  bool volume = false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,

    )..repeat(reverse:true);
    _animation = CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    initialize();
  }

  AnimationController _controller;
  Animation<double> _animation;

  Future<void> initialize() async {
    //print('Client Role: ${widget.isBroadcaster}');
    if (widget.appid.isEmpty) {
      setState(() {
        _infoStrings.add('APP_ID missing, please provide your APP_ID in settings.dart'
        );
        _infoStrings.add('Agora Engine is not starting');
        Helper.showMessage("APP_ID missing, please provide your APP_ID in settings.dart,Agora Engine is not starting");
      });
      return;
    }
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await _engine.joinChannel(widget.token, widget.channelName, null, int.parse(widget.userName));
  }

  Future<void> _initAgoraRtcEngine() async {
    Helper.showMessage('initAgoraRtcEngine');
    _engine = await RtcEngine.create(widget.appid);
    Helper.showMessage('appid');
    await _engine.enableVideo();
    Helper.showMessage('enableVideo');

    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    if (widget.isBroadcaster) {
      await _engine.setClientRole(ClientRole.Broadcaster);
    } else {
      await _engine.setClientRole(ClientRole.Audience);
    }
  }

  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      setState(() {
        final info = 'onError: $code';
        Helper.showMessage("onError: $code");
        _infoStrings.add(info);
      });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        Helper.showMessage('onJoinChannel: $channel, uid: $uid');
        _infoStrings.add(info);
      });
    }, leaveChannel: (stats) {
      print("STats $stats");
      setState(() {
        _infoStrings.add('onLeaveChannel');
        Helper.showMessage('onLeaveChannel');
        _users.clear();

      });
    }, userJoined: (uid, elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        Helper.showMessage('userJoined: $uid');
        _infoStrings.add(info);
        print("Heellloo baby $uid");
        _users.add(uid);
      });
    },
        userOffline: (uid, elapsed) {
       print("UID In UserOffline $uid");
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        print("UID In UserOffline $uid");
        _users.remove(uid);
        print("Hello Updated $_users");
        if(_users == []) {
          _onCallEnd(context);
          EasyLoading.showToast("Streaming End.",
              toastPosition:EasyLoadingToastPosition.bottom);
        }
      });
    },
        remoteVideoStateChanged: (uid,VideoState, VideoStateReason,elapsed){
        setState(() {
          print("User UId $uid");
        });
        },
        firstRemoteVideoFrame: (uid, width, height, elapsed) {
      setState(() {
        Helper.showMessage('firstRemoteVideo: $uid ${width}x $height');
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    }));
  }

  void _onCallEnd(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context)=>BottomNavbar(index: 1,)),
            (Route<dynamic> route) => false);
  }

  @override
  void dispose() {
    _controller.dispose();
    // clear users
    _users.clear();
    // destroy sdk and leave channel
    _engine.destroy();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PIPView(
        builder: (context, isFloating){
        return Scaffold(
          backgroundColor: Colors.black,
           resizeToAvoidBottomInset: !isFloating,
            appBar:
            chatvisibility == true
                ? AppBar(
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                  title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                          onTap: _onToggleVolume,
                          child: volume
                              ? Image.asset('assets/icons/svg/volume_off.png',height: 3.h,width: 3.h,)
                              : SvgPicture.asset('assets/icons/svg/volume.svg',height: 3.h,width: 3.h,)

                      ),
                      SizedBox(width: 4.h,)
                    ],
                  ),
                  GestureDetector(
                    child: Row(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'b',
                            style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 12.sp),
                            children: <TextSpan>[
                              TextSpan(text: 'Live', style: TextStyle(fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 12.sp),),
                            ],
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down_rounded, size: 25,),
                      ],
                    ),
                    onTap: _showDetails,
                  ),
                  GestureDetector(
                    child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color(0xffca2424),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        padding:  EdgeInsets.symmetric(horizontal: 1.h,vertical: .5.h),
                        child: Text("Leave",style: TextStyle(fontSize: 10.sp,
                            letterSpacing: .5,
                            fontWeight: FontWeight.w500),)
                      //Image.asset('assets/icons/svg/phone_call.png',height: 3.h,width: 3.h,color: Colors.white,)
                    ),
                    onTap: () {
                      _onCallEnd(context);
                    },
                  )
                ],
              ),
              // You can add title here
              //leading:

              backgroundColor: Colors.black,
              elevation: 0.0,

            )
                : null,
            body: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  flex:2,
                  child:Stack(
                    children: <Widget>[
                      chatvisibility == true
                          ? _viewRows()
                          : RotatedBox(quarterTurns: 4, child: _viewRows()),
                      Container(
                          alignment: Alignment.bottomRight,
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  icon: Padding(
                                    child: Icon(
                                      Icons.close_fullscreen_outlined,
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.all(8),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      chatvisibility = false;
                                    });
                                    SystemChrome.setPreferredOrientations(
                                        [DeviceOrientation.portraitUp]);
                                    PIPView.of(context).presentBelow(BottomNavbar(index: 1,));
                                  }
                              ),
                              IconButton(
                                  icon: Icon(
                                    chatvisibility? Icons.fullscreen_exit
                                        :Icons.fullscreen_outlined,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    // Navigator.pop(context);
                                    setState(() {
                                      chatvisibility = !chatvisibility;
                                    });
                                    if(!chatvisibility){
                                      SystemChrome.setPreferredOrientations(
                                          [DeviceOrientation.landscapeRight]);
                                    }else{
                                      SystemChrome.setPreferredOrientations(
                                          [DeviceOrientation.portraitUp]);
                                    }
                                  })
                            ],
                          )
                      ),
                    ],
                  ),
                ),
                Visibility(
                              visible: chatvisibility,
                              child: Expanded(
                                flex: 3,
                                child: LiveChatScreen(
                                    appid: widget.appid,
                                    rtmChannel: widget.rtmChannel,
                                    rtmToken: widget.rtmToken,
                                    rtmUser: widget.rtmUser),
                              ),
                            ),
              ],
            )
        );
      },
    );
  }

  _showDetails() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.only(top: 10,bottom: 30,left: 20,right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft:Radius.circular(20),
                  topRight: Radius.circular(20),),
                color: AppColors.cardColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h,),
                  Text("${widget.classname}",
                    style: TextStyle(fontSize: 15.sp,
                        letterSpacing: .5,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),),
                  SizedBox(height: 2.h,),
                  Row(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width:30.w,
                        child: Text("Description",style:TextStyle(fontSize: 10.sp,
                            letterSpacing: .5,
                            color: Colors.grey),),),

                      SizedBox(
                          width:50.w,
                          child: Text("${widget.liveStreamDescription}",
                            maxLines: 4,
                            style:TextStyle(fontSize: 10.sp,
                                overflow: TextOverflow.ellipsis,
                                letterSpacing: .5,
                                color: Colors.white),))
                    ],
                  ),
                  SizedBox(height: 2.h,),
                  Row(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width:30.w,
                        child: Text("Host",style:TextStyle(fontSize: 10.sp,
                            letterSpacing: .5,
                            color: Colors.grey),),),

                      SizedBox(
                          width:50.w,
                          child: Text("${widget.channelName}",
                            style:TextStyle(fontSize: 10.sp,
                                letterSpacing: .5,
                                color: Colors.white),))
                    ],
                  ),
                  SizedBox(height: 2.h,),
                  Row(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width:30.w,
                        child: Text("Streaming Status",style:TextStyle(fontSize: 10.sp,
                            letterSpacing: .5,
                            color: Colors.grey),),),

                      SizedBox(
                          width:50.w,
                          child: Text("${widget.liveStreamStatus}",
                            style:TextStyle(fontSize: 10.sp,
                                letterSpacing: .5,
                                color: Colors.white),))
                    ],
                  ),
                  SizedBox(height: 2.h,),
                  Row(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width:30.w,
                        child: Text("Streaming Link",style:TextStyle(fontSize: 10.sp,
                            letterSpacing: .5,
                            color: Colors.grey),),),

                      SizedBox(
                          width:50.w,
                          child: Text("${widget.liveStreamId}",
                            style:TextStyle(fontSize: 10.sp,
                                letterSpacing: .5,
                                color: Colors.white),))
                    ],
                  ),
                  SizedBox(height: 2.h,),
                  Row(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width:30.w,
                        child: Text("Room Status",style:TextStyle(fontSize: 10.sp,
                            letterSpacing: .5,
                            color: Colors.grey),),),

                      SizedBox(
                          width:50.w,
                          child: Text("${widget.roomStatus}",
                            style:TextStyle(fontSize: 10.sp,
                                letterSpacing: .5,
                                color: Colors.white),))
                    ],
                  ),
                  SizedBox(height: 2.h,),
                  Row(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width:30.w,
                        child: Text("Room Type",style:TextStyle(fontSize: 10.sp,
                            letterSpacing: .5,
                            color: Colors.grey),),),

                      SizedBox(
                          width:50.w,
                          child: Text("${widget.roomType}",
                            style:TextStyle(fontSize: 10.sp,
                                letterSpacing: .5,
                                color: Colors.white),))
                    ],
                  ),
                  SizedBox(height: 4.h,),

                ],
              )
          ),
        );
      },
    );
  }

  void _onToggleVolume() {
    setState(() {
      volume = !volume;
    });
    _engine.muteAllRemoteAudioStreams(volume);
  }

  Widget _viewRows() {
    final views = _getRenderViews();
    print("View $views");
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
       // break;
      case 2:
        return Stack(
          children: <Widget>[
            Column(
              children: [_videoView(views[1])],
            ),
            //_expandedVideoRow([views[1]]),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10)
              ),
              height: 140,width: 100,
              child: Column(
                children: [_videoView(views[0])
                ],
              ),
            )
          ],
        );
       // break;
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
       // break;
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
       // break;
      default:
    }
    return Container();
  }

  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (widget.isBroadcaster) {
      list.add(RtcLocalView.SurfaceView());
      print("List Data $list");
    }
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid,)));
    print("usersList $_users");
    return list;
  }

  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video view wrapperf
  Widget _videoView(view) {
    return Expanded(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: view,
        )
    );
  }
}


