import 'dart:convert';
// import 'dart:io';
import 'package:evidya/model/chat_model.dart';
// import 'package:http/http.dart' as http;
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
// import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessengerTab extends StatefulWidget {
  final String rtmpeerid;

  const MessengerTab({Key key, this.rtmpeerid}) : super(key: key);

  @override
  _MessengerTabState createState() => _MessengerTabState();
}

class _MessengerTabState extends State<MessengerTab>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  AgoraRtmClient _client;
  LogController logController = LogController();
  GroupLongController groupLogController = GroupLongController();
  ClassLog classlog = ClassLog();
  MessageLog messagelog = MessageLog();
  GroupMessageLog groupmessagelog = GroupMessageLog();
  final String appId = "d6306b59624c4e458883be16f5e6cbd2";
  String userpeerid = "123";
  String deviceTokenToSendPushNotification = "";
  final dbHelper = DatabaseHelper.instance;
  // TabController _tabController;
  ImagePicker picker = ImagePicker();
  // bool control_Log = true;
  var name = " ";
  String image, token;
  var fullname;
  bool _haBuildCalled = false;

  @override
  void initState() {
    _sharedPreferencedata();
    _createClient();
    // _tabController = TabController(length: 3, vsync: this);
    _gettoken();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    _client?.logout();
    print("logout");
  }

  @override
  Widget build(BuildContext context) {
    _haBuildCalled = true;
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
                groupLogController: groupLogController,
                clientpeerid: widget.rtmpeerid,
                groupmessageLog: groupmessagelog),
          ],
        ),
      ),
    );
  }

  void _sharedPreferencedata() async {
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
                        // setState(() {
                        _login(value.body.rtmToken, value.body.rtmUser);
                        userpeerid = value.body.rtmUser;
                        if (value.body.rtmUser != null) {
                          PreferenceConnector
                              .setJsonToSharedPreferencertmuserpeerid(
                                  StringConstant.rtmuserpeerid,
                                  value.body.rtmUser);
                        }
                        if (_haBuildCalled) {
                          setState(() {});
                        }
                        // });
                      } else {
                        Helper.showMessage("No Result found");
                      }
                    }
                  })
                }
            });
  }

  void _login(String token, String userid) async {
    try {
      await _client.login(token, userid);
      // print('Login success: ' + userid);
      //_createClient();
    } catch (errorCode) {
      _login(token, userid);
      print('Login error: ' + errorCode.toString());
    }
  }

  // Future<void> downloadDoc(ChatModel model, String peerid) async {
  //   if (model.type != 'doc') {
  //     return;
  //   }
  //   List<String> names = model.message.split('#@#&');
  //   if (names.length == 2) {
  //     final name = names[1];
  //     final url = names[0];

  //     final directory = await getApplicationDocumentsDirectory();
  //     final file = File('${directory.path}/$name');
  //     final response = await http.get(Uri.parse(url));
  //     await file.writeAsBytes(response.bodyBytes);
  //     var filepath = file.path;
  //     model.message = filepath + '#@#&' + name;
  //     _insertToDb(peerid, model);
  //   }
  // }

  Future<bool> downloadimage(ChatModel model, String peerid) async {
    if (model.url == null || !model.url.startsWith('http')) {
      return true;
    }
    final url = model.url;
    if (model.type == 'image') {
      var imageId = await ImageDownloader.downloadImage(url);
      if (imageId == null) {
        return true;
      }
      var fileName = await ImageDownloader.findName(imageId);
      var path = await ImageDownloader.findPath(imageId);
      model.message = fileName;
      model.url = path;
      return true;
    }
  }

  // Future<void> downlordimage(
  //     String file, String peerid, group, groupname, textid, time) async {
  //   try {
  //     if (group == "group") {
  //       dynamic parts = file.split('#@####@#');
  //       var imageId = await ImageDownloader.downloadImage(parts[1]);
  //       if (imageId == null) {
  //         return;
  //       }
  //       //_insert(message.text,peerId,'image');
  //       // Below is a method of obtaining saved image information.
  //       var fileName = await ImageDownloader.findName(imageId);
  //       // print('filename' + fileName);
  //       var path = await ImageDownloader.findPath(imageId);
  //       _insertgroup(
  //           "group#@####@#" + path.toString() + "#@####@#noreplay#@####@#",
  //           peerid,
  //           'image',
  //           groupname,
  //           time,
  //           textid);
  //       var size = await ImageDownloader.findByteSize(imageId);
  //       // print('size' + size.toString());
  //       var mimeType = await ImageDownloader.findMimeType(imageId);
  //       // print('mimetype' + mimeType);
  //       // Obtain shared preferences.
  //       final prefs = await SharedPreferences.getInstance();
  //       await prefs.setBool('groupbadge', true);
  //     } else {
  //       dynamic parts = file.split('#@####@#');
  //       var imageId = await ImageDownloader.downloadImage(parts[2]);
  //       if (imageId == null) {
  //         return;
  //       }
  //       //_insert(message.text,peerId,'image');
  //       // Below is a method of obtaining saved image information.
  //       var fileName = await ImageDownloader.findName(imageId);
  //       // print('filename' + fileName);
  //       var path = await ImageDownloader.findPath(imageId);
  //       // print('path' + path);
  //       _insert("" + "#@####@#noreplay#@####@#" + path.toString(), peerid,
  //           'image', time, textid);
  //       var size = await ImageDownloader.findByteSize(imageId);
  //       // print('size' + size.toString());
  //       var mimeType = await ImageDownloader.findMimeType(imageId);
  //       //  print('mimetype' + mimeType);
  //     }
  //   } on PlatformException catch (error) {
  //     print(error);
  //   }
  // }

  // Future<void> downlordpdf(
  //     String pdfurl, String peerid, group, time, groupname) async {
  //   var name;
  //   dynamic pdffilepath;
  //   var url;
  //   try {
  //     if (group == "group") {
  //       dynamic parts = pdfurl.split('/');
  //       name = parts[parts.length - 1];
  //       url = pdfurl;
  //     } else {
  //       pdffilepath = pdfurl.split('#@#&');
  //       name = pdffilepath[1];
  //     }
  //     final directory = await getApplicationDocumentsDirectory();
  //     final file = File('${directory.path}/$name');
  //     var response;
  //     if (group == "group") {
  //       response = await http.get(Uri.parse(url));
  //     } else {
  //       response = await http.get(Uri.parse(pdffilepath[0]));
  //     }
  //     await file.writeAsBytes(response.bodyBytes);
  //     var filepath = file.path;
  //     if (group == "group") {
  //       //  logController.addLog("group"+"#@####@#"+pdfurl + "#@####@#noreplay" + '#@####@#Receive' + '#@####@#network' + '#@####@#' + "" + "#@####@#" + time + '#@####@#' + peerid+'#@####@#'+time+'#@####@#'+groupname);
  //       _insertgroup(
  //           "group" +
  //               "#@####@#" +
  //               filepath.toString() +
  //               "#@#&" +
  //               name +
  //               "#@####@#noreplay#@####@#",
  //           peerid,
  //           'doc',
  //           groupname,
  //           time,
  //           "");
  //       // Obtain shared preferences.
  //       final prefs = await SharedPreferences.getInstance();
  //       await prefs.setBool('groupbadge', true);
  //     } else {
  //       // logController.addLog("#@####@#noreplay#@####@#" +
  //       //     filepath.toString() +
  //       //     "#@#&" +
  //       //     name +
  //       //     '#@####@#Receive' +
  //       //     '#@####@#doc' +
  //       //     '#@####@#' +
  //       //     DateTime.now().toString() +
  //       //     "#@####@#" +
  //       //     "" +
  //       //     '#@####@#' +
  //       //     peerid +
  //       //     '#@####@#');
  //       _insert(
  //           "" +
  //               "#@####@#noreplay#@####@#" +
  //               filepath.toString() +
  //               "#@#&" +
  //               name,
  //           peerid,
  //           'doc',
  //           time,
  //           groupname);
  //     }
  //   } on PlatformException catch (error) {
  //     print(error);
  //   }
  // }

  void _createClient() async {
    String time = '';

    logController.clear();
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    _client = await AgoraRtmClient.createInstance(appId);
    _client.onMessageReceived = (AgoraRtmMessage message, String peerId) async {
      // print('message111i: ${message.text} $peerId');
      try {
        ChatModel model = ChatModel.fromJson(jsonDecode(message.text));
        model.diraction = 'Receive';
        if (model.group != null && model.group.isNotEmpty) {
          // final exist = await dbHelper.isTextIdPresentInGroup(model.textId);
          // if (exist == 1) return;
          final prevId = await dbHelper.getGroupExistId(model.textId);
          if (prevId != null && prevId > 0) {
            model.id = prevId.toString();
            groupLogController.addLog(model);
            return;
          }
          await prefs.setBool('groupbadge', true);

          final id = await _insertGroupToDb(peerId, model);
          // if (id < 0) return;
          model.id = id.toString();
          if (model.type == 'image' && model.url?.isNotEmpty == true) {
            RegExp fileExp = RegExp(
                r"(http(s?):)([/|.|\w|\s|-])*\.(?:jpg|gif|png|jpeg|pdf|mp4)");
            dynamic isfile = fileExp.hasMatch(model.url);
            if (isfile) {
              downloadimage(model, peerId);
              model.type = 'network';
            }
          }
          groupLogController.addLog(model);
        } else {
          final prevId = await dbHelper.getExistId(model.textId);
          if (prevId != null && prevId > 0) {
            print('already present at:$prevId');
            model.id = prevId.toString();
            logController.addLog(model);
            return;
          }
          model.from = peerId;
          model.to = userpeerid;
          time = model.timestamp;

          messagelog.addLog(peerId + '#@#&' + time);

          final id = await _insertToDb(peerId, model);
          model.id = id.toString();
          if (model.type == 'image' && model.url?.isNotEmpty == true) {
            RegExp fileExp = RegExp(
                r"(http(s?):)([/|.|\w|\s|-])*\.(?:jpg|gif|png|jpeg|pdf|mp4)");
            dynamic isfile = fileExp.hasMatch(model.url);
            if (isfile) {
              downloadimage(model, peerId);
              model.type = 'network';
            }
          }
          // RegExp fileExp = RegExp(
          //     r"(http(s?):)([/|.|\w|\s|-])*\.(?:jpg|gif|png|jpeg|pdf|mp4)");
          // dynamic isfile = fileExp.hasMatch(model.url);
          // if (isfile && model.type == 'image') {
          //   downloadimage(model, peerId);
          //   model.type = 'network';
          // }
          logController.addLog(model);
        }
        return;
      } on Exception catch (_) {
        print('Error in parsing data');
      }
      // }
      // RegExp fileExp =
      //     RegExp(r"(http(s?):)([/|.|\w|\s|-])*\.(?:jpg|gif|png|jpeg|pdf|mp4)");
      // dynamic isfile = fileExp.hasMatch(message.text);
      // String smallString = message.text.substring(0, 5);
      // dynamic parts = message.text.split('#@####@#');
      // String messages =
      //     parts[0] + "#@####@#" + parts[1] + "#@####@#" + parts[2];
      // groupmessagelog.addLog(parts[2]);
      // dynamic messageExists = await dbHelper.is_message_exists(parts[4]);
      // if (parts[3].toString() == "noreplay") {
      //   time = parts[5].toString().substring(0, 16);
      // } else {
      //   time = parts[3].toString().substring(0, 16);
      // }
      // var shortmessage =
      //     parts[0] + "#@####@#" + parts[1] + "#@####@#" + parts[2];
      // if (isfile) {
      //   // if (control_Log)
      //   {
      //     if (smallString == 'group') {
      //       dynamic parts = message.text.split('#@####@#');
      //       if (messageExists == 1) {
      //         return;
      //       }
      //       var urlLength = parts[1].toString().length;
      //       var type = parts[1].toString().substring(urlLength - 3, urlLength);
      //       if (type == "pdf") {
      //         logController.addLog(shortmessage +
      //             "#@####@#noreplay" +
      //             '#@####@#Receive' +
      //             '#@####@#doc' +
      //             '#@####@#' +
      //             parts[4] +
      //             "#@####@#" +
      //             parts[3] +
      //             '#@####@#' +
      //             peerId +
      //             '#@####@#' +
      //             parts[3]);
      //         await downlordpdf(parts[1], peerId, "group", parts[4], parts[3]);
      //       } else if (type == "mp4") {
      //         logController.addLog(shortmessage +
      //             "#@####@#noreplay" +
      //             '#@####@#Receive' +
      //             '#@####@#video' +
      //             '#@####@#' +
      //             parts[4] +
      //             "#@####@#" +
      //             parts[3] +
      //             '#@####@#' +
      //             peerId +
      //             '#@####@#' +
      //             parts[3]);
      //         dynamic part = parts[1].split('/');
      //         var name = part[part.length - 1];
      //         _insertgroup(
      //             "group" +
      //                 "#@####@#" +
      //                 parts[1] +
      //                 "#@#&" +
      //                 name +
      //                 "#@####@#" +
      //                 "noreplay#@####@#" +
      //                 parts[4],
      //             peerId,
      //             'video',
      //             parts[3],
      //             parts[4],
      //             part[5]);
      //       } else {
      //         logController.addLog(shortmessage +
      //             "#@####@#noreplay" +
      //             '#@####@#Receive' +
      //             '#@####@#network' +
      //             '#@####@#' +
      //             DateTime.now().toString() +
      //             "#@####@#" +
      //             "" +
      //             '#@####@#' +
      //             peerId +
      //             '#@####@#' +
      //             parts[3]);
      //         downlordimage(
      //             shortmessage, peerId, "group", parts[3], parts[5], parts[4]);
      //       }
      //       await prefs.setBool('groupbadge', true);
      //     } else {
      //       messagelog.addLog(peerId + '#@#&' + time);
      //       try {
      //         if (parts[0] == "doc") {
      //           await downlordpdf(parts[2], peerId, "single", time, parts[4]);
      //         } else if (parts[0] == "video") {
      //           dynamic video = parts[2].split('#@#&');
      //           var file = "" +
      //               "#@####@#noreplay#@####@#" +
      //               video[0] +
      //               "#@#&" +
      //               video[1] +
      //               '#@####@#Receive' +
      //               '#@####@#video' +
      //               "#@####@#" +
      //               DateTime.now().toString() +
      //               "#@####@#" +
      //               "" +
      //               "#@####@#" +
      //               peerId +
      //               "#@####@#" +
      //               "new";
      //           // logController.addLog(file);
      //           await _insert(
      //               "" +
      //                   "#@####@#noreplay#@####@#" +
      //                   video[0] +
      //                   "#@#&" +
      //                   video[1],
      //               peerId,
      //               'video',
      //               time,
      //               parts[4]);
      //         } else {
      //           // logController.addLog(messages +
      //           //     '#@####@#Receive' +
      //           //     '#@####@#network' +
      //           //     '#@####@#' +
      //           //     time +
      //           //     "#@####@#" +
      //           //     "" +
      //           //     '#@####@#' +
      //           //     peerId +
      //           //     '#@####@#' +
      //           //     "");
      //           if (messageExists == 1) {
      //             return;
      //           }
      //           await downlordimage(
      //               messages, peerId, "single", "", parts[4], time);
      //         }
      //       } on Exception catch (_) {
      //         // logController.addLog(messages +
      //         //     '#@####@#Receive' +
      //         //     '#@####@#network' +
      //         //     '#@####@#' +
      //         //     DateTime.now().toString() +
      //         //     "#@####@#" +
      //         //     "" +
      //         //     '#@####@#' +
      //         //     peerId +
      //         //     '#@####@#' +
      //         //     "");
      //         if (messageExists == 1) {
      //           return;
      //         }
      //         await downlordimage(
      //             messages, peerId, "single", "", time, parts[4]);
      //       }
      //     }
      //   }
      // } else {
      //   // if (control_Log)
      //   {
      //     if (smallString == 'group') {
      //       dynamic parts = message.text.split('#@####@#');
      //       groupmessagelog.addLog(parts[4]);
      //       var shortmessage = parts[0] +
      //           '#@####@#' +
      //           parts[1] +
      //           '#@####@#' +
      //           parts[2] +
      //           '#@####@#' +
      //           time;
      //       logController.addLog(shortmessage +
      //           '#@####@#Receive' +
      //           '#@####@#text' +
      //           '#@####@#' +
      //           parts[5] +
      //           '#@####@#' +
      //           "" +
      //           '#@####@#' +
      //           peerId +
      //           '#@####@#' +
      //           parts[4]);
      //       await _insertgroup(
      //           shortmessage, peerId, 'text', parts[4], parts[3], parts[6]);
      //       await prefs.setBool('groupbadge', true);
      //     } else {
      //       messagelog.addLog(peerId + '#@#&' + time);
      //       // logController.addLog(messages +
      //       //     '#@####@#Receive' +
      //       //     '#@####@#text' +
      //       //     '#@####@#' +
      //       //     time +
      //       //     "#@####@#" +
      //       //     "" +
      //       //     '#@####@#' +
      //       //     peerId +
      //       //     '#@####@#' +
      //       //     "new");
      //       if (messageExists == 1) {
      //         return;
      //       }
      //       await _insert(messages, peerId, 'text', time, parts[4]);
      //     }
      //   }
      // }
      // control_Log = true;
    };

    _client.onConnectionStateChanged = (dynamic state, dynamic reason) {
      if (kDebugMode) {
        print('Connection state changed: ' +
            state.toString() +
            ', reason: ' +
            reason.toString());
      }
      if (state == 5) {
        _client.logout();
        print("logout");
      }
    };
  }

  // _insert(String _peerMessage, String peerid, String type, time, textid) async {
  //   // row to insert
  //   Map<String, dynamic> row = {
  //     DatabaseHelper.Id: null,
  //     DatabaseHelper.message: _peerMessage,
  //     DatabaseHelper.timestamp: time,
  //     DatabaseHelper.diraction: 'Receive',
  //     DatabaseHelper.type: type,
  //     DatabaseHelper.reply: 'Receive',
  //     DatabaseHelper.from: userpeerid,
  //     DatabaseHelper.to: peerid,
  //     DatabaseHelper.deliveryStatus: "Undelivered",
  //     DatabaseHelper.textId: textid
  //   };

  //   final id = await dbHelper.insert(row);
  //   print('tab inserted row id: $id');
  //   return id;
  // }

  _insertToDb(String peerid, ChatModel model) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.Id: null,
      DatabaseHelper.message: model.message,
      DatabaseHelper.timestamp: model.timestamp,
      DatabaseHelper.diraction: 'Receive',
      DatabaseHelper.type: model.type,
      DatabaseHelper.reply: model.reply,
      DatabaseHelper.from: userpeerid,
      DatabaseHelper.to: peerid,
      DatabaseHelper.replyText: model.replyText,
      DatabaseHelper.deliveryStatus: "Undelivered",
      DatabaseHelper.textId: model.textId,
      DatabaseHelper.url: model.url
    };

    final id = await dbHelper.insert(row);
    // print('INSERTED: $id ${model.toJson()}');
    return id;
  }

  _insertGroupToDb(String peerid, ChatModel model) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.Id: null,
      DatabaseHelper.message: model.message,
      DatabaseHelper.timestamp: model.timestamp,
      DatabaseHelper.diraction: 'Receive',
      DatabaseHelper.type: model.type,
      DatabaseHelper.reply: model.reply,
      DatabaseHelper.replyText: model.replyText,
      DatabaseHelper.from: userpeerid,
      DatabaseHelper.to: peerid,
      DatabaseHelper.groupname: model.group,
      DatabaseHelper.textId: model.textId,
      DatabaseHelper.url: model.url
    };

    final id = await dbHelper.groupinsert(row);
    // print('tab inserted row id: $id');
    return id;
  }

  // _insertgroup(String _peerMessage, String peerid, String type,
  //     String groupname, time, textid) async {
  //   // row to insert
  //   Map<String, dynamic> row = {
  //     DatabaseHelper.Id: null,
  //     DatabaseHelper.message: _peerMessage,
  //     DatabaseHelper.timestamp: time,
  //     DatabaseHelper.diraction: '#@####@#Receive',
  //     DatabaseHelper.type: type,
  //     DatabaseHelper.reply: 'Receive',
  //     DatabaseHelper.from: userpeerid,
  //     DatabaseHelper.to: peerid,
  //     DatabaseHelper.groupname: groupname,
  //     DatabaseHelper.textId: textid
  //   };
  //   final id = await dbHelper.groupinsert(row);
  //   print('inserted row id: $id');
  //   return id;
  // }
}
