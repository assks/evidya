import 'dart:convert';

import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/model/login/PrefranceData.dart';
import 'package:evidya/resources/app_colors.dart';
import 'package:evidya/screens/login/login_screen.dart';
import 'package:evidya/screens/user/user_profile.dart';
import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

class SettingHomeScreen extends StatefulWidget {
  const SettingHomeScreen({Key key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<SettingHomeScreen> {

  List<Map> _items = [
    {'text': 'Privacy Policy', 'hasNavigation': true, 'icon': Icons.info},
    { 'text': 'Invite a Friend', 'hasNavigation': true, 'icon': Icons.group},
    {'text': 'Logout', 'hasNavigation': false, 'icon': Icons.logout},
  ];

  dynamic userData;
  var localData;
  var name,email;
  bool audio = true,
      video = false,
      volume = true;
  bool openMeet = true,
      openBroadcast = false,
      openMessenger = false,
      openLMS = false;
  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserName();
  }
  void fetchUserName() async {
    await PreferenceConnector.getJsonToSharedPreferencetoken(StringConstant.Userdata)
        .then((value) => {
      if (value != null)
        {
          userData = jsonDecode(value.toString()),
          setState(() {
            localData = PrefranceData.fromJson(userData);
            name = localData.name;
            email = localData.email;

          })
        }
    });
  }


  @override
  Widget build(BuildContext context) {
    return  Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/blackbackground.jpg"),
            fit: BoxFit.cover,
          ),
        ),
    child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text("Settings",
                style: TextStyle(fontSize: 23.sp,
                    letterSpacing: .5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),),
            ),
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 1.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        /// Profile END =======
                        SizedBox(height: 1.h,),
                        Padding(
                            padding: EdgeInsets.all(0),
                            child:Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              color: openMeet == true
                                      ? Colors.transparent
                                      : AppColors.cardColor,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: .5.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Meet",
                                          style: TextStyle(fontSize: 13.sp,
                                              letterSpacing: .5,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),),
                                        CircleAvatar(
                                          backgroundColor: Colors.black12,
                                           child: InkWell(
                                            child: openMeet
                                                ?Icon(Icons.keyboard_arrow_up_outlined,
                                                 color: Colors.grey)
                                                :Icon(Icons.keyboard_arrow_down_rounded,
                                                color: Colors.grey),
                                            onTap: (){
                                              setState(() {
                                                openMeet = !openMeet;
                                              });
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  openMeet == true
                                      ? Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                    ),color: AppColors.cardContainerColor,
                                    child: Padding(
                                        padding: EdgeInsets.all(1.h),
                                        child: Column(
                                          children: [

                                            Row(
                                              children: [
                                                Image.asset('assets/icons/svg/mic.png',
                                                  color: Colors.white,
                                                  height: 3.h,width: 3.h,),
                                                SizedBox(width: 2.h,),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Mute",
                                                        style: TextStyle(fontSize: 12.sp,
                                                            fontWeight: FontWeight.w600,
                                                            letterSpacing: .5,
                                                          color: Colors.white
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text("Off",
                                                      style: TextStyle(fontSize: 12.sp,
                                                          fontWeight: FontWeight.w600,
                                                          letterSpacing: .5,
                                                          color: audio?
                                                          Colors.grey
                                                              :Colors.red
                                                      ),
                                                    ),
                                                    SizedBox(width: 5,),
                                                    CupertinoSwitch(
                                                      value: audio,
                                                      activeColor: Colors.redAccent,
                                                      trackColor: AppColors.cardColor,
                                                      dragStartBehavior: DragStartBehavior.down,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          audio = value;
                                                        });
                                                      },
                                                    ),
                                                    SizedBox(width: 5,),
                                                    Text("On",
                                                      style: TextStyle(fontSize: 12.sp,
                                                          fontWeight: FontWeight.w600,
                                                          letterSpacing: .5,
                                                          color: audio
                                                              ? Colors.red
                                                              : Colors.grey
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.blueGrey,
                                              height: 10,
                                              indent: 45,
                                            ),
                                            Row(
                                              children: [
                                                Image.asset('assets/icons/svg/camera.png',
                                                  color: Colors.white,
                                                  height: 3.h,width: 3.h,),
                                                SizedBox(width: 2.h,),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Camera",
                                                        style: TextStyle(fontSize: 12.sp,
                                                            fontWeight: FontWeight.w600,
                                                            letterSpacing: .5,
                                                            color: Colors.white
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text("Off",
                                                      style: TextStyle(fontSize: 12.sp,
                                                          fontWeight: FontWeight.w600,
                                                          letterSpacing: .5,
                                                          color: video?
                                                          Colors.grey
                                                              :Colors.red
                                                      ),
                                                    ),
                                                    SizedBox(width: 5,),
                                                    CupertinoSwitch(
                                                      value: video,
                                                      activeColor: Colors.redAccent,
                                                      trackColor: AppColors.cardColor,
                                                      dragStartBehavior: DragStartBehavior.down,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          video = value;
                                                        });
                                                      },
                                                    ),
                                                    SizedBox(width: 5,),
                                                    Text("On",
                                                      style: TextStyle(fontSize: 12.sp,
                                                          fontWeight: FontWeight.w600,
                                                          letterSpacing: .5,
                                                          color: video
                                                              ? Colors.red
                                                              : Colors.grey
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.blueGrey,
                                              height: 10,
                                              indent: 45,
                                            ),
                                            Row(
                                              children: [
                                                Image.asset('assets/icons/svg/volume.png',
                                                  color: Colors.white,
                                                  height: 3.h,width: 3.h,),
                                                SizedBox(width: 2.h,),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Volume",
                                                        style: TextStyle(fontSize: 12.sp,
                                                            fontWeight: FontWeight.w600,
                                                            letterSpacing: .5,
                                                            color: Colors.white
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text("Off",
                                                      style: TextStyle(fontSize: 12.sp,
                                                          fontWeight: FontWeight.w600,
                                                          letterSpacing: .5,
                                                          color: volume?
                                                          Colors.grey
                                                              :Colors.red
                                                      ),
                                                    ),
                                                    SizedBox(width: 5,),
                                                    CupertinoSwitch(
                                                      value: volume,
                                                      activeColor: Colors.redAccent,
                                                      trackColor: AppColors.cardColor,
                                                      dragStartBehavior: DragStartBehavior.down,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          volume = value;
                                                        });
                                                      },
                                                    ),
                                                    SizedBox(width: 5,),
                                                    Text("On",
                                                      style: TextStyle(fontSize: 12.sp,
                                                          fontWeight: FontWeight.w600,
                                                          letterSpacing: .5,
                                                          color: volume
                                                              ? Colors.red
                                                              : Colors.grey
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        )
                                    ),
                                  )
                                      : Container(),
                                ],
                              ),
                            )
                        ),
                        /// Meet END ======
                        SizedBox(height: 1.h,),
                        Padding(
                            padding: EdgeInsets.all(0),
                            child:Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              color: openBroadcast == true
                                  ? Colors.transparent
                                  : AppColors.cardColor,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: .5.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Broadcast",
                                          style: TextStyle(fontSize: 13.sp,
                                              letterSpacing: .5,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),),
                                        CircleAvatar(
                                          backgroundColor: Colors.black12,
                                          child: InkWell(
                                            child: openBroadcast
                                                ?Icon(Icons.keyboard_arrow_up_outlined,
                                                color: Colors.grey)
                                                :Icon(Icons.keyboard_arrow_down_rounded,
                                                color: Colors.grey),
                                            onTap: (){
                                              setState(() {
                                                openBroadcast = !openBroadcast;
                                              });
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  openBroadcast == true
                                      ? Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),color: AppColors.cardContainerColor,
                                    child: Padding(
                                        padding: EdgeInsets.all(1.h),
                                        child: Column(
                                          children: [

                                            Row(
                                              children: [
                                                Image.asset('assets/icons/svg/mic.png',
                                                  color: Colors.white,
                                                  height: 3.h,width: 3.h,),
                                                SizedBox(width: 2.h,),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Mute",
                                                        style: TextStyle(fontSize: 12.sp,
                                                            fontWeight: FontWeight.w600,
                                                            letterSpacing: .5,
                                                            color: Colors.white
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text("Off",
                                                      style: TextStyle(fontSize: 12.sp,
                                                          fontWeight: FontWeight.w600,
                                                          letterSpacing: .5,
                                                          color: audio?
                                                          Colors.grey
                                                              :Colors.red
                                                      ),
                                                    ),
                                                    SizedBox(width: 5,),
                                                    CupertinoSwitch(
                                                      value: audio,
                                                      activeColor: Colors.redAccent,
                                                      trackColor: AppColors.cardColor,
                                                      dragStartBehavior: DragStartBehavior.down,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          audio = value;
                                                        });
                                                      },
                                                    ),
                                                    SizedBox(width: 5,),
                                                    Text("On",
                                                      style: TextStyle(fontSize: 12.sp,
                                                          fontWeight: FontWeight.w600,
                                                          letterSpacing: .5,
                                                          color: audio
                                                              ? Colors.red
                                                              : Colors.grey
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.blueGrey,
                                              height: 10,
                                              indent: 45,
                                            ),
                                            Row(
                                              children: [
                                                Image.asset('assets/icons/svg/camera.png',
                                                  color: Colors.white,
                                                  height: 3.h,width: 3.h,),
                                                SizedBox(width: 2.h,),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Camera",
                                                        style: TextStyle(fontSize: 12.sp,
                                                            fontWeight: FontWeight.w600,
                                                            letterSpacing: .5,
                                                            color: Colors.white
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text("Off",
                                                      style: TextStyle(fontSize: 12.sp,
                                                          fontWeight: FontWeight.w600,
                                                          letterSpacing: .5,
                                                          color: video?
                                                          Colors.grey
                                                              :Colors.red
                                                      ),
                                                    ),
                                                    SizedBox(width: 5,),
                                                    CupertinoSwitch(
                                                      value: video,
                                                      activeColor: Colors.redAccent,
                                                      trackColor: AppColors.cardColor,
                                                      dragStartBehavior: DragStartBehavior.down,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          video = value;
                                                        });
                                                      },
                                                    ),
                                                    SizedBox(width: 5,),
                                                    Text("On",
                                                      style: TextStyle(fontSize: 12.sp,
                                                          fontWeight: FontWeight.w600,
                                                          letterSpacing: .5,
                                                          color: video
                                                              ? Colors.red
                                                              : Colors.grey
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.blueGrey,
                                              height: 10,
                                              indent: 45,
                                            ),
                                            Row(
                                              children: [
                                                Image.asset('assets/icons/svg/volume.png',
                                                  color: Colors.white,
                                                  height: 3.h,width: 3.h,),
                                                SizedBox(width: 2.h,),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Volume",
                                                        style: TextStyle(fontSize: 12.sp,
                                                            fontWeight: FontWeight.w600,
                                                            letterSpacing: .5,
                                                            color: Colors.white
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text("Off",
                                                      style: TextStyle(fontSize: 12.sp,
                                                          fontWeight: FontWeight.w600,
                                                          letterSpacing: .5,
                                                          color: volume?
                                                          Colors.grey
                                                              :Colors.red
                                                      ),
                                                    ),
                                                    SizedBox(width: 5,),
                                                    CupertinoSwitch(
                                                      value: volume,
                                                      activeColor: Colors.redAccent,
                                                      trackColor: AppColors.cardColor,
                                                      dragStartBehavior: DragStartBehavior.down,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          volume = value;
                                                        });
                                                      },
                                                    ),
                                                    SizedBox(width: 5,),
                                                    Text("On",
                                                      style: TextStyle(fontSize: 12.sp,
                                                          fontWeight: FontWeight.w600,
                                                          letterSpacing: .5,
                                                          color: volume
                                                              ? Colors.red
                                                              : Colors.grey
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        )
                                    ),
                                  )
                                      : Container(),
                                ],
                              ),
                            )
                        ),

                        /// Broadcast  END =====
                        SizedBox(height: 1.h,),
                        Padding(
                            padding: EdgeInsets.all(0),
                            child:Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              color: openMessenger == true
                                  ? Colors.transparent
                                  : AppColors.cardColor,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: .5.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Messenger",
                                          style: TextStyle(fontSize: 13.sp,
                                              letterSpacing: .5,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),),
                                        CircleAvatar(
                                          backgroundColor: Colors.black12,
                                          child: InkWell(
                                            child: openMessenger
                                                ?Icon(Icons.keyboard_arrow_up_outlined,
                                                color: Colors.grey)
                                                :Icon(Icons.keyboard_arrow_down_rounded,
                                                color: Colors.grey),
                                            onTap: (){
                                              setState(() {
                                                openMessenger = !openMessenger;
                                              });
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  openMessenger == true
                                      ? Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),color: AppColors.cardContainerColor,
                                    child: Padding(
                                        padding: EdgeInsets.all(1.h),
                                        child: Column(
                                          children: [

                                            Row(
                                              children: [
                                                Image.asset('assets/icons/svg/mic.png',
                                                  color: Colors.white,
                                                  height: 3.h,width: 3.h,),
                                                SizedBox(width: 2.h,),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Mute",
                                                        style: TextStyle(fontSize: 12.sp,
                                                            fontWeight: FontWeight.w600,
                                                            letterSpacing: .5,
                                                            color: Colors.white
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text("Off",
                                                      style: TextStyle(fontSize: 12.sp,
                                                          fontWeight: FontWeight.w600,
                                                          letterSpacing: .5,
                                                          color: audio?
                                                          Colors.grey
                                                              :Colors.red
                                                      ),
                                                    ),
                                                    SizedBox(width: 5,),
                                                    CupertinoSwitch(
                                                      value: audio,
                                                      activeColor: Colors.redAccent,
                                                      trackColor: AppColors.cardColor,
                                                      dragStartBehavior: DragStartBehavior.down,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          audio = value;
                                                        });
                                                      },
                                                    ),
                                                    SizedBox(width: 5,),
                                                    Text("On",
                                                      style: TextStyle(fontSize: 12.sp,
                                                          fontWeight: FontWeight.w600,
                                                          letterSpacing: .5,
                                                          color: audio
                                                              ? Colors.red
                                                              : Colors.grey
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.blueGrey,
                                              height: 10,
                                              indent: 45,
                                            ),
                                            Row(
                                              children: [
                                                Image.asset('assets/icons/svg/camera.png',
                                                  color: Colors.white,
                                                  height: 3.h,width: 3.h,),
                                                SizedBox(width: 2.h,),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Camera",
                                                        style: TextStyle(fontSize: 12.sp,
                                                            fontWeight: FontWeight.w600,
                                                            letterSpacing: .5,
                                                            color: Colors.white
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text("Off",
                                                      style: TextStyle(fontSize: 12.sp,
                                                          fontWeight: FontWeight.w600,
                                                          letterSpacing: .5,
                                                          color: video?
                                                          Colors.grey
                                                              :Colors.red
                                                      ),
                                                    ),
                                                    SizedBox(width: 5,),
                                                    CupertinoSwitch(
                                                      value: video,
                                                      activeColor: Colors.redAccent,
                                                      trackColor: AppColors.cardColor,
                                                      dragStartBehavior: DragStartBehavior.down,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          video = value;
                                                        });
                                                      },
                                                    ),
                                                    SizedBox(width: 5,),
                                                    Text("On",
                                                      style: TextStyle(fontSize: 12.sp,
                                                          fontWeight: FontWeight.w600,
                                                          letterSpacing: .5,
                                                          color: video
                                                              ? Colors.red
                                                              : Colors.grey
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.blueGrey,
                                              height: 10,
                                              indent: 45,
                                            ),
                                            Row(
                                              children: [
                                                Image.asset('assets/icons/svg/volume.png',
                                                  color: Colors.white,
                                                  height: 3.h,width: 3.h,),
                                                SizedBox(width: 2.h,),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Volume",
                                                        style: TextStyle(fontSize: 12.sp,
                                                            fontWeight: FontWeight.w600,
                                                            letterSpacing: .5,
                                                            color: Colors.white
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text("Off",
                                                      style: TextStyle(fontSize: 12.sp,
                                                          fontWeight: FontWeight.w600,
                                                          letterSpacing: .5,
                                                          color: volume?
                                                          Colors.grey
                                                              :Colors.red
                                                      ),
                                                    ),
                                                    SizedBox(width: 5,),
                                                    CupertinoSwitch(
                                                      value: volume,
                                                      activeColor: Colors.redAccent,
                                                      trackColor: AppColors.cardColor,
                                                      dragStartBehavior: DragStartBehavior.down,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          volume = value;
                                                        });
                                                      },
                                                    ),
                                                    SizedBox(width: 5,),
                                                    Text("On",
                                                      style: TextStyle(fontSize: 12.sp,
                                                          fontWeight: FontWeight.w600,
                                                          letterSpacing: .5,
                                                          color: volume
                                                              ? Colors.red
                                                              : Colors.grey
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        )
                                    ),
                                  )
                                      : Container(),
                                ],
                              ),
                            )
                        ),
                        /// Messenger ======
                        SizedBox(height: 1.h,),
                        Padding(
                            padding: EdgeInsets.all(0),
                            child:Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              color: openLMS == true
                                  ? Colors.transparent
                                  : AppColors.cardColor,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: .5.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("LMS",
                                          style: TextStyle(fontSize: 13.sp,
                                              letterSpacing: .5,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),),
                                        CircleAvatar(
                                          backgroundColor: Colors.black12,
                                          child: InkWell(
                                            child: openLMS
                                                ?Icon(Icons.keyboard_arrow_up_outlined,
                                                color: Colors.grey)
                                                :Icon(Icons.keyboard_arrow_down_rounded,
                                                color: Colors.grey),
                                            onTap: (){
                                              setState(() {
                                                openLMS = !openLMS;
                                              });
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  openLMS == true
                                      ? Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),color: AppColors.cardContainerColor,
                                    child: Padding(
                                        padding: EdgeInsets.all(1.h),
                                        child: Column(
                                          children: [

                                            Row(
                                              children: [
                                                Image.asset('assets/icons/svg/mic.png',
                                                  color: Colors.white,
                                                  height: 3.h,width: 3.h,),
                                                SizedBox(width: 2.h,),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Mute",
                                                        style: TextStyle(fontSize: 12.sp,
                                                            fontWeight: FontWeight.w600,
                                                            letterSpacing: .5,
                                                            color: Colors.white
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text("Off",
                                                      style: TextStyle(fontSize: 12.sp,
                                                          fontWeight: FontWeight.w600,
                                                          letterSpacing: .5,
                                                          color: audio?
                                                          Colors.grey
                                                              :Colors.red
                                                      ),
                                                    ),
                                                    SizedBox(width: 5,),
                                                    CupertinoSwitch(
                                                      value: audio,
                                                      activeColor: Colors.redAccent,
                                                      trackColor: AppColors.cardColor,
                                                      dragStartBehavior: DragStartBehavior.down,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          audio = value;
                                                        });
                                                      },
                                                    ),
                                                    SizedBox(width: 5,),
                                                    Text("On",
                                                      style: TextStyle(fontSize: 12.sp,
                                                          fontWeight: FontWeight.w600,
                                                          letterSpacing: .5,
                                                          color: audio
                                                              ? Colors.red
                                                              : Colors.grey
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.blueGrey,
                                              height: 10,
                                              indent: 45,
                                            ),
                                            Row(
                                              children: [
                                                Image.asset('assets/icons/svg/camera.png',
                                                  color: Colors.white,
                                                  height: 3.h,width: 3.h,),
                                                SizedBox(width: 2.h,),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Camera",
                                                        style: TextStyle(fontSize: 12.sp,
                                                            fontWeight: FontWeight.w600,
                                                            letterSpacing: .5,
                                                            color: Colors.white
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text("Off",
                                                      style: TextStyle(fontSize: 12.sp,
                                                          fontWeight: FontWeight.w600,
                                                          letterSpacing: .5,
                                                          color: video?
                                                          Colors.grey
                                                              :Colors.red
                                                      ),
                                                    ),
                                                    SizedBox(width: 5,),
                                                    CupertinoSwitch(
                                                      value: video,
                                                      activeColor: Colors.redAccent,
                                                      trackColor: AppColors.cardColor,
                                                      dragStartBehavior: DragStartBehavior.down,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          video = value;
                                                        });
                                                      },
                                                    ),
                                                    SizedBox(width: 5,),
                                                    Text("On",
                                                      style: TextStyle(fontSize: 12.sp,
                                                          fontWeight: FontWeight.w600,
                                                          letterSpacing: .5,
                                                          color: video
                                                              ? Colors.red
                                                              : Colors.grey
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.blueGrey,
                                              height: 10,
                                              indent: 45,
                                            ),
                                            Row(
                                              children: [
                                                Image.asset('assets/icons/svg/volume.png',
                                                  color: Colors.white,
                                                  height: 3.h,width: 3.h,),
                                                SizedBox(width: 2.h,),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Volume",
                                                        style: TextStyle(fontSize: 12.sp,
                                                            fontWeight: FontWeight.w600,
                                                            letterSpacing: .5,
                                                            color: Colors.white
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text("Off",
                                                      style: TextStyle(fontSize: 12.sp,
                                                          fontWeight: FontWeight.w600,
                                                          letterSpacing: .5,
                                                          color: volume?
                                                          Colors.grey
                                                              :Colors.red
                                                      ),
                                                    ),
                                                    SizedBox(width: 5,),
                                                    CupertinoSwitch(
                                                      value: volume,
                                                      activeColor: Colors.redAccent,
                                                      trackColor: AppColors.cardColor,
                                                      dragStartBehavior: DragStartBehavior.down,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          volume = value;
                                                        });
                                                      },
                                                    ),
                                                    SizedBox(width: 5,),
                                                    Text("On",
                                                      style: TextStyle(fontSize: 12.sp,
                                                          fontWeight: FontWeight.w600,
                                                          letterSpacing: .5,
                                                          color: volume
                                                              ? Colors.red
                                                              : Colors.grey
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        )
                                    ),
                                  )
                                      : Container(),
                                ],
                              ),
                            )
                        ),
                        SizedBox(height: 1.h,),
                        /// LMS Setting END =======

                      ],
                    ),
                  ),
                )
              ],
            )
        ),
    ),
     );
  }



}
