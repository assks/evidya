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

//import 'package:evidya/screens/broadcast/CallPage.dart';
import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:evidya/utils/helper.dart';
import 'package:evidya/utils/size_config.dart';
import 'package:evidya/utils/validator.dart';
import 'package:evidya/widget/back_toolbar_with_center_title.dart';
import 'package:evidya/widget/login_gradiant_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:custom_progress_dialog/custom_progress_dialog.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class StartMeetScreen extends StatefulWidget {
  final String name;

  const StartMeetScreen(this.name, {Key key}) : super(key: key);

  @override
  _StartMeetScreenState createState() => _StartMeetScreenState();
}

class _StartMeetScreenState extends State<StartMeetScreen> {
  final _tokenController = new TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  ProgressDialog _progressDialog = ProgressDialog();
  bool video = true;
  bool audio = true;
  int rtm_userID;
  String rtm_userName, rtm_Token;
  var image;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRTMUserNameAndToken(context);
  }



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        height: size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/back_ground.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus.unfocus(),
            child: Scaffold(
              key: _scaffoldKey,
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              // appBar: AppBar(
              //  // backgroundColor: Colors.transparent,
              //   leading:
              //  // title: const Text("Join a Meeting"),
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
                    child: Form(
                      key: _formKey,

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
                                        Text("Join a Meeting",
                                          style: TextStyle(fontSize: 2.5.h,color: Colors.black,
                                              fontWeight: FontWeight.bold),),

                                      ],
                                    ),
                                    SizedBox(height: 3.h,),
                                    Text("Meeting ID or link",
                                      style: TextStyle(fontSize: 12.sp,color: Colors.black,
                                          fontWeight: FontWeight.bold),),

                                    TextFormField(
                                      style: const TextStyle(color: Colors.black),
                                      autofocus: false,
                                      cursorColor: Colors.black,
                                      controller: _tokenController,
                                      decoration:  InputDecoration(
                                        isDense: true,
                                        border: InputBorder.none,
                                        hintText: 'Enter meeting Id or link here',
                                        hintStyle: TextStyle(color: Colors.grey,fontSize: 2.h),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Enter meeting ID or link';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    const Divider(color: Colors.black,thickness: 1,height: 1,),
                                    SizedBox(height: 2.h,),
                                    Align(
                                      alignment: Alignment.center,
                                      child:  Text("You can also click on the link received to join directly.",
                                        style: TextStyle(fontSize: 1.8.h,color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(height: 4.h,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Always mute my microphone on start",
                                              style: TextStyle(fontSize: 1.8.h,color: Colors.black,
                                                  letterSpacing: 0,
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
                                                  letterSpacing: 0,
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
                                  ],
                                ),
                              ),

                            ],
                          ),
                          Spacer(),
                          GestureDetector(
                              onTap: (){
                                if(_formKey.currentState.validate()) {
                                  EasyLoading.show();
                                  _validaction(context);
                                }
                                else{

                                }
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
                                        "Join",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.sp,
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
            ),
          ),
        ));
  }

  dynamic userdata;
  var localdata;

  getRTMUserNameAndToken(cnx) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      image = prefs.getString('profileImage');
    });
    print("IMage $image");
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
  void _validaction(BuildContext cnx) async{
    if (Validator().validatePassword(_tokenController.text)) {
     await getRTMUserNameAndToken(cnx);
      PreferenceConnector.getJsonToSharedPreferencetoken(
              StringConstant.Userdata)
          .then((value) => {
                if (value != null)
                  {
                    userdata = jsonDecode(value.toString()),
                  localdata = PrefranceData.fromJson(userdata),
                    ApiRepository().usertoken(localdata.authToken, _tokenController.text).then((value) {
                      if (value != null) {
                        if (value.status == "successfull") {
                        //  setState(() {
                            var meetid = _tokenController.text;
                            if (value.body.meeting.status == "streaming") {
                              EasyLoading.dismiss();
                              onJoin(
                                context,
                                value.body.meeting.token,
                                value.body.meeting.appid,
                                value.body.meeting.channel,
                                localdata.id,
                                _tokenController.text,
                              );
                            } else {
                              EasyLoading.dismiss();
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      backgroundColor: Colors.transparent,
                                      child:  Container(
                                        padding: EdgeInsets.symmetric(horizontal: 25,vertical: 20),
                                        width: 260.0,
                                        height: 300.0,
                                        decoration:  BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color: Colors.transparent,
                                          borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: AssetImage("assets/images/whitebackground.png")
                                          ),
                                        ),
                                        child:  Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Image.asset("assets/images/sad.png",height: 10.h,),
                                            SizedBox(height: 15,),
                                            Text("Oops!",style: TextStyle(
                                                fontSize: 17.sp,
                                                color: AppColors.buttonColor,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: .5
                                            ),),
                                            SizedBox(height: 5,),
                                            Text("Oops!, Meeting is not started yet.\n Please waiting.",style: TextStyle(
                                                fontSize: 2.h,
                                                letterSpacing: .5
                                            ),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 15,),
                                            GestureDetector(
                                                onTap: (){
                                                  Navigator.pop(context);
                                                },
                                                child: Center(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      gradient: const LinearGradient(
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
                                                    child:  Center(
                                                      child: Padding(
                                                        padding: EdgeInsets.only(top: 10, bottom: 10),
                                                        child: Text(
                                                          "Okay",
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 2.h,
                                                              fontWeight: FontWeight.w500,
                                                              letterSpacing: .5
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),)),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                              // EasyLoading.showInfo("Meeting not started yet.\n Please Wait",
                              //     duration:Duration(seconds: 2));
                            }
                        } else {
                          EasyLoading.dismiss();
                          EasyLoading.showToast(
                              "Something went wrong please logout and login again.",
                          toastPosition: EasyLoadingToastPosition.bottom);
                        }
                      }
                    })
                  }
              });
    } else {
      EasyLoading.showToast("Enter a Meeting ID",toastPosition: EasyLoadingToastPosition.bottom);
    }
  }

  Future<void> onJoin(context, String token, String app_id, String channal,
      int userid, String meetID) async {
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
              token: token,
              app_id: app_id,
              channelName: channal,
              role: "joiner",
              id: meetID,
              video: video == true ?'0':'1',
              audio: audio == true ? '0':'1',
              userid:userid,
              userName : widget.name,
              rtmToken: rtm_Token,
              rtmUser: rtm_userName,
          ),
        ));
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}
