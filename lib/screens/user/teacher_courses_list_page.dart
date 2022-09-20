import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/lms/lession.dart';
import 'package:evidya/network/repository/api_repository.dart';
import 'package:evidya/resources/app_colors.dart';
import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:evidya/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class TeacherCoursesListPage extends StatefulWidget {
  final String id;
  final String name;
  final String image;
  const TeacherCoursesListPage({
    this.name,
    this.image,
    this.id,Key key}) : super(key: key);

  @override
  State<TeacherCoursesListPage> createState() => _TeacherCoursesListPageState();
}

class _TeacherCoursesListPageState extends State<TeacherCoursesListPage> {

  bool loader = false;
  List courseList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    instructorCourses(widget.id);
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
      child:  SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: AppColors.appNewDarkThemeColor,
              centerTitle: true,
              title:  Text("My Courses",
                style: TextStyle(fontSize: 18.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),),
            ),
            body: Container(
              height: 100.h,
              width: double.infinity,
              margin: EdgeInsets.only(top: 1.h,left: 1.h,right: 1.h),
              padding: EdgeInsets.symmetric(horizontal: 2.h,vertical: 0.h),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/grey_background.jpg",),
                    fit: BoxFit.cover
                ),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
              ),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [

                        SizedBox(height: 2.h,),
                        Row(
                          children: [
                            Text("Uploaded Courses",
                              style: TextStyle(fontSize: 13.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),),
                            Expanded(child: Divider(height: 2,
                              thickness: 1,
                              color: AppColors.appNewDarkThemeColor,indent: 10,))
                          ],
                        ),
                        SizedBox(height: 1.h,),

                      ],
                    ),
                  ),
                   loader == false ?
                       SliverToBoxAdapter(
                         child: Container(
                           height: 80.h,
                           child: Center(
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 SizedBox(height: 20,width: 20,
                                   child: CircularProgressIndicator(strokeWidth: 2,),
                                 ),
                                 Text("   Fetching Courses...",style: TextStyle(fontSize: 13.sp,
                                     color: Colors.grey,
                                     fontWeight: FontWeight.bold),)
                               ],
                             ),
                           ),
                         )
                       )
                       : courseList.length == 0
                       ? SliverToBoxAdapter(
                         child: Container(
                           height: 80.h,
                           child: Center(
                             child: Text("No Course Uploaded!",
                               style: TextStyle(fontWeight: FontWeight.bold,
                                   color: Colors.grey,fontSize: 25.sp),),
                           )
                         ),
                   )
                       : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return Container(
                              margin: EdgeInsets.only(top: 1.h,bottom: 1.h),
                              padding: EdgeInsets.all(1.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  border: Border.all(width: .5,color: Colors.black54)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 7.h,
                                          width: 15.w,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border:Border.all(width: 1,color: Colors.white),
                                            color:  Colors.white,),
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child:

                                              Image.network(
                                                StringConstant.IMAGE_URL+ courseList[index].image,
                                                height: 7.h,
                                                width: 15.w,
                                                fit: BoxFit.fill,
                                              )
                                            //     : Image.network(
                                            //   StringConstant.IMAGE_URL+ popularCourses[index].image,
                                            //   height: 7.h,
                                            //   width: 15.w,
                                            //   fit: BoxFit.fill,
                                            // ),
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [

                                              Text("${courseList[index].duration} hr",style: TextStyle(fontSize: 10.sp,
                                                  color: Colors.grey,fontWeight: FontWeight.bold),),

                                              Text("${courseList[index].name}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(fontSize: 14.sp),)
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    child: Container(
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
                                          size:15
                                      ),
                                    ),
                                    onTap: (){
                                      Navigator.push(context,MaterialPageRoute(
                                          builder: (context) => Lesson(
                                          catList:courseList[index].id,
                                          catImage:courseList[index].image,
                                          catName:courseList[index].name,
                                          catDescription:courseList[index].description,
                                          duration:courseList[index].duration,
                                          instructorName:widget.name,
                                          instructorImage:widget.image,
                                          language:courseList[index].language,
                                          level:courseList[index].level)));
                                    },
                                  )
                                ],
                              )
                          );
                        },
                        childCount: courseList.length
                    ),
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }

  void instructorCourses(var id) {
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
                ApiRepository().getInstructorCourses(value,id.toString()).then((value) {
                  if (value.status == "successfull") {
                    print("Hello I am here ${value.body}");
                    setState(() {
                      loader = true;
                      courseList = value.body;
                    });

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
}
