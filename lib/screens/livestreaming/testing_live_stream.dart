import 'package:evidya/screens/livestreaming/broadcast/livechatscreen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:permission_handler/permission_handler.dart';
class TestLiveStream extends StatefulWidget {
  final String channelName;
  final String userName;
  final String token;
  final String rtmChannel;
  final String rtmToken;
  final String rtmUser;
  final String appid;

  const TestLiveStream({
    this.appid,this.rtmChannel,this.rtmToken,this.rtmUser,
    this.channelName,this.token,this.userName,
    Key key}) : super(key: key);

  @override
  State<TestLiveStream> createState() => _TestLiveStreamState();
}

class _TestLiveStreamState extends State<TestLiveStream> {
  String APP_ID = '';
  String Token = '';
  bool _joined = false;
  int _remoteUid = 0;
  bool _switch = false;
  bool chatvisibility = true;
  @override
  void initState() {
    super.initState();
    initPlatformState();
    APP_ID = widget.appid;
    Token = widget.rtmToken;
    print("App Id $APP_ID, Token $Token");
  }


  void initPlatformState() async {
    await [Permission.camera, Permission.microphone].request();

    // Create RTC client instance
    RtcEngineContext ctx = RtcEngineContext(APP_ID);
    var engine = await RtcEngine.createWithContext(ctx);
    print("Engine $engine");
    engine.setEventHandler(RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print('joinChannelSuccess ${channel} ${uid}');
          setState(() {
            _joined = true;
          });
        },
        userJoined: (int uid, int elapsed) {
      print('userJoined ${uid}');
      setState(() {
        _remoteUid = uid;
      });
    }, userOffline: (int uid, UserOfflineReason reason) {
      print('userOffline ${uid}');
      _onCallEnd(context);
      setState(() {
        _remoteUid = 0;
      });
      print("Yes Here");
    }));
    // Enable video
    await engine.enableVideo();
    // Set channel profile as livestreaming
    await engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    // Set user role as broadcaster
    await engine.setClientRole(ClientRole.Audience);
    // Join channel with channel name as 123
    await engine.joinChannel(widget.token, widget.channelName, null, int.parse(widget.userName));
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Live Class'),
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace_outlined),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
              flex: 2,
              child: Center(
                child: Stack(
                  children: <Widget>[
                    chatvisibility == true
                        ? Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height,
                            color: Colors.white,
                            child:  Center(
                              child:
                              // _switch ? _renderLocalPreview() :
                              _renderRemoteVideo(),
                            ),
                          )
                        : RotatedBox(quarterTurns: 1, child: Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height,
                              color: Colors.white,
                              child:  Center(
                                child:
                                // _switch ? _renderLocalPreview() :
                                _renderRemoteVideo(),
                              ),
                            )),
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
      ),
    );
  }

  Widget _renderLocalPreview() {
    if (_joined) {
      return RtcLocalView.SurfaceView();
    } else {
      return Text(
        'Please join channel first',
        textAlign: TextAlign.center,
      );
    }
  }

  // Remote preview
  Widget _renderRemoteVideo() {
    if (_remoteUid != 0) {
      return RtcRemoteView.SurfaceView(
        uid: _remoteUid,
        channelId: widget.channelName,
      );
    } else {
      return Text(
        'Please wait remote user join',
        textAlign: TextAlign.center,
      );
    }
  }


}
