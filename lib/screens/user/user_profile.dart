import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/lms/cources/my_learning.dart';
import 'package:evidya/lms/private_requested_class_list.dart';
import 'package:evidya/model/login/PrefranceData.dart';
import 'package:evidya/model/user_profile_modal.dart';
import 'package:evidya/network/repository/api_repository.dart';
import 'package:evidya/resources/app_colors.dart';
import 'package:evidya/screens/createmeet/schudle_meet_screen.dart';
import 'package:evidya/screens/login/forget_password.dart';
import 'package:evidya/screens/login/login_screen.dart';
import 'package:evidya/screens/setting/settinghome.dart';
import 'package:evidya/screens/user/edit_profile.dart';
import 'package:evidya/screens/user/history.dart';
import 'package:evidya/screens/user/report_page.dart';
import 'package:evidya/screens/user/teacher_courses_list_page.dart';
import 'package:evidya/screens/user/view_instructor_profile.dart';
import 'package:evidya/screens/user/view_profile.dart';
import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:evidya/utils/helper.dart';
import 'package:evidya/webpages/aboutus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  var name, email,token,instructorId;
  bool notification = true;
  String image,role;
  var _image;
  bool history = false,
      repeat = false,
      broadCastRepeat = false;
  dynamic userData;
  var localData;
  bool audio = true,
      video = false,
      volume = true,
      broadCartAudio = false,
      broadCastVideo = true,
      broadCastVolume = false,
      messengerAudio = false,
      messengerVideo = true,
      messengerVolume = false;
  bool openMeet = true,
      openBroadcast = false,
      openMessenger = false,
      openLMS = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sharePreferenceData();
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return  Container(
      height: size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/back_ground.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.h),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 7.h),
                            padding: EdgeInsets.only(left: 3.h,right: 3.h,bottom: 2.h),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/images/grey_background.jpg",),
                                  fit: BoxFit.cover
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 6.h,),
                                Text("$name",style:
                                TextStyle(color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: .5,
                                    fontSize: 17.sp),),
                                Text("$email",
                                  style: TextStyle(color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: .5,
                                      fontSize: 12.sp),),
                                role == "user" ? TextButton(
                                  onPressed: () {
                                    _launchUrl();
                                  },
                                  child: Text("Become an instructor",
                                   style: TextStyle(color: AppColors.appNewDarkThemeColor,
                                   decoration: TextDecoration.underline,
                                   fontWeight: FontWeight.w600,
                                   letterSpacing: .5,
                                   fontSize: 12.sp),),
                                )
                                    :Container()

                              ],
                            )
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            //alignment: Alignment.center,
                            padding: EdgeInsets.all(1),
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
                            child: Stack(
                              children: [
                                Container(
                                    height: 10.h,
                                    width: 21.w,
                                    margin: EdgeInsets.only(bottom: 5,right: 5,left:5,top:5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(width: 1,color: Colors.transparent),
                                      color:Colors.transparent
                                          ),
                                    child: _image != null
                                        ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        _image,
                                        height: 7.h,
                                        width: 15.w,
                                        fit: BoxFit.fill,
                                      ),
                                    )
                                        : image != null
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
                                        height: 7.h,
                                        width: 15.w,
                                        fit: BoxFit.fill,
                                      ),
                                    )
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: InkWell(
                                    child:CircleAvatar(
                                        radius: 12,
                                        backgroundColor: Colors.white,
                                        child: Image.asset('assets/icons/edit.png',height: 1.4.h,
                                          color: Color(0xFF5c0e35),)
                                    ),
                                    onTap: (){
                                        _selectImage(context);
                                    },
                                  )
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Spacer(),
                    Container(
                      margin: EdgeInsets.only(top: 1.h,right: 0.h,left: 0.h,bottom: 0.h),
                      padding: EdgeInsets.only(left: 3.h,right: 3.h,bottom: 1.h),
                      height: role == 'user'? 52.h: 59.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/grey_background.jpg",),
                            fit: BoxFit.cover
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight:Radius.circular(20),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Wrap(
                          children: [
                            Column(
                              children: [
                                SizedBox(height: 2.h,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Profile",
                                      style: TextStyle(color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: .5,
                                          fontSize: 14.sp),
                                    ),
                                    SizedBox(width:10),
                                    Expanded(child: Divider(height: 1,thickness: 1,
                                      color: AppColors.addedColor,
                                    ),),

                                  ],
                                ),
                                SizedBox(height: 1.h,),
                                InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        //border: Border.all(width: 1,color: Colors.grey),
                                        color: Colors.white70
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 1.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.person_outlined,
                                              size:4.h,color: Colors.black,),
                                            SizedBox(width: 10,),
                                            Text("View Your Profile Details",
                                              style: TextStyle(color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: .5,
                                                  fontSize: 12.sp),),
                                          ],
                                        ),

                                        Container(
                                          padding:EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                AppColors.appNewLightThemeColor,
                                                AppColors.appNewDarkThemeColor,
                                              ],
                                            ),
                                          ),
                                          child:Icon(Icons.arrow_forward_ios_sharp,
                                              color: Colors.white,
                                              size:2.h
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: (){
                                    if(role == 'user'){
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context)=>ViewProfile(
                                              token: token
                                          )));
                                    }
                                    else{
                                      Navigator.push(context,
                                          MaterialPageRoute(builder:
                                              (context)=>ViewInstructorProfile(
                                                  token: token,
                                                  id: instructorId.toString()
                                              )));
                                    }
                                  },
                                ),
                                SizedBox(height: 1.h,),
                                role == "user" ? InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        //border: Border.all(width: 1,color: Colors.grey),
                                        color: Colors.white70
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 1.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.sticky_note_2_outlined,size:4.h,color: Colors.black,),
                                            SizedBox(width: 10,),
                                            Text("My Learning",
                                              style: TextStyle(color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: .5,
                                                  fontSize: 12.sp),),
                                          ],
                                        ),

                                        Container(
                                          padding:EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                AppColors.appNewLightThemeColor,
                                                AppColors.appNewDarkThemeColor,
                                              ],
                                            ),
                                          ),
                                          child:Icon(Icons.arrow_forward_ios_sharp,
                                              color: Colors.white,
                                              size:2.h
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: (){
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context)=>MyLearning()));
                                  },
                                )
                                    : InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        //border: Border.all(width: 1,color: Colors.grey),
                                        color: Colors.white70
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 1.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.sticky_note_2_outlined,size:4.h,color: Colors.black,),
                                            SizedBox(width: 10,),
                                            Text("My Courses",
                                              style: TextStyle(color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: .5,
                                                  fontSize: 12.sp),),
                                          ],
                                        ),
                                        Container(
                                          padding:EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                AppColors.appNewLightThemeColor,
                                                AppColors.appNewDarkThemeColor,
                                              ],
                                            ),
                                          ),
                                          child:Icon(Icons.arrow_forward_ios_sharp,
                                              color: Colors.white,
                                              size:2.h
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: (){
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context)=>TeacherCoursesListPage(
                                          id: instructorId.toString(),
                                          name: name,
                                          image: image,
                                        )));
                                  },
                                ),
                                SizedBox(height: 1.h,),
                                role != 'user'?
                                InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        //border: Border.all(width: 1,color: Colors.grey),
                                        color: Colors.white70
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 1.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.history_edu,size:4.h,color: Colors.black,),
                                            SizedBox(width: 10,),
                                            Text("Private Class Requests",
                                              style: TextStyle(color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: .5,
                                                  fontSize: 12.sp),),
                                          ],
                                        ),

                                        Container(
                                          padding:EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                AppColors.appNewLightThemeColor,
                                                AppColors.appNewDarkThemeColor,
                                              ],
                                            ),
                                          ),
                                          child:Icon(Icons.arrow_forward_ios_sharp,
                                              color: Colors.white,
                                              size:2.h
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: (){
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context)=>PrivateRequestedClassList()));
                                  },
                                )
                                    : Container(),
                                role != 'user'
                                    ? SizedBox(height: 1.h,)
                                    : SizedBox(),
                                InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      //border: Border.all(width: 1,color: Colors.grey),
                                       color: Colors.white70
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 1.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.lock_outline_rounded,size:4.h,color: Colors.black,),
                                            SizedBox(width: 10,),
                                            Text("Reset Your Password",
                                              style: TextStyle(color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: .5,
                                                  fontSize: 12.sp),),
                                          ],
                                        ),
                                        Container(
                                          padding:EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                AppColors.appNewLightThemeColor,
                                                AppColors.appNewDarkThemeColor,
                                              ],
                                            ),
                                          ),
                                          child:Icon(Icons.arrow_forward_ios_sharp,
                                              color: Colors.white,
                                              size:2.h
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: (){
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context)=>ForgetPassword()));
                                  },
                                ),

                                SizedBox(height: 3.h,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Settings",
                                      style: TextStyle(color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: .5,
                                          fontSize: 14.sp),
                                    ),
                                    SizedBox(width: 10,),
                                    Expanded(child: Divider(height: 1,
                                      thickness: 1,
                                      color: AppColors.addedColor,
                                    ),),
                                  ],
                                ),
                                /// Profile END =======
                                SizedBox(height: 1.h,),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      //border: Border.all(width: 1,color: Colors.grey),
                                      color: Colors.white70
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 1.h),
                                  child:Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 0.h),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.videocam_outlined,size:4.h,color: Colors.black,),
                                                SizedBox(width: 10,),
                                                Text("bMeet",
                                                  style: TextStyle(fontSize: 13.sp,
                                                      letterSpacing: .5,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.black),),
                                              ],
                                            ),
                                            Container(
                                              padding:EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(30),
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    AppColors.appNewLightThemeColor,
                                                    AppColors.appNewDarkThemeColor,
                                                  ],
                                                ),
                                              ),
                                              child:InkWell(
                                                child: openMeet
                                                    ?Icon(Icons.keyboard_arrow_up_outlined,
                                                  color: Colors.white,size:3.h,)
                                                    :Icon(Icons.keyboard_arrow_down_rounded,
                                                  color: Colors.white,size:3.h,),
                                                onTap: (){
                                                  setState(() {
                                                    openMeet = !openMeet;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      openMeet == true
                                          ? Padding(
                                          padding: EdgeInsets.symmetric(horizontal:1.h,vertical: 1.h),
                                          child: Column(
                                            children: [
                                              InkWell(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(width: 3.2.h),
                                                          Text("History",
                                                            style: TextStyle(fontSize: 11.sp,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.black
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Icon(Icons.arrow_forward_ios_sharp,
                                                          color: AppColors.appNewDarkThemeColor,
                                                          size:2.h
                                                      ),
                                                    ],
                                                  ),
                                                  onTap:(){
                                                    Navigator.push(context,
                                                        MaterialPageRoute(builder: (context)=>
                                                            HistoryPage(
                                                              title: "Meeting"
                                                            )));
                                                  }
                                              ),
                                              SizedBox(height: 2.h,),
                                              InkWell(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(width: 3.2.h),
                                                          Text("Schedule Meeting",
                                                            style: TextStyle(fontSize: 11.sp,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.black
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Icon(Icons.arrow_forward_ios_sharp,
                                                          color: AppColors.appNewDarkThemeColor,
                                                          size:2.h
                                                      ),
                                                    ],
                                                  ),
                                                  onTap:(){
                                                    Navigator.push(context,
                                                        MaterialPageRoute(builder: (context)=>
                                                            Schudle_Meet_Screen()));
                                                  }
                                              ),
                                              SizedBox(height: 2.h,),
                                              InkWell(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(width: 3.2.h),
                                                          Text("Mute All",
                                                            style: TextStyle(fontSize: 11.sp,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.black
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      audio == true?
                                                      Text("Yes",
                                                        style: TextStyle(fontSize: 12.sp,
                                                            fontWeight: FontWeight.bold,
                                                            color: AppColors.appNewDarkThemeColor
                                                        ),
                                                      ):
                                                      Text("No",
                                                        style: TextStyle(fontSize: 12.sp,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.grey
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  onTap:(){
                                                    setState(() {
                                                      audio = !audio;
                                                    });
                                                  }
                                              ),
                                            ],
                                          )
                                      )
                                          : Container(),
                                    ],
                                  ),
                                ),
                                SizedBox(height: .5.h,),
                                Row(
                                  children: [
                                    Text("    *See Your bMeet Settings.",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontWeight:FontWeight.bold,
                                          color: Colors.grey,
                                          fontSize:10.sp
                                      ),),
                                  ],
                                ),
                                /// Meet END ======
                                SizedBox(height: 1.h,),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      //border: Border.all(width: 1,color: Colors.grey),
                                      color: Colors.white70
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 1.h),
                                  child:Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 0.h),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.live_tv_outlined,size:4.h,color: Colors.black,),
                                                SizedBox(width: 10,),
                                                Text("bLive",
                                                  style: TextStyle(fontSize: 12.sp,
                                                      letterSpacing: .5,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.black),),
                                              ],
                                            ),
                                            Container(
                                              padding:EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(30),
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    AppColors.appNewLightThemeColor,
                                                    AppColors.appNewDarkThemeColor,
                                                  ],
                                                ),
                                              ),
                                              child:InkWell(
                                                child: openBroadcast
                                                    ? Icon(Icons.keyboard_arrow_up_outlined,
                                                      color: Colors.white,size:3.h,)
                                                    : Icon(Icons.keyboard_arrow_down_rounded,
                                                      color: Colors.white,size:3.h,),
                                                onTap: (){
                                                  setState(() {
                                                    openBroadcast = !openBroadcast;
                                                  });
                                                },
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                      openBroadcast == true
                                          ? Padding(
                                          padding: EdgeInsets.symmetric(horizontal:1.h,vertical: 1.h),
                                          child: Column(
                                            children: [
                                              InkWell(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(width: 3.2.h),
                                                          Text("History",
                                                            style: TextStyle(fontSize: 11.sp,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.black
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Icon(Icons.arrow_forward_ios_sharp,
                                                          color: AppColors.appNewDarkThemeColor,
                                                          size:2.h
                                                      ),
                                                    ],
                                                  ),
                                                  onTap:(){
                                                    Navigator.push(context,
                                                        MaterialPageRoute(builder: (context)=>
                                                            HistoryPage(
                                                              title: "Broadcast"
                                                            )));
                                                  }
                                              ),
                                              SizedBox(height: 2.h,),
                                              role != 'user'
                                                  ? InkWell(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(width: 3.2.h),
                                                          Text("Schedule Broadcast",
                                                            style: TextStyle(fontSize: 11.sp,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.black
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Icon(Icons.arrow_forward_ios_sharp,
                                                          color: AppColors.appNewDarkThemeColor,
                                                          size:2.h
                                                      ),
                                                    ],
                                                  ),
                                                  onTap:(){
                                                    Navigator.push(context,
                                                        MaterialPageRoute(builder: (context)=>
                                                            Schudle_Meet_Screen()));
                                                  }
                                              )
                                                  : Container(),
                                              role != 'user'
                                                  ? SizedBox(height: 2.h,)
                                                  : SizedBox(),
                                              InkWell(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(width: 3.2.h),
                                                          Text("Mute All",
                                                            style: TextStyle(fontSize: 11.sp,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.black
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      broadCartAudio == true?
                                                      Text("Yes",
                                                        style: TextStyle(fontSize: 12.sp,
                                                            fontWeight: FontWeight.bold,
                                                            color: AppColors.appNewDarkThemeColor
                                                        ),
                                                      ):
                                                      Text("No",
                                                        style: TextStyle(fontSize: 12.sp,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.grey
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  onTap:(){
                                                    setState(() {
                                                      broadCartAudio = !broadCartAudio;
                                                    });
                                                  }
                                              ),

                                            ],
                                          )
                                      )
                                          : Container(),
                                    ],
                                  ),
                                ),
                                SizedBox(height: .5.h,),
                                Row(
                                  children: [
                                    Text("    *See Your bLive Settings.",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontWeight:FontWeight.bold,
                                          color: Colors.grey,
                                          fontSize:10.sp
                                      ),),
                                  ],
                                ),
                                /// Broadcast  END =====
                                SizedBox(height: 1.h,),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      //border: Border.all(width: 1,color: Colors.grey),
                                      color: Colors.white70
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 1.h),
                                  child:Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 0.h),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.message_outlined,size:4.h,color: Colors.black,),
                                                SizedBox(width: 10,),
                                                Text("bChat",
                                                  style: TextStyle(fontSize: 12.sp,
                                                      letterSpacing: .5,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.black),),
                                              ],
                                            ),
                                            Container(
                                              padding:EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(30),
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    AppColors.appNewLightThemeColor,
                                                    AppColors.appNewDarkThemeColor,
                                                  ],
                                                ),
                                              ),
                                              child:InkWell(
                                                child: openMessenger
                                                    ?Icon(Icons.keyboard_arrow_up_outlined,
                                                  color: Colors.white,size:3.h,)
                                                    :Icon(Icons.keyboard_arrow_down_rounded,
                                                  color: Colors.white,size:3.h,),
                                                onTap: (){
                                                  setState(() {
                                                    openMessenger = !openMessenger;
                                                  });
                                                },
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                      openMessenger == true
                                          ? Padding(
                                           padding: EdgeInsets.symmetric(horizontal:1.h,vertical: 1.h),
                                            child: Column(
                                            children: [
                                              InkWell(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(width: 3.2.h),
                                                          Text("Block Users",
                                                            style: TextStyle(fontSize: 11.sp,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.black
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Icon(Icons.arrow_forward_ios_sharp,
                                                          color: AppColors.appNewDarkThemeColor,
                                                          size:2.h
                                                      ),
                                                    ],
                                                  ),
                                                  onTap:(){
                                                    EasyLoading.showToast("Pending from developer ends",
                                                    toastPosition: EasyLoadingToastPosition.bottom);
                                                    // Navigator.push(context,
                                                    //     MaterialPageRoute(builder: (context)=>
                                                    //         HistoryPage(
                                                    //             title: "Broadcast"
                                                    //         )));
                                                  }
                                              ),
                                              SizedBox(height: 2.h,),
                                              InkWell(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(width: 3.2.h),
                                                          Text("Clear Chat",
                                                            style: TextStyle(fontSize: 11.sp,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.black
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Icon(Icons.arrow_forward_ios_sharp,
                                                          color: AppColors.appNewDarkThemeColor,
                                                          size:2.h
                                                      ),
                                                    ],
                                                  ),
                                                  onTap:(){
                                                    EasyLoading.showToast("Not implemented yet!",
                                                        toastPosition: EasyLoadingToastPosition.bottom);
                                                    // Navigator.push(context,
                                                    //     MaterialPageRoute(builder: (context)=>
                                                    //         HistoryPage(
                                                    //             title: "Broadcast"
                                                    //         )));
                                                  }
                                              ),
                                             // SizedBox(height: 2.h,),
                                              // Row(
                                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              //   children: [
                                              //     Row(
                                              //       children: [
                                              //         SizedBox(width: 3.2.h),
                                              //         Text("Always mute my microphone",
                                              //           style: TextStyle(fontSize: 10.sp,
                                              //               fontWeight: FontWeight.bold,
                                              //               color: Colors.grey
                                              //           ),
                                              //         ),
                                              //       ],
                                              //     ),
                                              //     CupertinoSwitch(
                                              //       value: messengerAudio,
                                              //       activeColor: AppColors.appNewLightThemeColor,
                                              //       trackColor: Colors.grey,
                                              //       dragStartBehavior: DragStartBehavior.down,
                                              //       onChanged: (value) {
                                              //         setState(() {
                                              //           messengerAudio = value;
                                              //         });
                                              //       },
                                              //     ),
                                              //   ],
                                              // ),
                                              // Row(
                                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              //   children: [
                                              //     Row(
                                              //       children: [
                                              //         SizedBox(width: 3.2.h),
                                              //         Text("Always turn off my video",
                                              //           style: TextStyle(fontSize: 10.sp,
                                              //               fontWeight: FontWeight.bold,
                                              //               color: Colors.grey
                                              //           ),
                                              //         ),
                                              //       ],
                                              //     ),
                                              //     CupertinoSwitch(
                                              //       value: messengerVideo,
                                              //       activeColor: AppColors.appNewLightThemeColor,
                                              //       trackColor: Colors.grey,
                                              //       dragStartBehavior: DragStartBehavior.down,
                                              //       onChanged: (value) {
                                              //         setState(() {
                                              //           messengerVideo = value;
                                              //         });
                                              //       },
                                              //     ),
                                              //   ],
                                              // ),
                                              // Row(
                                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              //   children: [
                                              //     Row(
                                              //       children: [
                                              //         SizedBox(width: 3.2.h),
                                              //         Text("Always turn off volume",
                                              //           style: TextStyle(fontSize: 10.sp,
                                              //               fontWeight: FontWeight.bold,
                                              //               color: Colors.grey
                                              //           ),
                                              //         ),
                                              //       ],
                                              //     ),
                                              //     CupertinoSwitch(
                                              //       value: messengerVolume,
                                              //       activeColor: AppColors.appNewLightThemeColor,
                                              //       trackColor: Colors.grey,
                                              //       dragStartBehavior: DragStartBehavior.down,
                                              //       onChanged: (value) {
                                              //         setState(() {
                                              //           messengerVolume = value;
                                              //         });
                                              //       },
                                              //     ),
                                              //   ],
                                              // ),
                                            ],
                                          )
                                      )
                                          : Container(),
                                    ],
                                  ),
                                ),
                                SizedBox(height: .5.h,),
                                Row(
                                  children: [
                                    Text("    *See Your bChat Settings.",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontWeight:FontWeight.bold,
                                          color: Colors.grey,
                                          fontSize:10.sp
                                      ),),
                                  ],
                                ),
                                SizedBox(height: 1.h,),
                                /// Messenger END ======
                                InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        //border: Border.all(width: 1,color: Colors.grey),
                                        color: Colors.white70
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 1.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.report_gmailerrorred_outlined,size:4.h,color: Colors.black,),
                                            SizedBox(width: 10,),
                                            Text("Report",
                                              style: TextStyle(color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: .5,
                                                  fontSize: 12.sp),),
                                          ],
                                        ),
                                        Container(
                                          padding:EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                AppColors.appNewLightThemeColor,
                                                AppColors.appNewDarkThemeColor,
                                              ],
                                            ),
                                          ),
                                          child:Icon(Icons.arrow_forward_ios_sharp,
                                              color: Colors.white,
                                              size:2.h
                                          ),
                                        ),
                                      ],
                                    ),

                                  ),
                                  onTap: (){
                                    Navigator.push(context,
                                        MaterialPageRoute(builder:
                                            (context)=> ReportPage()));
                                  },
                                ),
                                SizedBox(height: .5.h,),
                                Row(
                                  children: [
                                    Text("    *Tell us about the issue you are facing.",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontWeight:FontWeight.bold,
                                          color: Colors.grey,
                                          fontSize:10.sp
                                      ),),
                                  ],
                                ),
                                SizedBox(height: 1.h,),
                                InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        //border: Border.all(width: 1,color: Colors.grey),
                                        color: Colors.white70
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 1.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.notifications_active_outlined,size:4.h,color: Colors.black,),
                                            SizedBox(width: 10,),
                                            Text("Notification",
                                              style: TextStyle(color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: .5,
                                                  fontSize: 12.sp),),
                                          ],
                                        ),
                                        CupertinoSwitch(
                                          value: notification,
                                          activeColor: AppColors.appNewLightThemeColor,
                                          trackColor: Colors.grey,
                                          dragStartBehavior: DragStartBehavior.down,
                                          onChanged: (value) {
                                            setState(() {
                                              notification = value;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: (){
                                  },
                                ),
                                SizedBox(height: .5.h,),
                                Row(
                                  children: [
                                    Text("    *Toggle to receive or block bvidya notifications.",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontWeight:FontWeight.bold,
                                          color: Colors.grey,
                                          fontSize:10.sp
                                      ),),
                                  ],
                                ),
                                SizedBox(height: 2.h,),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Policies",
                                      style: TextStyle(color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: .5,
                                          fontSize: 14.sp),
                                    ),
                                    SizedBox(width: 10,),
                                    Expanded(child: Divider(height: 1,thickness: 1,
                                      color: AppColors.addedColor,
                                    ),),
                                  ],
                                ),
                                SizedBox(height: 1.h,),
                                InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        //border: Border.all(width: 1,color: Colors.grey),
                                        color: Colors.white70
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 1.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.featured_play_list_outlined,size:4.h,color: Colors.black,),
                                            SizedBox(width: 10,),
                                            Text("Terms of use",
                                              style: TextStyle(color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: .5,
                                                  fontSize: 12.sp),),
                                          ],
                                        ),
                                        Container(
                                          padding:EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                AppColors.appNewLightThemeColor,
                                                AppColors.appNewDarkThemeColor,
                                              ],
                                            ),
                                          ),
                                          child:Icon(Icons.arrow_forward_ios_sharp,
                                              color: Colors.white,
                                              size:2.h
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: (){
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context)=>AboutUs(title:"Terms of Use")));
                                  },
                                ),
                                SizedBox(height: 1.h,),
                                InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        //border: Border.all(width: 1,color: Colors.grey),
                                        color: Colors.white70
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 1.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.privacy_tip_outlined,size:4.h,color: Colors.black,),
                                            SizedBox(width: 10,),
                                            Text("Privacy Policy",
                                              style: TextStyle(color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: .5,
                                                  fontSize: 12.sp),),
                                          ],
                                        ),
                                        Container(
                                          padding:EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                AppColors.appNewLightThemeColor,
                                                AppColors.appNewDarkThemeColor,
                                              ],
                                            ),
                                          ),
                                          child:Icon(Icons.arrow_forward_ios_sharp,
                                              color: Colors.white,
                                              size:2.h
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: (){
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context)=>AboutUs(title:"Privacy Policy")));
                                  },
                                ),
                                SizedBox(height: 1.h,),
                                InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        //border: Border.all(width: 1,color: Colors.grey),
                                        color: Colors.white70
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 1.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.share,size:4.h,color: Colors.black,),
                                            SizedBox(width: 10,),
                                            Text("Share App",
                                              style: TextStyle(color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: .5,
                                                  fontSize: 12.sp),),
                                          ],
                                        ),
                                        Container(
                                          padding:EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                AppColors.appNewLightThemeColor,
                                                AppColors.appNewDarkThemeColor,
                                              ],
                                            ),
                                          ),
                                          child:Icon(Icons.arrow_forward_ios_sharp,
                                              color: Colors.white,
                                              size:2.h
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: (){
                                    shareApp(context);
                                  },
                                ),

                                SizedBox(height: 1.h,),
                                InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        // border: Border.all(width: 1,color: Colors.grey),
                                        color: Colors.white70
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 1.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.logout,size:4.h,color: Colors.black,),
                                            SizedBox(width: 10,),
                                            Text("Logout",
                                              style: TextStyle(color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: .5,
                                                  fontSize: 12.sp),),
                                          ],
                                        ),
                                        Container(
                                          padding:EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                AppColors.appNewLightThemeColor,
                                                AppColors.appNewDarkThemeColor,
                                              ],
                                            ),
                                          ),
                                          child:Icon(Icons.arrow_forward_ios_sharp,
                                              color: Colors.white,
                                              size:2.h
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: (){
                                    logoutAlertBox(context);
                                  },
                                ),
                                SizedBox(height: 1.h,),
                                InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        // border: Border.all(width: 1,color: Colors.grey),
                                        color: Colors.white70
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 1.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.delete_outline,size:4.h,color: Colors.black,),
                                            SizedBox(width: 10,),
                                            Text("Delete Account",
                                              style: TextStyle(color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: .5,
                                                  fontSize: 12.sp),),
                                          ],
                                        ),
                                        Container(
                                          padding:EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                AppColors.appNewLightThemeColor,
                                                AppColors.appNewDarkThemeColor,
                                              ],
                                            ),
                                          ),
                                          child:Icon(Icons.arrow_forward_ios_sharp,
                                              color: Colors.white,
                                              size:2.h
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: (){
                                    accountDeletion(context);
                                  },
                                ),
                                SizedBox(height: .5.h,),
                                Text("    *Your account is temporarily disable. account deletion prosess taking 30 days to delete your account.",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontWeight:FontWeight.bold,
                                      color: Colors.grey,
                                      fontSize:10.sp
                                  ),),
                              ],
                            )
                          ],
                        ),
                      )
                    )
                  ]
              ),
            ),

        ),
      )
    );
  }
  ImagePicker picker = ImagePicker();

  _imgFromGallery() async {
    XFile image = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = File(image.path);
    });
    //EasyLoading.show();
    ApiRepository().updateProfilePic(token, _image).then((value) {

      if (value != null) {
        if (value['status'] == "successfull") {
          PreferenceConnector().setProfileImage(value['image']);
          EasyLoading.dismiss();
          EasyLoading.showToast("Profile Image Updated",
              toastPosition: EasyLoadingToastPosition.bottom);
        } else {
          EasyLoading.dismiss();
          EasyLoading.showToast("Something went wrong!",
              toastPosition: EasyLoadingToastPosition.bottom);
        }
      }
    });
  }

  _imgFromCamera() async {
    XFile image = await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = File(image.path);;
    });
    //EasyLoading.show();
    ApiRepository().updateProfilePic(token, _image).then((value) {

      if (value != null) {
        if (value['status'] == "successfull") {
          PreferenceConnector().setProfileImage(value['image']);
          EasyLoading.dismiss();
          EasyLoading.showToast("Profile Image Updated",
              toastPosition: EasyLoadingToastPosition.bottom);
        } else {
          EasyLoading.dismiss();
          EasyLoading.showToast("Something went wrong!",
              toastPosition: EasyLoadingToastPosition.bottom);
        }
      }
    });
  }
  _selectImage(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }


  logoutAlertBox(BuildContext buildContext){
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2.5.h,vertical: 1.h),
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.transparent,
                borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/whitebackground.png")
                ),
              ),
              height: 13.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Are you sure wants to logout?",style: TextStyle(
                      fontSize: 12.sp,
                      letterSpacing: .5
                  ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FlatButton(
                          minWidth: 100,
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          child: Center(
                            child: Text(
                              "CANCEL",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: .5
                              ),
                            ),
                          )
                      ),
                      Container(
                        height: 30,
                        width: 2,
                        color: Colors.red,
                      ),
                      FlatButton(
                          minWidth: 100,
                          onPressed: (){
                            PreferenceConnector().setLoginData(false);
                            PreferenceConnector().clear();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => LoginScreen(),
                              ), (route) => false,
                            );
                          },
                          child: Center(
                            child: Text(
                              "YES",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: .5
                              ),
                            ),
                          )
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  accountDeletion(BuildContext buildContext){
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2.5.h,vertical: 1.h),
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.transparent,
                borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/whitebackground.png")
                ),
              ),
              height: 15.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Are you sure wants to delete your account?",
                    style: TextStyle(
                      fontSize: 12.sp,
                      letterSpacing: .5
                  ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 1.5.h,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FlatButton(
                          minWidth: 100,
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          child: Center(
                            child: Text(
                              "NO",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: .5
                              ),
                            ),
                          )
                      ),
                      Container(
                        height: 30,
                        width: 2,
                        color: Colors.red,
                      ),
                      FlatButton(
                          minWidth: 100,
                          onPressed: (){
                            deleteAccount();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => LoginScreen(),
                              ), (route) => false,
                            );

                          },
                          child: Center(
                            child: Text(
                              "YES",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: .5
                              ),
                            ),
                          )
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }


   void deleteAccount() async{
     Helper.checkConnectivity().then((value) =>
     {
       if (value)
         {
           PreferenceConnector.getJsonToSharedPreference(StringConstant.loginData)
               .then((value) =>
           {
             if (value != null)
               {
                 ApiRepository().delete(value).then((value) {
                   if (value['status'] == 'successfull') {
                     print("Account Deleted");
                     EasyLoading.showToast('Account Deleted Successfully',
                         toastPosition: EasyLoadingToastPosition.bottom);
                     PreferenceConnector().setLoginData(false);
                     PreferenceConnector().clear();
                   } else {
                     EasyLoading.showToast("Error! Something went wrong.");
                   }
                 })
               }
             else
               {
                 EasyLoading.showToast(
                     "Something went wrong please logout and login again.")
               }
           })
         }
       else
         {Helper.showNoConnectivityDialog(context)}
     });
   }

  void sharePreferenceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    image = prefs.getString('profileImage');
    role = prefs.getString('role')??"user";
    name = prefs.getString('userName');
    email = prefs.getString('userEmail');
    print("Image $image Role $role");
    await PreferenceConnector.getJsonToSharedPreferencetoken(StringConstant.Userdata)
        .then((value) => {
      if (value != null)
        {
          userdata = jsonDecode(value.toString()),
          setState(() {
            localdata = PrefranceData.fromJson(userdata);
           // name = localdata.name;
            //email = localdata.email;
             var Role = localdata.role;
            instructorId = localdata.id;
            token = userdata['auth_token'];
            print("UserToken $token Roles $instructorId");
          }),
        }
    });
  }
   shareApp(BuildContext context) async {
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
                    title: 'Sharing App',
                    text: 'Let’s connect on bvidya!\n'
                        'A fast, secure, and user-friendly app for everyone to use. '
                        'Especially beneficial for students and teachers.\n'
                        'Download it here – https://play.google.com/store/apps/details?id=com.bvidya'
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
  Future<void> _launchUrl() async {
    if (!await launchUrl(Uri.parse('https://app.bvidya.com/register'))) {
      throw 'Could not launch https://app.bvidya.com/register';
    }
  }
}
