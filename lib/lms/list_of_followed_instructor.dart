import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/lms/mentor_detail_page.dart';
import 'package:evidya/network/repository/api_repository.dart';
import 'package:evidya/resources/app_colors.dart';
import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:evidya/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sizer/sizer.dart';
class ListOfFollowedInstructor extends StatefulWidget {
  const ListOfFollowedInstructor({Key key}) : super(key: key);

  @override
  State<ListOfFollowedInstructor> createState() => _ListOfFollowedInstructorState();
}

class _ListOfFollowedInstructorState extends State<ListOfFollowedInstructor> {
  bool loader = false;
  List followedInstructorList = [];
  @override
  void initState() {
    // TODO: implement initState
    followedInstructor();
    super.initState();
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
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: AppColors.appNewDarkThemeColor,
            title: Text("Followed Instructors"),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Container(
              height: 100.h,
              margin: EdgeInsets.only(left: 1.h,right: 1.h,top: 1.h,bottom: 1.h),
              padding: EdgeInsets.symmetric(horizontal: 2.h,vertical: 1.h),
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/grey_background.jpg",),
                    fit: BoxFit.cover
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: loader == false
                  ? Center(
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
              )
                  : followedInstructorList.length == 0
                ? Center(
                child: Text("You are not followed any Instructor yet!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.sp,fontWeight: FontWeight.bold,color: Colors.grey
                ),),
                 )
                : CustomScrollView(
                   slivers: [
                   SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                              return GestureDetector(
                                child: Container(
                                    margin: EdgeInsets.only(
                                        top: 1.h, bottom: 1.h),
                                    padding: EdgeInsets.all(1.h),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        border: Border.all(
                                            width: .5, color: Colors.black54)
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 9.h,
                                                    width: 18.w,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(10),
                                                      border: Border.all(
                                                          width: 1,
                                                          color: Colors.white),
                                                      color: Colors.white,),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius
                                                          .circular(10),
                                                      child:
                                                      // loader == false
                                                      //     ? Container(
                                                      //   height: 7.h,
                                                      //   width: 15.w,
                                                      //   padding: EdgeInsets.all(10),
                                                      //   child: SizedBox(height: 20,width: 20,
                                                      //     child: CircularProgressIndicator(strokeWidth: 2,),),
                                                      // )
                                                      //     :
                                                      Image.network(
                                                        StringConstant
                                                            .IMAGE_URL +
                                                            followedInstructorList[index]
                                                                .image,
                                                        height: 9.h,
                                                        width: 18.w,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10,),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Text(
                                                          "${followedInstructorList[index]
                                                              .instructorName}",
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 14
                                                                  .sp),),
                                                        Text(
                                                          "${followedInstructorList[index]
                                                              .specialization}",
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 10.sp,
                                                              color: Colors.grey
                                                          ),),
                                                        Text(
                                                          "${followedInstructorList[index]
                                                              .experience} years experience",
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 10.sp,
                                                              color: Colors
                                                                  .black
                                                          ),),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),

                                      ],
                                    )
                                ),
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) =>
                                          MentorDetailsPage(
                                              id: followedInstructorList[index]
                                                  .instructorId.toString(),
                                              followed: true
                                          )));
                                },
                              );
                          },
                      childCount: followedInstructorList.length
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }

  void followedInstructor() {
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
                ApiRepository().followList(value).then((value) {
                  if (value != null) {
                    setState(() {
                      followedInstructorList = value.body;
                      loader = true;
                      print("hello $followedInstructorList");
                    });
                  } else {
                    EasyLoading.showToast("Some went wrong!",toastPosition: EasyLoadingToastPosition.bottom);
                  }
                })
              }
            else
              {
        EasyLoading.showToast("Some went wrong!",toastPosition: EasyLoadingToastPosition.bottom),
              }
          })
        }
      else
        {Helper.showNoConnectivityDialog(context)}
    });
  }
}
