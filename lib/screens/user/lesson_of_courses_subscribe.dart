import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/landscape_player/landscape_player.dart';
import 'package:evidya/network/repository/api_repository.dart';
import 'package:evidya/resources/app_colors.dart';
import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:evidya/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sizer/sizer.dart';

import '../../model/lesson_modal.dart';

class LessonOfCourseSubscribe extends StatefulWidget {
  final String courseId;
  final String courseName;
  const LessonOfCourseSubscribe({this.courseId, this.courseName, Key key})
      : super(key: key);

  @override
  State<LessonOfCourseSubscribe> createState() =>
      _LessonOfCourseSubscribeState();
}

class _LessonOfCourseSubscribeState extends State<LessonOfCourseSubscribe> {
  List<Lessons> lessonList;
  bool loader = false;
  @override
  void initState() {
    // TODO: implement initState
    fetchLessonList(widget.courseId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/back_ground.jpg"),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.appNewDarkThemeColor,
          title: Text("${widget.courseName}"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Container(
            height: 100.h,
            margin:
                EdgeInsets.only(left: 1.h, right: 1.h, top: 1.h, bottom: 1.h),
            padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/images/grey_background.jpg",
                  ),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(20),
            ),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                    child: Padding(
                  padding: EdgeInsets.all(1.h),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      loader == false
                          ? Text(
                              "... Lessons",
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            )
                          : Text(
                              "${lessonList.length} Lessons",
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ),
                    ],
                  ),
                )),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return GestureDetector(
                        child: Container(
                            margin: EdgeInsets.only(top: 1.h, bottom: 1.h),
                            padding: EdgeInsets.all(1.h),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                border: Border.all(
                                    width: .5, color: Colors.black54)),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 7.h,
                                            width: 15.w,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.white),
                                              color: Colors.white,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: loader == false
                                                  ? Container(
                                                      height: 7.h,
                                                      width: 15.w,
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: SizedBox(
                                                        height: 20,
                                                        width: 20,
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                        ),
                                                      ),
                                                    )
                                                  : Image.network(
                                                      StringConstant.IMAGE_URL +
                                                          lessonList[index]
                                                              .image,
                                                      height: 7.h,
                                                      width: 15.w,
                                                      fit: BoxFit.fill,
                                                    ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                loader == false
                                                    ? Text("Loading...")
                                                    : Text(
                                                        "${lessonList[index].name}",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 14.sp),
                                                      ),
                                                loader == false
                                                    ? Text("......")
                                                    : Text(
                                                        "${lessonList[index].description}",
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 10.sp,
                                                            color: Colors.grey),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  height: 15,
                                  thickness: .5,
                                  color: AppColors.appNewDarkThemeColor,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    loader == false
                                        ? Text("")
                                        : Text(
                                            "Duration: ${lessonList[index].duration} min",
                                            style: TextStyle(
                                                fontSize: 10.sp,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w600),
                                          ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Continue watching",
                                          style: TextStyle(
                                              fontSize: 8.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                AppColors.appNewDarkThemeColor,
                                                AppColors.appNewLightThemeColor,
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Icon(
                                            Icons.play_arrow_sharp,
                                            size: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            )),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LandscapePlayer(
                                    lessonId: lessonList[index].id.toString(),
                                    videourl: lessonList[index].videoUrl,
                                    vidoeid:
                                        lessonList[index].videoId.toString(),
                                    userid: lessonList[index].userId.toString(),
                                  )));
                        },
                      );
                    },
                    childCount: loader == false ? 5 : lessonList.length,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void fetchLessonList(var courseId) {
    loader = false;
    Helper.checkConnectivity().then((value) => {
          if (value)
            {
              PreferenceConnector.getJsonToSharedPreference(
                      StringConstant.loginData)
                  .then((value) => {
                        if (value != null)
                          {
                            ApiRepository()
                                .lesson(value, courseId.toString())
                                .then((value) {
                              if (value != null) {
                                setState(() {
                                  lessonList = value.body.lessons;
                                  loader = true;
                                  print("hello $lessonList");
                                });
                              } else {
                                EasyLoading.showToast(
                                    "Error! Something went wrong.");
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
}
