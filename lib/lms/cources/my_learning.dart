import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/lms/list_of_followed_instructor.dart';
import 'package:evidya/model/login/PrefranceData.dart';
import 'package:evidya/network/repository/api_repository.dart';
import 'package:evidya/resources/app_colors.dart';
import 'package:evidya/screens/user/lesson_of_courses_subscribe.dart';
import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:evidya/utils/helper.dart';
import 'package:evidya/widget/login_gradiant_button.dart';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';


class MyLearning extends StatefulWidget {
  const MyLearning({Key key}) : super(key: key);

  @override
  State<MyLearning> createState() => _MyLearningState();
}

class _MyLearningState extends State<MyLearning> {
  var name, email,token;
  String image;
  bool loader = false;
  List lessonList = [];
  List courseList = [];
String choice = "courses";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sharePreferenceData();
    studentLearningData();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100.h,
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
                        IconButton(
                          icon: const Icon(Icons.keyboard_backspace,color: Colors.white,),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 7.h),
                            padding: EdgeInsets.only(left: 3.h,right: 3.h,bottom: 3.h),
                           // height: 15.h,
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
                                SizedBox(height: 7.h,),

                                Text("$name",style:
                                TextStyle(color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: .5,
                                    fontSize: 17.sp),),
                                SizedBox(height: 2.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        width: 40.w,
                                      padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 1.h),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white
                                      ),
                                      child: Center(
                                        child: RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(text: 'Certificates:', style:
                                              TextStyle(color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 11.sp),),
                                              TextSpan(text: ' 3',style:
                                              TextStyle(color: Colors.black,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 11.sp),),
                                            ],
                                          ),
                                        ),
                                      )
                                    ),
                                    InkWell(
                                      child: Container(
                                          width: 40.w,
                                          padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 1.h),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: Colors.white
                                          ),
                                          child: Center(
                                            child: RichText(
                                              text: TextSpan(
                                                children: <TextSpan>[
                                                  TextSpan(text: 'Teachers Followed', style:
                                                  TextStyle(color: Colors.black,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 11.sp),),
                                                  // TextSpan(text: ' 5',style:
                                                  // TextStyle(color: Colors.black,
                                                  //     fontWeight: FontWeight.w800,
                                                  //     fontSize: 11.sp),),
                                                ],
                                              ),
                                            ),
                                          )
                                      ),
                                      onTap: (){
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) =>
                                                ListOfFollowedInstructor()));
                                      },
                                    )
                                  ],
                                ),

                              ],
                            )
                        ),
                        Align(
                          alignment: Alignment.center,
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
                                  fit: BoxFit.cover,
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

                    Expanded(child: Container(
                      margin: EdgeInsets.only(top: 1.h,right: 0.h,left: 0.h,bottom: 1.h),
                      padding: EdgeInsets.only(bottom: 2.h),
                      height: 100.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/grey_background.jpg",),
                            fit: BoxFit.cover
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(children: [

                        SizedBox(height: 1.h,),
                        loader == false
                            ? Expanded(child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 30,width: 30,
                                child: CircularProgressIndicator(strokeWidth: 2,),),
                              SizedBox(width:10),
                              Text("Fetching Data...",style: TextStyle(fontSize: 12.sp,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ))
                            : courseList.length == 0
                            ? Expanded(child: Container(child: Center(
                               child: Text("No Course Subscribed!",
                                 style: TextStyle(
                                     color: Colors.grey.shade400,
                                     fontWeight: FontWeight.bold,
                                     fontSize: 25.sp),),
                        ),))
                            : Expanded(
                              child: ListView.separated(itemBuilder: (context, index){
                               return GestureDetector(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 2.h,),
                                  padding: EdgeInsets.symmetric(horizontal: 2.h,vertical: 2.h),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [

                                          Container(
                                            padding: EdgeInsets.only(left: 10),
                                            width: 40.w,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("${courseList[index].courseName}",
                                                    style: TextStyle(fontSize: 14.sp,
                                                        fontWeight: FontWeight.bold)),
                                                SizedBox(height: .5.h,),
                                                Row(
                                                  children: [
                                                    Icon(Icons.timer,color: Colors.grey,size: 15,),
                                                    SizedBox(width: 5,),
                                                    Text("6 hours left",
                                                        style: TextStyle(fontSize: 8.sp,
                                                            color: Colors.grey,
                                                            fontWeight: FontWeight.normal))
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          CircularPercentIndicator(
                                            radius: 50.0,
                                            lineWidth: 8.0,
                                            percent: double.parse(courseList[index].progress)/100.0,
                                            center: Text("${courseList[index].progress}%",
                                              style: TextStyle(fontSize: 10.sp,
                                                  fontWeight: FontWeight.bold),),
                                            progressColor: AppColors.appNewLightThemeColor,
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 1.h,),
                                      Divider(height: 2,color: AppColors.appNewDarkThemeColor,
                                        thickness: 1,),
                                      SizedBox(height: 1.h,),
                                      Row(
                                        children: [
                                          SizedBox(width: 10,),
                                          Container(
                                            padding:EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  AppColors.appNewDarkThemeColor,
                                                  AppColors.appNewLightThemeColor,
                                                ],
                                              ),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Icon(Icons.play_arrow_sharp,
                                              size: 15,
                                              color: Colors.white,),
                                          ),
                                          SizedBox(width: 10,),
                                          Text("Continue Learning",style: TextStyle(fontSize: 8.sp,
                                              fontWeight: FontWeight.w600),)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                onTap: (){
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) =>
                                          LessonOfCourseSubscribe(
                                            courseId: courseList[index].courseId.toString(),
                                            courseName: courseList[index].courseName,
                                          )));
                                },
                              );
                                },
                                separatorBuilder: (_,__)=>SizedBox(height: 2.h,),
                                itemCount: courseList.length))
                      ],)
                    ))
                  ]
              ),
            ),

          ),
        )
    );
  }
  void studentLearningData() {
    loader = false;
    Helper.checkConnectivity().then((value) =>
    {
      if (value)
        {
          PreferenceConnector.getJsonToSharedPreference(
              StringConstant.loginData)
              .then((value) =>
          {
            if (value != null)
              {
                ApiRepository().studentLearningDetails(value).then((value) {
                  if (value != null) {
                    setState(() {
                      lessonList = value.body.data;
                      courseList = value.body.courses;
                      loader = true;
                      print("hello $lessonList");
                    });
                  } else {
                    Helper.showMessage("null");
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
        {Helper.showNoConnectivityDialog(context)}
    });
  }
  void sharePreferenceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    image = prefs.getString('profileImage');
    print("Image $image");
    await PreferenceConnector.getJsonToSharedPreferencetoken(StringConstant.Userdata)
        .then((value) => {
      if (value != null)
        {
          userdata = jsonDecode(value.toString()),
          setState(() {
            localdata = PrefranceData.fromJson(userdata);
            name = localdata.name;
            email = localdata.email;
            token = userdata['auth_token'];
            print("UserToken $token");
          }),
        }
    });
  }
}
