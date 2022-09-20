import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:evidya/constants/color_constant.dart';
import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/model/login/PrefranceData.dart';
import 'package:evidya/network/repository/api_repository.dart';
import 'package:evidya/resources/app_colors.dart';
import 'package:evidya/resources/dimens.dart';
import 'package:evidya/screens/bottom_navigation/bottom_navigaction_bar.dart';
import 'package:evidya/screens/livestreaming/broadcast/CallPage.dart';

//import 'package:evidya/screens/broadcast/CallPage.dart';
import 'package:evidya/screens/meet/meeting/StartMeetScreen/startmeetscreen.dart';
import 'package:evidya/sharedpref/preference_connector.dart';

//import 'package:share/share.dart';
import 'package:evidya/utils/selectabletext.dart';
import 'package:evidya/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:intl/intl.dart';

//import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:custom_progress_dialog/custom_progress_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

class Helper {
  static printLogValue(dynamic value) {}

  static void showMessage(String message) {}

  static void showAlert(BuildContext context, String title, String errorMsg,
      String meetingid, String startedtime, String id, var video, var audio) {
    showDialog(
      context: context,
      //barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Scheduled Meeting",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold),
              ),
              InkWell(
                child: Icon(
                  Icons.cancel,
                  size: 25,
                  color: AppColors.redColor,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
          content: Wrap(
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      "Subject :",
                      style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Date :",
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              startedtime.split(" ")[0],
                              style: TextStyle(
                                  fontSize: 14.sp, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Time :",
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              DateFormat.jm().format(
                                  DateTime.parse(startedtime.toString())),
                              style: TextStyle(
                                  fontSize: 14.sp, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                  ]),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 25.w,
                    child: ElevatedButton(
                        child: Text(
                          "Share",
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          _onShareWithEmptyFields(
                              context, meetingid, "Meeting");
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.white),
                            )))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 25.w,
                    child: GestureDetector(
                        onTap: () {
                          getToken(context, id, video, audio, meetingid);
                        },
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFF450d35),
                                  Color(0xFF4a0d36),
                                  Color(0xFF4e1141),
                                  Color(0xFF520e35),
                                  Color(0xFF520e35),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  "Start",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: .5),
                                ),
                              ),
                            ),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  static void showblockAlert(
    BuildContext context,
    var userid,
    String name,
  ) {
    showDialog(
      context: context,
      //barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    "Do you want to unblock a $name ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold),
                  )),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 25.w,
                    child: ElevatedButton(
                        child: Text(
                          "No",
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          // _onShareWithEmptyFields(context, meetingid, "Meeting");
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.white),
                            )))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 25.w,
                    child: GestureDetector(
                        onTap: () {
                          // getToken(context, id, video, audio,meetingid);
                        },
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFF450d35),
                                  Color(0xFF4a0d36),
                                  Color(0xFF4e1141),
                                  Color(0xFF520e35),
                                  Color(0xFF520e35),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  "yes",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: .5),
                                ),
                              ),
                            ),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  static _onShareWithEmptyFields(
      BuildContext context, String id, String type) async {
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

  static Future<bool> checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result.first.rawAddress.isNotEmpty) {
        Helper.printLogValue('connected');
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      Helper.printLogValue('not connected');
      return false;
    }
  }

  static showNoConnectivityDialog(BuildContext buildContext) {
    Alert(
      context: buildContext,
      type: AlertType.error,
      title:
          "You are disconnected to the Internet. Please check your internet connection",
      buttons: [
        DialogButton(
          child: Text(
            "Close",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            exit(0);
          },
          color: Colors.black,
        ),
      ],
    ).show();
  }

  static successAlertDialog(
      BuildContext context, bool isShow, String data, String meetingId) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: new Container(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              width: 300.0,
              height: 350.0,
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.transparent,
                borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/images/whitebackground.png")),
              ),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/images/Smile.png",
                    height: 10.h,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Success!",
                    style: TextStyle(
                        fontSize: 17.sp,
                        color: Color(0xFF1da1f2),
                        fontWeight: FontWeight.bold,
                        letterSpacing: .5),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${data} has been scheduled successfully.",
                    style: TextStyle(fontSize: 12.sp, letterSpacing: .5),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "See the complete details in your email.",
                    style: TextStyle(fontSize: 10.sp, letterSpacing: .5),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tap to share the link",
                          style: TextStyle(fontSize: 10.sp, letterSpacing: .5),
                        ),
                        Icon(
                          Icons.share,
                          color: AppColors.appNewLightThemeColor,
                        )
                      ],
                    ),
                    onTap: () {
                      _onShareWithEmptyFields(context, meetingId, data);
                    },
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  GestureDetector(
                      onTap: () {
                        isShow = false;
                        if (data == "Meeting") {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BottomNavbar(
                                  index: 0,
                                ),
                              ),
                              (route) => false);
                        } else {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BottomNavbar(
                                  index: 1,
                                ),
                              ),
                              (route) => false);
                        }
                      },
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF450d35),
                                Color(0xFF4a0d36),
                                Color(0xFF4e1141),
                                Color(0xFF520e35),
                                Color(0xFF520e35),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Text(
                                "DONE",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: .5),
                              ),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          );
        });
  }

  static Widget onScreenProgress() {
    return Container(
      height: getProportionateScreenHeight(10),
      width: getProportionateScreenWidth(9),
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor:
              new AlwaysStoppedAnimation<Color>(ColorConstant.buttonPink),
        ),
      ),
    );
  }
}

var localdata;
String rtm_userName, rtm_Token;
dynamic userdata, userName;
int userid, rtm_userID;

getToken(cnx, id, video, audio, meetingID) async {
  await getRTMUserNameAndToken(cnx);
  Helper.checkConnectivity().then((value) => {
        if (value)
          {
            EasyLoading.show(),
            PreferenceConnector.getJsonToSharedPreference(
                    StringConstant.Userdata)
                .then((value) => {
                      if (value != null)
                        {
                          userdata = jsonDecode(value.toString()),
                          localdata = PrefranceData.fromJson(userdata),
                          ApiRepository()
                              .hosttoken(localdata.authToken, id.toString())
                              .then((value) {
                            EasyLoading.dismiss();
                            if (value != null) {
                              if (value.status == "successfull") {
                                onJoin(
                                    cnx,
                                    value.body.meeting.token,
                                    value.body.meeting.appid,
                                    value.body.meeting.channel,
                                    value.body.meeting.role,
                                    id.toString(),
                                    "0",
                                    "0",
                                    localdata.id,
                                    localdata.name,
                                    meetingID);
                              } else {
                                Helper.showMessage(
                                    "Something went wrong please logout and login again.");
                              }
                            }
                          })
                        }
                      else
                        {
                          Helper.showMessage(
                              "Something went wrong please logout and login again.")
                        }
                    })
          }
        else
          {Helper.showNoConnectivityDialog(cnx)}
      });
}

getRTMUserNameAndToken(cnx) {
  Helper.checkConnectivity().then((value) => {
        if (value)
          {
            //EasyLoading.show(),
            PreferenceConnector.getJsonToSharedPreference(
                    StringConstant.Userdata)
                .then((value) => {
                      if (value != null)
                        {
                          userdata = jsonDecode(value.toString()),
                          localdata = PrefranceData.fromJson(userdata),
                          print("LocalData ${localdata.id}"),
                          rtm_userID = 1000000 + localdata.id,
                          print("Rtm USer ID $rtm_userID"),
                          ApiRepository()
                              .rtmFetchUserName(localdata.authToken,
                                  rtm_userID.toString(), localdata.name)
                              .then((value) {
                            EasyLoading.dismiss();
                            // _progressDialog.dismissProgressDialog(cnx);
                            if (value != null) {
                              if (value.rtmToken != null) {
                                rtm_Token = value.rtmToken;
                                rtm_userName = value.rtmUser;
                                print(
                                    "RTM TOKEN $rtm_Token && RTM USerName $rtm_userName");
                              } else {
                                Helper.showMessage("Something getting wrong!");
                              }
                            }
                          })
                        }
                      else
                        {Helper.showMessage("Something getting wrong!")}
                    })
          }
        else
          {Helper.showNoConnectivityDialog(cnx)}
      });
}

Future<void> onJoin(
    context,
    String token,
    String app_id,
    String channal,
    String role,
    String id,
    String video,
    String audio,
    int userid,
    String userName,
    String meetingID) async {
  await _handleCameraAndMic(Permission.camera);
  await _handleCameraAndMic(Permission.microphone);
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallPage(
          token: token,
          app_id: app_id,
          channelName: channal,
          role: "host",
          id: id,
          video: video,
          audio: audio,
          userid: userid,
          meetingid: meetingID,
          userName: userName,
          rtmUser: rtm_userName,
          rtmToken: rtm_Token,
        ),
      ));
}

Future<void> _handleCameraAndMic(Permission permission) async {
  final status = await permission.request();
  print(status);
}
