import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:evidya/model/chat_model.dart';
import 'package:evidya/screens/messenger/calls/audiocallscreen.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:evidya/utils/AppErrorWidget.dart';
import 'package:flutter/services.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:awesome_notifications/android_foreground_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:evidya/localdb/databasehelper.dart';
import 'package:evidya/network/repository/api_repository.dart';
import 'package:evidya/notificationservice/LocalNotificationService.dart';
import 'package:evidya/resources/app_colors.dart';
// import 'package:evidya/screens/livestreaming/broadcast/TestLiveStream.dart';
// import 'package:evidya/screens/livestreaming/broadcast/audiocallpage.dart';
import 'package:evidya/screens/splash/splash_screen.dart';
import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:evidya/utils/helper.dart';
import 'package:evidya/utils/screen_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:image_downloader/image_downloader.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';
import 'package:sizer/sizer.dart';
import 'firebase_options.dart';
import 'localization/app_translations_delegate.dart';
import 'localization/application.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/messenger/calls/videocallscreen.dart';
import 'screens/messenger/logs.dart';
import 'screens/messenger/tabview.dart';

showOnLock(bool show) async {
  const String method_channel = 'Lockscreen flag';
  const platform = MethodChannel(method_channel);
  await platform.invokeMethod('startNewActivity', {
    'flag': show ? 'on' : 'off',
  });
}

Future<void> backgroundHandler(RemoteMessage message) async {
  // print('listen a terminate message ${message.data}');
  var type = message.data['type'];
  if (type == 'basic_channel') {
    // LocalNotificationService.showNotification(message);
    insertLocaldataFromFirebase(message, true);
  } else if (type == 'call_channel') {
    // print('listen a background and not terminated message123 ${message.data}');
    LocalNotificationService.callkitNotification(message);
  } else if (type == 'cut') {
    await FlutterCallkitIncoming.endAllCalls();
    callcutSpref();
  }
}

Future<ChatModel> _handleChatModelMessege(String text) async {
  if (text.startsWith('{')) {
    try {
      final prefs = await SharedPreferences.getInstance();

      ChatModel model = ChatModel.fromJson(jsonDecode(text));
      model.diraction = 'Receive';
      if (model.group != null && model.group.isNotEmpty) {
        if (model.type == 'image') {
          model.type = 'network';
        }
        int id = await _insertGroupToDb(model.to, model);
        if (id > 0) {
          await prefs.setBool('groupbadge', true);
        }
      } else {
        if (model.type == 'image') {
          model.type = 'network';
        }
        int id = await _insertToDb(model.to, model);
        if (id < 0) {}
      }
      return model;
    } on Exception catch (_) {
      print('Error in parsing data');
    }
  }
  return null;
}

void insertLocaldataFromFirebase(
    RemoteMessage message, bool showNotification) async {
  ChatModel model = await _handleChatModelMessege(message.data['body']);

  if (model != null) {
    print('model  found $showNotification');
    if (showNotification) {
      LocalNotificationService.showNotificationModel(model, message);
    }
    return;
  }
  print('model not found');
  if (showNotification) {
    // LocalNotificationService.showNotification(message);
  }
}

void callcutSpref() async {
  SharedPreferencesAndroid.registerWith();
  {
    final prefs = await SharedPreferences.getInstance();
    PreferenceConnector().setcall('callscreen');
    await prefs.setInt('audiocall', 20);
  }
  SharedPreferencesAndroid.registerWith();
  {
    final prefs = await SharedPreferences.getInstance();
    PreferenceConnector().setvideocall('videocall');
    await prefs.setInt('counter', 10);
  }
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
    DatabaseHelper.from: model.from,
    DatabaseHelper.replyText: model.replyText,
    DatabaseHelper.to: peerid ?? '',
    DatabaseHelper.groupname: model.group,
    // DatabaseHelper.deliveryStatus: 'Undelivered',
    DatabaseHelper.textId: model.textId,
    DatabaseHelper.url: model.url ?? ''
  };
  final dbHelper = DatabaseHelper.instance;
  final id = await dbHelper.groupinsert(row);
  print(' inserted row id: $id');
  return id;
}

_insertToDb(String peerid, ChatModel model) async {
  // row to insert
  Map<String, dynamic> row = {
    DatabaseHelper.Id: null,
    DatabaseHelper.message: model.message,
    DatabaseHelper.timestamp: model.timestamp,
    DatabaseHelper.diraction: 'Receive',
    DatabaseHelper.type: model.type,
    DatabaseHelper.reply: model.reply,
    DatabaseHelper.replyText: model.replyText,
    DatabaseHelper.from: model.from,
    DatabaseHelper.to: peerid,
    DatabaseHelper.deliveryStatus: 'Undelivered',
    DatabaseHelper.textId: model.textId,
    DatabaseHelper.url: model.url
  };
  final dbHelper = DatabaseHelper.instance;
  final id = await dbHelper.insert(row);
  print('MA inserted row id: $id ${model.message}');
  return id;
}

Future<void> main() async {
  // In dev mode, show error details
  // In release builds, show a only custom error message
  bool isDev = true;
  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return AppErrorWidget(
      errorDetails: errorDetails,
      isDev: isDev,
    );
  };

  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  if (Platform.isAndroid) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  AwesomeNotifications().initialize(
      null /*'resource://drawable/res_app_icon'*/,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Color(0xFF800000),
          enableLights: true,
          channelShowBadge: true,
          importance: NotificationImportance.Max,
          ledColor: Colors.white,
        ),
        NotificationChannel(
            channelGroupKey: 'category_tests',
            channelKey: 'call_channel',
            channelName: 'call_channel',
            enableVibration: true,
            channelDescription: 'Channel with call ringtone',
            defaultColor: Color(0xFF800000),
            importance: NotificationImportance.Max,
            ledColor: Colors.white,
            channelShowBadge: true,
            locked: true,
            soundSource: 'resource://raw/telephone'),
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'basic_tests', channelGroupName: 'Basic tests'),
        NotificationChannelGroup(
            channelGroupkey: 'category_tests',
            channelGroupName: 'Category tests'),
      ],
      debug: true);

  runApp(const Sizerapp());
}

class Sizerapp extends StatelessWidget {
  const Sizerapp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sizer',
          theme: ThemeData.light().copyWith(
              textTheme:
                  GoogleFonts.assistantTextTheme(Theme.of(context).textTheme)),
          home: MyApp(),
          builder: EasyLoading.init(),
        );
      },
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  MyAppState createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  AppTranslationsDelegate _newLocaleDelegate;
  final dbHelper = DatabaseHelper.instance;
  var appstate = true;
  bool background = false;
  String _currentUuid, _currentname, _currentcalltype;
  var clicked = true;
  ClassLog classlog = ClassLog();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    checkAndNavigationCallingPage();
    firebase();
    _newLocaleDelegate = const AppTranslationsDelegate(newLocale: null);
    application.onLocaleChanged = onLocaleChange;
    AwesomeNotifications().actionStream.listen((receivedAction) async {
      if (receivedAction.channelKey == 'basic_channel') {
        // LocalNotificationService.messageIncrement = 0;
        if (receivedAction.payload['from']?.isNotEmpty == true) {
          final code = receivedAction.payload['from'].hashCode;
          LocalNotificationService.clearPool(code);
        }
        if (receivedAction.payload['peerid'] == 'group') {
          await Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => MessengerTab(
                    rtmpeerid: receivedAction.payload['name'],
                  )));
        } else {
          await Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => MessengerTab(
                    rtmpeerid: receivedAction.payload['peerid'],
                  )));
        }
        // Navigator.pushAndRemoveUntil<dynamic>(context, MaterialPageRoute<dynamic>(builder: (BuildContext context) => messengertab(rtmpeerid: receivedAction.payload['peerid']),), (route) => false,//if you want to disable back feature set to false);
        return;
      }
    });

    FlutterCallkitIncoming.onEvent.listen((event) async {
      switch (event.name) {
        case CallEvent.ACTION_CALL_INCOMING:
          // print('onIncoming');
          showOnLock(true);

          break;
        case CallEvent.ACTION_CALL_ENDED:
          // showOnLock(false);
          break;
        case CallEvent.ACTION_CALL_ACCEPT:
          // showOnLock(true);
          final callType = event.body['extra']['calltype'] ?? '';
          if (callType == 'video') {
            await _callinsert(
                event.body['extra']['username'], 'video', 'Received_Call');
            await Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => VideoCallScreen(
                  callid: event.body['extra']['callid'],
                  calleeName: event.body['username'],
                ),
              ),
            );
            await AndroidForegroundService.stopForeground();
          } else if (callType == 'audio') {
            await _callinsert(
                event.body['extra']['username'], 'audio', 'Received_Call');
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    AudioCallScreen(callid: event.body['extra']['callid'])));
            await AndroidForegroundService.stopForeground();
          }
          break;
        case CallEvent.ACTION_CALL_DECLINE:
          showOnLock(false);
          _callinsert(event.body['extra']['username'],
              event.body['extra']['calltype'], 'Missed_Call');
          fcmapicall('call_cut', event.body['extra']['fcmtoken'],
              'W1CFA5GNwGzfX7uItWmL', event.body['extra']['callid'], 'cut');
          break;
      }
    });
  }

  getCurrentCall() async {
    //check current call from pushkit if possible
    var calls = await FlutterCallkitIncoming.activeCalls();
    if (calls is List) {
      if (calls.isNotEmpty) {
        _currentUuid = calls[0]['extra']['callid'];
        _currentname = calls[0]['extra']['username'];
        _currentcalltype = calls[0]['extra']['calltype'];
        return calls[0];
      } else {
        _currentUuid = '';
        return null;
      }
    }
  }

  checkAndNavigationCallingPage() async {
    var currentCall = await getCurrentCall();
    if (currentCall != null) {
      showOnLock(true);
      AndroidForegroundService.stopForeground();
      if (_currentcalltype == 'video') {
        _callinsert(_currentUuid, 'video', 'Received_Call');
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => VideoCallScreen(
                callid: _currentUuid, calleeName: _currentname)));
        AndroidForegroundService.stopForeground();
      } else if (_currentcalltype == 'audio') {
        _callinsert(_currentname, 'audio', 'Received_Call');
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AudioCallScreen(callid: _currentUuid.toString());
        }));
        AndroidForegroundService.stopForeground();
      }
    }
    await FlutterCallkitIncoming.endAllCalls();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      print('Hello I m here background');
      background = true;
    }

    if (state == AppLifecycleState.detached) {
      print('Hello I m here in termination');
      WidgetsFlutterBinding.ensureInitialized();
      FirebaseMessaging.onBackgroundMessage(backgroundHandler);

      if (Platform.isAndroid) {
        Firebase.initializeApp();
      } else {
        Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      }

      background = false;
    }
  }

  void fcmapicall(String msg, String fcmtoken, image, callId, type) {
    Helper.checkConnectivity().then((value) => {
          if (value)
            {
              ApiRepository()
                  .fcmnotifiction(
                      msg,
                      'Prashant',
                      fcmtoken,
                      image,
                      callId,
                      type,
                      'YnM4cS5SKywCKuAPCKsp8:APA91bEEe51mZfYEX7dMqt-uUgpel4Qbahse2NPFqN1VG3p0SMHxeEKpfrQIj9HLtRqAChV2M8_-I...',
                      'users/yS9WcV3LjdpGSKpkcsdw0npvVmTw2lH5TdJk4t6D.jpeg',
                      '',
                      'senderpeerid',
                      'receiverpeerid',
                      'textid')
                  .then((value) {})
            }
          else
            {Helper.showNoConnectivityDialog(context)}
        });
  }

  Future<void> _callinsert(
      String calleeName, String calltype, String Calldrm) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.Id: null,
      DatabaseHelper.calleeName: calleeName,
      DatabaseHelper.timestamp: DateTime.now().toString(),
      DatabaseHelper.calltype: calltype,
      DatabaseHelper.Calldrm: Calldrm,
    };
    final id = await dbHelper.callinsert(row);
    print('inserted row id: $id');
    return id;
  }

  void firebase() async {
    // 1. This method only call when App in background it mean app must be closed
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) async {
        print('FirebaseMessaging.instance.getInitialMessage');
        if (message == null) return;
        if (message.data['type'] == 'basic_channel') {
          // downloadFromFirebase(message);
          insertLocaldataFromFirebase(message, false);
        } else if (message.data['type'] == 'call_channel') {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('audiocall', 0);
          await prefs.setInt('counter', 0);
          //Vibrate.vibrate();
          // LocalNotificationService.showCallNotification(message.data);
          LocalNotificationService.callkitNotification(message);
          //  LocalNotificationService.misscallkitNotification(message);
        } else if (message.data['type'] == 'cut') {
          callcutSpref();
          await FlutterCallkitIncoming.endAllCalls();
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) async {
        //SharedPreferences prefs = await SharedPreferences.getInstance();
        // var chatUserName = prefs.getString('chatUserName') ?? '';
        // print('Chat User Name $chatUserName');

        print('listen a forground message ${message.data}');
        var type = message.data['type'];
        if (type == 'basic_channel') {
          // downloadFromFirebase(message);

          final prefs = await SharedPreferences.getInstance();
          final String action = prefs.getString('action');
          print('object:$action');
          insertLocaldataFromFirebase(
              message,
              (action != message.data['senderpeerid'] &&
                  action != message.data['title']));
        } else if (type == 'call_channel') {
          Vibrate.vibrate();

          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('audiocall', 0);
          await prefs.setInt('counter', 0);
          LocalNotificationService.callkitNotification(message);
        } else if (type == 'cut') {
          await FlutterCallkitIncoming.endAllCalls();
          callcutSpref();
        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) async {
        print('listen a background and not terminated message ${message.data}');
        if (message.data != null) {
          if (message.data['type'] == 'basic_channel') {
            // downloadFromFirebase(message);
            insertLocaldataFromFirebase(message, false);
            // insert(message.data['body'],message.data['senderpeerid'], 'text',message.data['datetime'],message.data['receiverpeerid'],message.data['textid']);
            // LocalNotificationService.showNotification(message);
          } else if (message.data['type'] == 'call_channel') {
            //Vibrate.vibrate();
            // LocalNotificationService.showCallNotification(message.data);
            final prefs = await SharedPreferences.getInstance();
            // final String action = prefs.getString('action');
            await prefs.setInt('audiocall', 0);
            await prefs.setInt('counter', 0);
            LocalNotificationService.callkitNotification(message);
            //  LocalNotificationService.misscallkitNotification(message);
          } else if (message.data['type'] == 'cut') {
            await FlutterCallkitIncoming.endAllCalls();

            callcutSpref();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'bVidya',
      // checkerboardOffscreenLayers: true,
      theme: ThemeData(
        primaryColor: AppColors.redColor,
      ).copyWith(
          textTheme:
              GoogleFonts.assistantTextTheme(Theme.of(context).textTheme)),
      onGenerateRoute: ScreenRouter.generateRoute,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      localizationsDelegates: [
        _newLocaleDelegate,
        //provides localised strings
        GlobalMaterialLocalizations.delegate,
        //provides RTL support
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('es', ''),
      ],
    );
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }

  // void downloadFromFirebase(RemoteMessage message) async {
  //   if (message.data['image'] != '') {
  //     var urlLength = message.data['image'].length;
  //     var type =
  //         message.data['image'].toString().substring(urlLength - 3, urlLength);
  //     if (type != 'pdf' || type != 'mp4') {
  //       //  await downlordimage('' + '#@####@#replay#@####@#' + message.data['image'], message.data['senderpeerid'], '', 'image', message.data['datetime'], message.data['textid'], message.data['receiverpeerid'],);
  //     }
  //   } else {
  //     // insert(
  //     //   message.data['body'],
  //     //   message.data['senderpeerid'],
  //     //   'text',
  //     //   message.data['datetime'],
  //     //   message.data['receiverpeerid'],
  //     //   message.data['textid'],
  //     // );
  //   }
  // }
}
