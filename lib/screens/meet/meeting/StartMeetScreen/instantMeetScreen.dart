import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:evidya/constants/color_constant.dart';
import 'package:evidya/constants/font_constants.dart';
import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/model/login/PrefranceData.dart';
import 'package:evidya/network/repository/api_repository.dart';
import 'package:evidya/resources/app_colors.dart';
import 'package:evidya/resources/text_styles.dart';

import 'package:evidya/screens/livestreaming/broadcast/CallPage.dart';

import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:evidya/utils/helper.dart';
import 'package:evidya/utils/size_config.dart';
import 'package:evidya/utils/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:custom_progress_dialog/custom_progress_dialog.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../../widget/login_gradiant_button.dart';


class InstantMeetScreen extends StatefulWidget {
  final String name;
  final String meetingid;
  final int id;

  const InstantMeetScreen(this.name,this.meetingid,this.id ,{Key key}) : super(key: key);

  @override
  _StartMeetScreenState createState() => _StartMeetScreenState();
}

class _StartMeetScreenState extends State<InstantMeetScreen> {
  final _tokenController = new TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ProgressDialog _progressDialog = ProgressDialog();
  bool video = true;
  bool audio = true;
  String meetid;
  int userid,rtm_userID;
  String rtm_userName, rtm_Token;
  var image;
  @override
  void initState() {
    meetid = widget.meetingid;
    userid = widget.id;
    super.initState();
    getRTMUserNameAndToken(context);
    print("meetID $meetid meetingID $userid");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        height: size.height,
        decoration:  const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/back_ground.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
           child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              // appBar: AppBar(
              //   backgroundColor: Colors.transparent,
              //   leading: IconButton(
              //     icon: const Icon(Icons.keyboard_backspace),
              //     onPressed: () {
              //       Navigator.pop(context);
              //     },
              //   ),
              //   title: const Text("Start a Meeting"),
              //   centerTitle: true,
              // ),
              body: Stack(
                children: [
                  IconButton(
                    icon:  Icon(Icons.keyboard_backspace,
                      size: 3.h,
                      color: Colors.white,),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 7.h,right: 1.h,left: 1.h,bottom: 1.h),
                    padding: EdgeInsets.only(left: 3.h,right: 3.h),
                    height: 100.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/grey_background.jpg",),
                          fit: BoxFit.cover
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 7.h,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 1.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:  [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Start a meeting",
                                        style: TextStyle(fontSize: 2.5.h,color: Colors.black,
                                            fontWeight: FontWeight.bold),),

                                    ],
                                  ),
                                  SizedBox(height: 6.h,),
                              Text("Meeting Joining Options",
                                style: TextStyle(fontSize: 2.2.h,color: Colors.black,
                                    letterSpacing: .5,
                                    fontWeight: FontWeight.bold),),
                                  SizedBox(height: 2.h,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Always mute my microphone on start",
                                            style: TextStyle(fontSize: 1.8.h,color: Colors.black,
                                                fontWeight: FontWeight.bold),),
                                          Text("Grant or restrict audio access",
                                            style: TextStyle(fontSize: 1.6.h,color: Colors.grey,
                                                fontWeight: FontWeight.bold),),
                                        ],),
                                      CupertinoSwitch(
                                        value: audio,
                                        activeColor: AppColors.appNewDarkThemeColor,
                                        dragStartBehavior: DragStartBehavior.down,
                                        onChanged: (value) {
                                          setState(() {
                                            audio = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 1.h,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Always turn off my video on start",
                                            style: TextStyle(fontSize: 1.8.h,color: Colors.black,
                                               
                                                fontWeight: FontWeight.bold),),
                                          Text("Grant or restrict video access",
                                            style: TextStyle(fontSize: 1.6.h,color: Colors.grey,
                                                fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                      CupertinoSwitch(
                                        value: video,
                                        activeColor: AppColors.appNewDarkThemeColor,
                                        dragStartBehavior: DragStartBehavior.down,
                                        onChanged: (value) {
                                          setState(() {
                                            video = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h,),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 2.h,vertical: 2.h),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 1,color: Colors.black
                                    )),
                                    child: Column(
                                      //crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Your Unique meeting link or ID",
                                          style: TextStyle(fontSize: 2.1.h,color: Colors.black,
                                              letterSpacing: .5,
                                              fontWeight: FontWeight.bold),),
                                        Text("${widget.meetingid}",
                                          style: TextStyle(fontSize: 1.8.h,color: Colors.grey,
                                              fontWeight: FontWeight.bold),),
                                        SizedBox(height: 1.h,),
                                        Align(
                                          alignment:Alignment.bottomRight,
                                          child: InkWell(
                                            child: Container(
                                                padding: EdgeInsets.only(left: 2.h,right: 2.h,top: 5,bottom: 5),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      AppColors.appNewLightThemeColor,
                                                      AppColors.appNewDarkThemeColor,
                                                    ],
                                                  ),
                                                ),

                                                child: Text("Share",
                                                  style: TextStyle(color: Colors.white,
                                                      fontSize: 2.1.h,
                                                      fontWeight: FontWeight.bold),)
                                            ),
                                            onTap: (){
                                              _onShareWithEmptyFields(context,widget.meetingid,'Instant Meeting');
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),

                          ],
                        ),
                        Spacer(),
                        GestureDetector(
                            onTap: (){
                              _gettoken(context,userid, video, audio);
                            },
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.redColor,
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      AppColors.appNewLightThemeColor,
                                      AppColors.appNewDarkThemeColor,
                                    ],
                                  ),
                                ),
                                child:  Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 2.h,),
                                    child: Text(
                                      "Start",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 2.1.h,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: .5
                                      ),
                                    ),
                                  ),
                                ),
                              ),)),
                        SizedBox(height: 2.h,),

                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      //alignment: Alignment.center,
                      padding: EdgeInsets.all(5),
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 11.h,
                        width: 23.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 0,
                              color:Color(0xFF410c34)),
                          color:  Colors.transparent,),
                        child: image != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            width: 21.w,
                            height:10.h,
                            imageUrl: StringConstant.IMAGE_URL + image,
                            placeholder: (context, url) =>
                                Helper.onScreenProgress(),
                            errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                          ),
                        )
                            : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/images/teacher.PNG',
                            height: 9.h,
                            width: 20.w,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
        ));
  }

  _onShareWithEmptyFields(BuildContext context, String id,String type) async {
    Helper.checkConnectivity().then((value) =>
    {
      if (value)
        {
          PreferenceConnector.getJsonToSharedPreference(
              StringConstant.Userdata)
              .then((value) =>
          {
            if (value != null)
              {
                userdata = jsonDecode(value.toString()),
                localdata = PrefranceData.fromJson(userdata),

                FlutterShare.share(
                    title: 'Meeting Id',
                    text: '${localdata.name} just invited you to a bvidya $type.\n'
                        '$type code -$id\n'
                        'To join, copy the code and enter it on the bvidya app or website.'
                ),
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

  dynamic userdata;
  _gettoken(cnx, id, video, audio) {
    print(" audio ${audio} video $video");
    Helper.checkConnectivity().then((value) =>
    {
      if (value)
        {
          EasyLoading.show(),
          PreferenceConnector.getJsonToSharedPreference(
              StringConstant.Userdata)
              .then((value) =>
          {
            if (value != null)
              {
                userdata = jsonDecode(value.toString()),
                localdata = PrefranceData.fromJson(userdata),
                ApiRepository().hosttoken(localdata.authToken, id.toString())
                    .then((value) {
                      EasyLoading.dismiss();
                 // _progressDialog.dismissProgressDialog(cnx);
                  if (value != null) {
                    if (value.status == "successfull") {
                      onJoin(
                          cnx,
                          value.body.meeting.token,
                          value.body.meeting.appid,
                          value.body.meeting.channel,
                          value.body.meeting.role,
                          userid.toString(),
                          audio == true ? '0': '1',
                          video == true ? '0': '1',
                          localdata.id);
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

  getRTMUserNameAndToken(cnx) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
   setState(() {
     image = prefs.getString('profileImage');
   });
    Helper.checkConnectivity().then((value) =>
    {
      if (value)
        {
          //EasyLoading.show(),
          PreferenceConnector.getJsonToSharedPreference(
              StringConstant.Userdata)
              .then((value) =>
          {
            if (value != null)
              {
                userdata = jsonDecode(value.toString()),
                localdata = PrefranceData.fromJson(userdata),
                print("LocalData ${localdata.id}"),
                rtm_userID = 1000000 + localdata.id,
                print("Rtm USer ID $rtm_userID"),
                ApiRepository().rtmFetchUserName(
                    localdata.authToken,
                    rtm_userID.toString(),
                    widget.name)
                    .then((value) {
                  EasyLoading.dismiss();
                  // _progressDialog.dismissProgressDialog(cnx);
                  if (value != null) {
                    if ( value.rtmToken != null) {
                      rtm_Token = value.rtmToken;
                      rtm_userName = value.rtmUser;
                    } else {
                      Helper.showMessage(
                          "Something getting wrong!");
                    }
                  }
                })
              }
            else
              {
                Helper.showMessage(
                    "Something getting wrong!")
              }
          })
        }
      else
        {Helper.showNoConnectivityDialog(cnx)}
    });
  }

  Future<void> onJoin(context, String token, String app_id, String channal,
      String role, String id, String video, String audio, int userid) async {
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);
    print(" audio1 ${audio} video1 $video");
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CallPage(
                  token: token,
                  app_id: app_id,
                  channelName: channal,
                  role: 'host',
                  id: id,
                  video: video,
                  audio: audio,
                  userid: userid,
                  meetingid: widget.meetingid,
                  userName: widget.name,
                  rtmUser : rtm_userName,
                  rtmToken: rtm_Token,
              ),
        ));
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}
