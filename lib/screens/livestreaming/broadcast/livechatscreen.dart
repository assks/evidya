
import 'package:evidya/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtm/agora_rtm.dart';

import 'logs.dart';

class LiveChatScreen extends StatefulWidget {
  final String appid;
  final String rtmChannel;
  final String rtmToken;
  final String rtmUser;

  const LiveChatScreen(
      {Key key, this.appid, this.rtmChannel, this.rtmToken, this.rtmUser})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<LiveChatScreen> {
  AgoraRtmClient _client;
  AgoraRtmChannel _channel;
  var mamberid = "";
  final ScrollController _controller = ScrollController();

  LogController logController = LogController();

  final _peerUserId = TextEditingController();
  final _peerMessage = TextEditingController();
  final _channelMessage = TextEditingController();

  @override
  void initState() {
    super.initState();
    inisiate();
  }

  void inisiate() async {
    await _createClient();
    _login(context);
  }

  void _createClient() async {
    _client = await AgoraRtmClient.createInstance(widget.appid);
    _client.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      logController
          .addLog("Private Message from " + peerId + ": " + message.text);
      _scrollDown();
    };
    _client.onConnectionStateChanged = (int state, int reason) {
      // logController.addLog('Connection state changed: ' +
      //     state.toString() +
      //     ', reason: ' +
      //     reason.toString());

      if (state == 5) {
        _client.logout();
        logController.addLog('Logout.');
      }
    };
  }

  void _login(BuildContext context) async {
    try {
      await _client.login(widget.rtmToken, widget.rtmUser /*token,_userId*/);
     // logController.addLog('Login success: ' + widget.rtmUser);
      _joinChannel(context);
    } catch (errorCode) {
      print('Login error: ' + errorCode.toString());
    }
  }

  void _joinChannel(BuildContext context) async {
    String channelId = widget.rtmChannel;
    if (channelId.isEmpty) {
      logController.addLog('Please input channel id to join.');
      return;
    }

    try {
      _channel = await _createChannel(channelId);
      await _channel.join();
      logController.addLog('Join channel success.');
    } catch (errorCode) {
      print('Join channel error: ' + errorCode.toString());
    }
  }

  Future<AgoraRtmChannel> _createChannel(String name) async {
    AgoraRtmChannel channel = await _client.createChannel(name);
    channel.onMemberJoined = (AgoraRtmMember member) {
      var parts = member.userId.split('(');
      var prefix = parts[0].trim();
      mamberid = "Member joined:" + prefix;
      logController.addLog(
          /*"Member joined: " +*/
          mamberid /*member.userId*/ + ', channel: ' + member.channelId);
    };
    channel.onMemberLeft = (AgoraRtmMember member) {
      var parts = member.userId.split('(');
      var prefix = parts[0].trim();
      mamberid = "Member left:" + prefix;
      logController.addLog(
          /*"Member left: " + member.userId +*/
          ', channel: ' + member.channelId);
    };
    channel.onMessageReceived =
        (AgoraRtmMessage message, AgoraRtmMember member) {
      var parts = member.userId.split('(');
      var prefix = parts[0].trim();
      mamberid = prefix;
      logController.addLog(prefix + ": " + message.text);
      _scrollDown();
    };
    return channel;
  }

  void _isUserOnline() async {
    if (_peerUserId.text.isEmpty) {
      logController.addLog('Please input peer user id to query.');
      return;
    }
    try {
      Map<dynamic, dynamic> result =
          await _client.queryPeersOnlineStatus([_peerUserId.text]);
      logController.addLog('Query result: ' + result.toString());
    } catch (errorCode) {
      logController.addLog('Query error: ' + errorCode.toString());
    }
  }

  void _sendPeerMessage() async {
    if (_peerUserId.text.isEmpty) {
      logController.addLog('Please input peer user id to send message.');
      return;
    }
    if (_peerMessage.text.isEmpty) {
      logController.addLog('Please input text to send.');
      return;
    }

    try {
      AgoraRtmMessage message = AgoraRtmMessage.fromText(_peerMessage.text);
      await _client.sendMessageToPeer(_peerUserId.text, message, false);
      logController.addLog('Send peer message success.');
    } catch (errorCode) {
      logController.addLog('Send peer message error: ' + errorCode.toString());
    }
  }

  void _scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent + 50,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ValueListenableBuilder(
                  valueListenable: logController,
                  builder: (context, log, widget) {
                    return Expanded(
                        child: ListView.separated(
                          separatorBuilder: (_, __)=>SizedBox(height: 5,),
                      controller: _controller,
                          reverse: false,
                      itemBuilder: (context, i) {
                        return Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Text(log[i],
                              style: const TextStyle(
                                  height: 1.5,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500)),
                        );
                      },
                      itemCount: log.length,
                    ));
                  }),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextFormField(
                  controller: _channelMessage,
                  keyboardType: TextInputType.text,
                  style:  TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 20,top: 15),
                    filled: true,
                    focusColor: Colors.white.withOpacity(0.5),
                    hintText: "Enter a message",
                    hintStyle: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    suffixIcon: IconButton(
                      onPressed: () {
                        sendChannelMessage();
                      },
                      icon: Icon(
                        Icons.send_outlined,
                        size: 20,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  // validator: (value) {
                  //   if (value.isEmpty) {
                  //     return 'Enter a valid password!';
                  //   } else if(value.length<8)
                  //   {
                  //     return 'password must be at least 8 characters.';
                  //   }
                  //   return null;
                  // },
                ),
              ),
              // Container(
              //
              //   margin: EdgeInsets.only(top:10),
              //   alignment: Alignment.center,
              //   child: Expanded(
              //     child: TextFormField(
              //       controller: _channelMessage,
              //       cursorColor: Colors.black,
              //       style:  TextStyle(fontSize: 12),
              //       decoration: InputDecoration(
              //         hintText: "Enter a message",
              //         fillColor: Colors.white,
              //         isDense: false,
              //         filled: true,
              //         hintStyle: TextStyle(fontSize: 12),
              //         border: InputBorder.none,
              //         enabledBorder: OutlineInputBorder(
              //           borderSide:
              //           const BorderSide(color: Colors.white, width: 2.0),
              //           borderRadius: BorderRadius.circular(20.0),
              //         ),
              //         focusedBorder: OutlineInputBorder(
              //           borderSide:
              //           const BorderSide(color: Colors.white, width: 2.0),
              //           borderRadius: BorderRadius.circular(20.0),
              //         ),
              //         suffixIcon: IconButton(
              //           onPressed: () {
              //             sendChannelMessage();
              //           },
              //           icon: Icon(
              //             Icons.send_outlined,
              //             size: 20,
              //             color: Colors.red,
              //           ),
              //
              //         ),
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  void sendChannelMessage() async {
    if (_channelMessage.text.isEmpty) {
      logController.addLog('Please input text to send.');
      return;
    }
    try {
      await _channel
          .sendMessage(AgoraRtmMessage.fromText(_channelMessage.text));
      logController.addLog("you: " + _channelMessage.text);
      _controller.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      _channelMessage.clear();
    } catch (errorCode) {
      logController
          .addLog('Send channel message error: ' + errorCode.toString());
    }
  }
}
