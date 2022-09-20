import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/model/live_class_modal.dart';
import 'package:evidya/model/login/PrefranceData.dart';
import 'package:evidya/model/rtm_token_model.dart';
import 'package:evidya/network/repository/api_repository.dart';
import 'package:evidya/resources/app_colors.dart';
import 'package:evidya/screens/livestreaming/liveclass.dart';
import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:evidya/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../screens/livestreaming/broadcast/CallPage.dart';

class LMSLiveClass extends StatefulWidget {
  const LMSLiveClass({Key key}) : super(key: key);

  @override
  State<LMSLiveClass> createState() => _LMSLiveClassState();
}

class _LMSLiveClassState extends State<LMSLiveClass> {

  List liveClasses = [];
  bool loader = false;
  String role,image;
  ProgressDialog pr;
  dynamic userdata;
  RtmToken rtmtoken;
  List<LiveClasses> liveClass;
  @override
  void initState() {
    // TODO: implement initState
    lmsLiveClasses();
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/back_ground.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.appNewDarkThemeColor,
          leading: Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(Icons.keyboard_backspace,color: Colors.white,),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
          centerTitle: true,
          title: Text("Live Classes"),
        ),
        body: SafeArea(
          child: Container(
              height: 100.h,
              margin: EdgeInsets.only(top: 1.h,left: 1.h,right: 1.h),
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/grey_background.jpg",),
                    fit: BoxFit.cover
                ),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              child: getVideos()
          ),
        ),
      ),
    );
  }
  Widget getVideos() {
    return loader == false
        ? liveClasses.isNotEmpty
        ? Container(
                height: 100.h,
                margin: EdgeInsets.only(top: 1.h,left: 1.h,right: 1.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/grey_background.jpg",),
                      fit: BoxFit.cover
                  ),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                child: ListView.separated(
                  separatorBuilder: (_,__)=>Divider(height: 10,thickness: 1.5,),
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  // Optional
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, position) {
                    return Wrap(children: [
                      GestureDetector(
                        onTap: () {
                          if(role !="user") {
                            EasyLoading.showInfo(
                              "Live Broadcasting is not starting "
                                  "from Mobile.Please go on the bvidya Dashboard.",
                              duration: Duration(seconds: 5),
                            );
                          } else{
                            joinLiveClass(liveClasses[position].streamId);
                          }
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                                children: <Widget>[
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        height: 13.h,
                                        width: 29.w,
                                        fit: BoxFit.cover,
                                        imageUrl:
                                        StringConstant.IMAGE_URL+ liveClasses[position].image.toString(),
                                        placeholder: (context, url) =>
                                            SizedBox(height: 20,width: 20,child: CircularProgressIndicator(strokeWidth: 2,),),
                                        errorWidget: (context, url, error) =>
                                        new Icon(Icons.error),
                                      )),
                                  Positioned(
                                      right: 3,
                                      bottom: 3,
                                      child: CircleAvatar(
                                        radius: 15,
                                        backgroundColor: AppColors.appNewLightThemeColor,
                                        child: Icon(Icons.play_arrow,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ))
                                ]),
                            Expanded(child:  Padding(
                              padding: EdgeInsets.all(1.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "${liveClasses[position].name}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.sp),
                                  ),
                                  Text(
                                    "${liveClasses[position].description}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                        fontSize: 11.sp),
                                  ),
                                  Text(DateFormat.yMMMd().format(DateTime.parse(liveClasses[position].startsAt.split(" ")[0]))
                                      +", "+
                                      DateFormat.jm().format(DateTime.parse(liveClasses[position].startsAt.toString())),
                                      //+" - " + DateFormat.jm().format(DateTime.parse(post.endsAt.toString())),
                                      style: TextStyle(fontSize: 10.sp,
                                          color: Colors.black,
                                          letterSpacing: .5,
                                          fontWeight: FontWeight.w500)
                                  ),
                                  Text(
                                    "Status: ${liveClasses[position].status}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                        fontSize: 12.sp),
                                  ),

                                  // InkWell(
                                  //   child: Row(
                                  //     mainAxisAlignment: MainAxisAlignment.end,
                                  //      children: [
                                  //        Container(
                                  //            alignment: Alignment.bottomRight,
                                  //            padding: EdgeInsets.only(left: 2.h,right: 2.h,top: 5,bottom: 5),
                                  //            decoration: BoxDecoration(
                                  //              borderRadius: BorderRadius.circular(20),
                                  //              gradient: LinearGradient(
                                  //                begin: Alignment.topCenter,
                                  //                end: Alignment.bottomCenter,
                                  //                colors: [
                                  //                  AppColors.appNewLightThemeColor,
                                  //                  AppColors.appNewDarkThemeColor,
                                  //                ],
                                  //              ),
                                  //            ),
                                  //
                                  //            child:
                                  //            Text("Share",
                                  //              style: TextStyle(color: Colors.white,
                                  //                  fontSize: 10.sp,
                                  //                  fontWeight: FontWeight.bold),)
                                  //        ),
                                  //      ],
                                  //     ),
                                  //   onTap: () async{
                                  //     await FlutterShare.share(title: 'Meeting Id', text: '${liveClasses[position].streamId}');
                                  //   },
                                  // )
                                ],
                              ),
                            ),)
                          ],
                        ),
                      ),
                    ]);
                  },
                  itemCount: liveClasses.length,
                ),
    )
        : Center(child: Text("No Live Classes Found!",
      style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 25.sp
      ),
    ),)
        : Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 1.5,),
            ),

            Text("   Fetching Data...", style: TextStyle(color: Colors.black, fontSize: 13.sp),)
          ],

        )
    );
  }


  void lmsLiveClasses() async{
    setState(() {
      loader = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    image = prefs.getString('profileImage');
    role = prefs.getString('role')??"user";
    PreferenceConnector.getJsonToSharedPreferencetoken(StringConstant.loginData)
        .then((value) => {
      if (value != null)
        {
          ApiRepository().liveClassesData(value)
              .then((value) {
            if (value != null) {
              if (value.status == "successfull") {
                setState(() {
                  liveClasses = value.body.liveClasses;
                  print("User List ${liveClasses.length}");
                  loader = false;
                });
              } else {
              }
            }
          })
        }
    });
  }
  void joinLiveClass(var id) async {
    pr.style(
        padding: EdgeInsets.all(20),
        message: '       Please Wait! \n       Connecting....',
        borderRadius: 5.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(
          color: AppColors.redColor,
          strokeWidth: 3,
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 8.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            letterSpacing: 1,
            color: Colors.black,
            fontSize: 16.0,
            fontWeight: FontWeight.w600));
    await pr.show();
    Helper.checkConnectivity().then((value) => {
      PreferenceConnector.getJsonToSharedPreferencetoken(
          StringConstant.Userdata)
          .then((value) => {
        if (value != null)
          {
            userdata = jsonDecode(value.toString()),
            localdata = PrefranceData.fromJson(userdata),
            print("Hello ${localdata.authToken} id $id"),
            ApiRepository()
                .livedata(localdata.authToken, id)
                .then((value) {
              //EasyLoading.show();
              if (value != null) {
                if (value.status == "successfull") {
                  setState(() {
                    var livedataData = value.body;
                    print("Hello $livedataData");
                    if (livedataData.liveClass.status !=
                        "scheduled") {
                      ApiRepository()
                          .rtmtoken(localdata.authToken,
                          livedataData.liveClass.id.toString())
                          .then((value) {
                        pr.hide().then((isHidden) {
                          print(isHidden);
                        });
                        // EasyLoading.dismiss();
                        if (value != null) {
                          print("I am here ${value.status}");
                          if (value.status == "successfull") {
                            print("I am here now");
                            print(
                                "chaneele ${livedataData.liveClass}");
                            rtmtoken = value.body;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LiveClass(
                                          userName: localdata.id
                                              .toString(),
                                          channelName: livedataData
                                              .liveClass
                                              .streamChannel,
                                          token: livedataData
                                              .liveClass
                                              .streamToken,
                                          liveStreamStatus : livedataData.liveClass.status,
                                          liveStreamDescription: livedataData.liveClass.description,
                                          liveStreamId : livedataData.liveClass.streamId,
                                          roomType: livedataData.liveClass.roomType,
                                          roomStatus : livedataData.liveClass.roomStatus,
                                          isBroadcaster: false,
                                          classname: livedataData.liveClass.name,
                                          appid: rtmtoken.appid,
                                          rtmChannel: rtmtoken.rtmChannel,
                                          rtmToken:
                                          rtmtoken.rtmToken,
                                          rtmUser:
                                          rtmtoken.rtmUser)),
                            );
                          }
                        }
                      });
                    } else {
                      pr.hide().then((isHidden) {
                        print(isHidden);
                      });
                      EasyLoading.showToast(
                          "Live Class is not started yet",
                          duration: Duration(seconds: 3),
                          toastPosition:
                          EasyLoadingToastPosition.bottom);
                    }
                  });
                } else {
                  pr.hide().then((isHidden) {
                    print(isHidden);
                  });
                  EasyLoading.showToast(
                    "Something went wrong, Please check your Broadcast ID.",
                    duration: Duration(seconds: 3),
                  );
                }
              }
            })
          }
      })
    });
  }
}
