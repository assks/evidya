import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:evidya/constants/color_constant.dart';

import 'package:evidya/screens/livestreaming/livestreming_less.dart';
import 'package:evidya/utils/helper.dart';

import 'package:flutter/material.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/services.dart';
import 'package:pip_view/pip_view.dart';
import '../../../widget/back_toolbar_with_center_title.dart';
import 'broadcast_page.dart';
import 'livechatscreen.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

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
      this.rtmUser})
      : super(key: key);

  @override
  _liveClassState createState() => _liveClassState();
}

class _liveClassState extends State<LiveClass> with WidgetsBindingObserver {
  bool chatvisibility = true;
 // var appId = "d6306b59624c4e458883be16f5e6cbd2";
  final _users = <int>[];
  final _infoStrings = <String>[];
  RtcEngine _engine;
  bool muted = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

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
    Helper.showMessage("JoinChannel");
    await _engine.joinChannel(widget.token, widget.channelName, null, int.parse(widget.userName));
  }

  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(widget.appid);
    Helper.showMessage("Engine $_engine");
    print("Engine $_engine");
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    if (widget.isBroadcaster) {
      Helper.showMessage("broadcaster");
      await _engine.setClientRole(ClientRole.Broadcaster);
      print("broadcaster ${ClientRole.Broadcaster}");
    }
    else {
      Helper.showMessage("audience");
      await _engine.setClientRole(ClientRole.Audience);
      print("broadcaster ${ClientRole.Audience}");
    }
  }

  void _addAgoraEventHandlers() {
    print("In Add Agora Event Handlers");
    Helper.showMessage("In Add Agora Event Handlers");
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      print("code $code");
      setState(() {
        final info = 'onError: $code';
        Helper.showMessage("onError: $code");
        print("onError $code");
        _infoStrings.add(info);
      });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        Helper.showMessage('onJoinChannel: $channel, uid: $uid');
        print('onJoinChannel: $channel, uid: $uid');
        _infoStrings.add(info);
      });
    }, leaveChannel: (stats) {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        print('onLeaveChannel');
        Helper.showMessage('onLeaveChannel');
        _users.clear();
      });
    }, userJoined: (uid, elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        Helper.showMessage('userJoined: $uid');
        print('userJoined: $uid');
        _infoStrings.add(info);
        _users.add(uid);
      });
    }, userOffline: (uid, elapsed) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
        Helper.showMessage("Class ended");
        _onCallEnd(context);
      });
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      setState(() {
        Helper.showMessage('firstRemoteVideo: $uid ${width}x $height');

        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    }));
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk and leave channel
    _engine.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: buildPortrait());
  }

  Widget buildPortrait() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Visibility(
            visible: chatvisibility,
            child: Container(
              color:Colors.black,
          child: BackPressAppBarWithTitle(
            isBackButtonShow: true,
            isschudleclassButtonShow: false,
            centerTitle: widget.classname,
            backButtonColor: ColorConstant.black,
            titleColor: ColorConstant.black,

          ),
        )),
        Expanded(
            flex: 2,
            child: Center(
              child: Stack(
                children: <Widget>[
                  chatvisibility == true
                      ? _viewRows()
                      : RotatedBox(quarterTurns: 1, child: _viewRows()),
                  // _toolbar(),
                  Container(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                          icon: Icon(
                            Icons.fullscreen_exit,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            // Navigator.pop(context);
                            setState(() {
                              chatvisibility =
                                  (chatvisibility == true) ? false : true;
                            });
                          })),
                ],
              ),
            )),
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
    );
  }

  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
          child: Column(
            children: <Widget>[
              _expandedVideoRow([views[1]]),
            ],
          ),
        );
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
      default:
    }
    return Container();
  }

  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (widget.isBroadcaster) {
      list.add(RtcLocalView.SurfaceView());
    }
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
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
    return Expanded(child: Container(child: view));
  }
}
