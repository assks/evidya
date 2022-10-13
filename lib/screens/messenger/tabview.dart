import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:agora_rtm/agora_rtm.dart';
import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/localdb/databasehelper.dart';
import 'package:evidya/model/login/PrefranceData.dart';
import 'package:evidya/network/repository/api_repository.dart';
import 'package:evidya/screens/messenger/logs.dart';
import 'package:evidya/screens/messenger/recent_chat_screen.dart';
import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:evidya/utils/helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class messengertab extends StatefulWidget {

  final String rtmpeerid;
  messengertab({Key key,this.rtmpeerid}) : super(key: key);

  @override
  _messengertabState createState() => _messengertabState();
}

class _messengertabState extends State<messengertab>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  AgoraRtmClient _client;
  LogController logController = LogController();
  ClassLog classlog = ClassLog();
  MessageLog messagelog = MessageLog();
  GroupMessageLog groupmessagelog = GroupMessageLog();
  final String appId = "d6306b59624c4e458883be16f5e6cbd2";
  String userpeerid = "123";
  String deviceTokenToSendPushNotification = "";
  final dbHelper = DatabaseHelper.instance;
  TabController _tabController;
  ImagePicker picker = ImagePicker();
  bool control_Log = true;
  var name = " ";
  String image,token;
  var fullname;

  @override
  void initState()  {
    SharedPreferencedata();
  _createClient();
    _tabController = TabController(length: 3, vsync: this);
    _gettoken();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _client.logout();
    print("logout");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [

            RecentChat(
                logController: logController,
                client: _client,
                userpeerid: userpeerid,
                messageLog: messagelog,
                clientpeerid:widget.rtmpeerid,
                groupmessageLog: groupmessagelog),
          ],
        ),
      ),
    );
  }

  void SharedPreferencedata() async {
    await PreferenceConnector.getJsonToSharedPreferencetoken(
            StringConstant.Userdata)
        .then((value) => {
              if (value != null)
                {
                  userdata = jsonDecode(value.toString()),
                  setState(() {
                    localdata = PrefranceData.fromJson(userdata);
                    fullname = localdata.name;
                    name = fullname.split(' ')[0];
                    token = userdata['auth_token'];
                  })
                }
            });
  }




  void _gettoken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    image = prefs.getString('profileImage');
    PreferenceConnector.getJsonToSharedPreferencetoken(StringConstant.loginData)
        .then((value) => {
              if (value != null)
                {
                  ApiRepository().Messanger_rtmtoken(value).then((value) {
                    if (value != null) {
                      if (value.status == "successfull") {
                        setState(()   {
                         _login(context, value.body.rtmToken, value.body.rtmUser);
                          userpeerid = value.body.rtmUser;
                          if (value.body.rtmUser != null) {
                            PreferenceConnector.setJsonToSharedPreferencertmuserpeerid(StringConstant.rtmuserpeerid,value.body.rtmUser);
                          }
                        });
                      } else {
                        Helper.showMessage("No Result found");
                      }
                    }
                  })
                }
               }
             );
  }

  void _login(BuildContext context, String token, String userid) async {
    try {
      await _client.login(token, userid);
      print('Login success: ' + userid);
      //_createClient();
    } catch (errorCode) {
      _login(context, token, userid);
      print('Login error: ' + errorCode.toString());
    }
  }

  Future<void> downlordimage(String file, String peerid, group, groupname,textid,time) async {
    try {
      if (group == "group") {
        dynamic parts = file.split('#@####@#');
        var imageId = await ImageDownloader.downloadImage(parts[1]);
        if (imageId == null) {
          return;
        }
        //_insert(message.text,peerId,'image');
        // Below is a method of obtaining saved image information.
        var fileName = await ImageDownloader.findName(imageId);
       // print('filename' + fileName);
        var path = await ImageDownloader.findPath(imageId);
       // print('path' + path);
        _insertgroup("group#@####@#" + path.toString() + "#@####@#noreplay#@####@#" , peerid, 'image', groupname,time);
        var size = await ImageDownloader.findByteSize(imageId);
       // print('size' + size.toString());
        var mimeType = await ImageDownloader.findMimeType(imageId);
       // print('mimetype' + mimeType);
      } else {
        dynamic parts = file.split('#@####@#');
        var imageId = await ImageDownloader.downloadImage(parts[2]);
        if (imageId == null) {
          return;
        }
        //_insert(message.text,peerId,'image');
        // Below is a method of obtaining saved image information.
        var fileName = await ImageDownloader.findName(imageId);
       // print('filename' + fileName);
        var path = await ImageDownloader.findPath(imageId);
       // print('path' + path);
        _insert("" + "#@####@#noreplay#@####@#" + path.toString(), peerid, 'image',time,textid);
        var size = await ImageDownloader.findByteSize(imageId);
       // print('size' + size.toString());
        var mimeType = await ImageDownloader.findMimeType(imageId);
      //  print('mimetype' + mimeType);
      }
    } on PlatformException catch (error) {
      print(error);
    }
  }

  Future<void> downlordpdf(String pdfurl, String peerid, group,time,textid) async {
    try {
     dynamic pdffilepath = pdfurl.split('#@#&');
     var name = pdffilepath[1];
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$name');
      /*if (await file.exists()) {
        return file.path;
      }*/
      final response = await http.get(Uri.parse(pdffilepath[0]));
      await file.writeAsBytes(response.bodyBytes);
     var filepath= file.path;
      logController.addLog("#@####@#noreplay#@####@#" +filepath.toString()+"#@#&"+name + '#@####@#Receive' + '#@####@#doc' + '#@####@#' + DateTime.now().toString() + "#@####@#" + "" + '#@####@#' + peerid+'#@####@#');
      _insert("" + "#@####@#noreplay#@####@#" + filepath.toString()+"#@#&"+name, peerid, 'doc',time,textid);
    } on PlatformException catch (error) {
      print(error);
    }
  }

  void _createClient() async {
    logController.clear();
    _client = await AgoraRtmClient.createInstance(appId);
    _client.onMessageReceived = (AgoraRtmMessage message, String peerId) async {
      RegExp fileExp = RegExp(r"(http(s?):)([/|.|\w|\s|-])*\.(?:jpg|gif|png|jpeg|pdf|mp4)");
      dynamic isfile = fileExp.hasMatch(message.text);
      String smallString = message.text.substring(0, 5);
      dynamic parts = message.text.split('#@####@#');

      //String messages= message.text.substring(0,message.text.lastIndexOf("#@####@#"));
      String messages=parts[0]+"#@####@#"+parts[1]+"#@####@#"+parts[2];
      groupmessagelog.addLog(parts[2]);
      dynamic message_exists = await dbHelper.is_message_exists(parts[4]);

      var time= parts[3].toString().substring(0,16);
      var shortmessage = parts[0] + "#@####@#" + parts[1] + "#@####@#" + parts[2];
      if (isfile) {
        if (control_Log) {
          if (smallString == 'group') {
            dynamic parts = message.text.split('#@####@#');
            logController.addLog(shortmessage + "#@####@#noreplay" + '#@####@#Receive' + '#@####@#network' + '#@####@#' + DateTime.now().toString() + "#@####@#" + "" + '#@####@#' + peerId+'#@####@#'+parts[3]);
            if(message_exists==1){
              return;
            }
            downlordimage(shortmessage, peerId, "group", time,parts[4],parts[3]);
          } else {
            messagelog.addLog(peerId+'#@#&'+time);
            try{
              if(parts[0]=="doc"){
                await downlordpdf(parts[2], peerId, "single",time,parts[4]);
              }else if(parts[0]=="video"){
                dynamic video = parts[2].split('#@#&');
                var file = "" + "#@####@#noreplay#@####@#" + video[0] + "#@#&" + video[1] + '#@####@#Receive' + '#@####@#video' + "#@####@#" + DateTime.now().toString() + "#@####@#" + "" + "#@####@#" + peerId+"#@####@#"+"new";
                logController.addLog(file);
                await  _insert("" + "#@####@#noreplay#@####@#" + video[0]+"#@#&"+video[1], peerId, 'video',time,parts[4]);
              } else{
                logController.addLog(messages + '#@####@#Receive' + '#@####@#network' + '#@####@#' + time + "#@####@#" + "" + '#@####@#' + peerId+'#@####@#'+"");
                if(message_exists==1){
                  return;
                }
                await downlordimage(messages, peerId, "single", "",parts[4],time);
              }}on Exception catch (_){
              logController.addLog(messages + '#@####@#Receive' + '#@####@#network' + '#@####@#' + DateTime.now().toString() + "#@####@#" + "" + '#@####@#' + peerId+'#@####@#'+"");
              if(message_exists==1){
                return;
              }
              await downlordimage(messages, peerId, "single", "",time,parts[4]);
            }
          }
        }
      } else {
        if (control_Log) {
          if (smallString == 'group') {
            dynamic parts = message.text.split('#@####@#');
            groupmessagelog.addLog(parts[4]);
            var shortmessage = parts[0] + '#@####@#' + parts[1] + '#@####@#' + parts[2] + '#@####@#' + time;
            logController.addLog(shortmessage + '#@####@#Receive' + '#@####@#text' + '#@####@#' +parts[5] + '#@####@#' + "" + '#@####@#' + peerId+'#@####@#'+parts[4]);
            await _insertgroup(shortmessage, peerId, 'text', parts[4],parts[3]);
          } else {
            print("messagereceived"+messages);
            messagelog.addLog(peerId+'#@#&'+time);
            logController.addLog(messages + '#@####@#Receive' + '#@####@#text' + '#@####@#' + time + "#@####@#" + "" + '#@####@#' + peerId+'#@####@#'+"new");
            if(message_exists){
              return;
            }
            await _insert(messages, peerId, 'text',time,parts[4]);
          }
        }
      }
      control_Log = true;
    };
    _client.onConnectionStateChanged = (int state, int reason) {
      if (kDebugMode) {
        print('Connection state changed: ' + state.toString() + ', reason: ' + reason.toString());
      }
      if (state == 5) {
        _client.logout();
        print("logout");
      }
    };
  }

  _insert(String _peerMessage, String peerid, String type,time,textid) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.Id: null,
      DatabaseHelper.message: _peerMessage,
      DatabaseHelper.timestamp: time,
      DatabaseHelper.diraction: 'Receive',
      DatabaseHelper.type: type,
      DatabaseHelper.reply: 'Receive',
      DatabaseHelper.from: userpeerid,
      DatabaseHelper.to: peerid,
      DatabaseHelper.deliveryStatus: "Undelivered",
      DatabaseHelper.textId:textid
    };

    final id = await dbHelper.insert(row);
     print('tab inserted row id: $id');
    return id;
  }

  _insertgroup(String _peerMessage, String peerid, String type, String groupname,time) async {
    dynamic parts = _peerMessage.split('#@####@#');

    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.Id: null,
      DatabaseHelper.message: _peerMessage,
      DatabaseHelper.timestamp: time,
      DatabaseHelper.diraction: '#@####@#Receive',
      DatabaseHelper.type: type,
      DatabaseHelper.reply: 'Receive',
      DatabaseHelper.from: userpeerid,
      DatabaseHelper.to: peerid,
      DatabaseHelper.groupname: groupname
    };
    final id = await dbHelper.groupinsert(row);
    print('inserted row id: $id');
    return id;
  }



}
