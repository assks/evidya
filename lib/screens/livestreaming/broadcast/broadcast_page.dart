import 'package:evidya/utils/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/services.dart';
import 'package:pip_view/pip_view.dart';
import 'package:wakelock/wakelock.dart';

import 'liveclass.dart';

class BroadcastPage extends StatefulWidget {
  final String channelName;
  final String userName;
  final String token;
  final bool isBroadcaster;
  final String classname;
  final bool rotate;

  const BroadcastPage(
      {Key key,
      this.channelName,
      this.userName,
      this.token,
      this.isBroadcaster,
      this.classname,
      this.rotate})
      : super(key: key);

  @override
  _BroadcastPageState createState() => _BroadcastPageState();
}

class _BroadcastPageState extends State<BroadcastPage> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  RtcEngine _engine;
  bool muted = false;
  var appId = "d6306b59624c4e458883be16f5e6cbd2";
  var rotate;

  @override
  void dispose() {
    // clear users
    _users.clear();
    Wakelock.disable();
    // destroy sdk and leave channel
    _engine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
     rotate =widget.rotate;
    initialize();

  }

  Future<void> initialize() async {
    //print('Client Role: ${widget.isBroadcaster}');
    if (appId.isEmpty) {
      setState(() {
        _infoStrings.add('APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await _engine.joinChannel(widget.token, widget.channelName, null, int.parse(widget.userName));
  }

  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(appId);
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    if (widget.isBroadcaster) {
      await _engine.setClientRole(ClientRole.Broadcaster);
    } else {
      await _engine.setClientRole(ClientRole.Audience);
    }
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
        _infoStrings.add(info);
      });
    }, leaveChannel: (stats) {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    }, userJoined: (uid, elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
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
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    }));
  }

  Widget _toolbar() {
    return widget.isBroadcaster
        ? Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RawMaterialButton(
                  onPressed: _onToggleMute,
                  child: Icon(
                    muted ? Icons.mic_off : Icons.mic,
                    color: muted ? Colors.white : Colors.blueAccent,
                    size: 20.0,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  fillColor: muted ? Colors.blueAccent : Colors.white,
                  padding: const EdgeInsets.all(12.0),
                ),
                RawMaterialButton(
                  onPressed: () => _onCallEnd(context),
                  child: Icon(
                    Icons.call_end,
                    color: Colors.white,
                    size: 35.0,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  fillColor: Colors.redAccent,
                  padding: const EdgeInsets.all(15.0),
                ),
                RawMaterialButton(
                  onPressed: _onSwitchCamera,
                  child: Icon(
                    Icons.switch_camera,
                    color: Colors.blueAccent,
                    size: 20.0,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  fillColor: Colors.white,
                  padding: const EdgeInsets.all(12.0),
                ),
                RawMaterialButton(
                  onPressed: () => _onCallEnd(context),
                  // onPressed: _goToChatPage,
                  child: Icon(
                    Icons.call_end,
                    color: Colors.redAccent,
                    size: 20.0,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  fillColor: Colors.white,
                  padding: const EdgeInsets.all(12.0),
                ),
              ],
            ),
          )
        : Row(
            children: [
              /* Container(
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(bottom: 48),
                child: RawMaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    dispose();
                  },
                  child: const Icon(
                    Icons.call_end,
                    color: Colors.red,
                    size: 30.0,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  fillColor: Colors.transparent,
                  padding: const EdgeInsets.all(12.0),
                ),
              ),*/
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return PIPView(builder: (context, isFloating) {
      return Scaffold(
        resizeToAvoidBottomInset: !isFloating,
        body: Center(
          child: Stack(
            children: <Widget>[
            rotate == true ? _viewRows() :  RotatedBox(quarterTurns: 1, child: _viewRows()),
              _toolbar(),
              Container(
                alignment: Alignment.bottomRight,
              child:  IconButton(
                  icon: Icon(
                    Icons.fullscreen_exit,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // Navigator.pop(context);
                    setState(() {
                      rotate = (rotate == true) ? false : true;
                    });
                    })),
                ],
          ),
        ),
      );
    });
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (widget.isBroadcaster) {
      list.add(RtcLocalView.SurfaceView());
    }
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
    return list;
  }

  /// Video view wrapperf
  Widget _videoView(view) {
    return Container(child: view);
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Row(
      children: wrappedViews,
    );
  }

  /// Video layout wrapper
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

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  Widget back() {
    // ModalRoute.of(context).settings.name;
    Navigator.of(context).pop();
  }
}
