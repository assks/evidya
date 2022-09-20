import 'package:cached_network_image/cached_network_image.dart';
import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/lms/lession.dart';
import 'package:evidya/lms/lesson_component/Description.dart';
import 'package:evidya/network/repository/api_repository.dart';
import 'package:evidya/resources/app_colors.dart';
import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:evidya/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class StudentCoursePage extends StatefulWidget {
  final String subCatId;
  final String title;
  const StudentCoursePage({this.subCatId,this.title,Key key}) : super(key: key);

  @override
  State<StudentCoursePage> createState() => _StudentCoursePageState();
}

class _StudentCoursePageState extends State<StudentCoursePage> {
  List catList = [];
  bool loader = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCategoryList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/back_ground.jpg"),
            fit: BoxFit.cover
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.appNewDarkThemeColor,
          title: Text("${widget.title}",),
          centerTitle: true,
          leading: IconButton(
            icon:  Icon(Icons.keyboard_backspace,
              size: 3.h,
              color: Colors.white,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.only(top: 1.h,left: 1.h,right: 1.h,bottom: 1.h),
                child: Container(
                  height: 100.h,
                  padding: EdgeInsets.only(top: 1.6.h,left: 1.6.h,right: 1.6.h,bottom: 1.6.h),
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
                      :ListView.separated(
                      separatorBuilder: (_,__)=>SizedBox(height: 1.h,),
                      itemCount: catList.length,
                      itemBuilder: (BuildContext ctx, index) {
                        if(catList.length == 0){
                          return Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Text("No Courses Here!",style: TextStyle(fontSize: 16.sp,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),)
                              ],
                            ),
                          );
                        }
                        else{
                          return InkWell(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 1.h),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                      10
                                  )),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 10.h,
                                        width: 23.w,
                                        child:ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: CachedNetworkImage(
                                            height: 10.h,
                                            width: 23.w,
                                            fit: BoxFit.cover,
                                            imageUrl: StringConstant.IMAGE_URL + catList[index].image,
                                            placeholder: (context, url) =>
                                                SizedBox(height: 20,width: 20,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 1,
                                                  ),
                                                ),
                                            errorWidget: (context, url, error) =>
                                                Image.asset("assets/images/bvidhya.png"),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 1.h,),
                                      Expanded(child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(catList[index].name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 2.3.h,
                                                fontWeight: FontWeight.w700,
                                                color:AppColors.appNewLightThemeColor),),
                                          RichText(
                                            text: TextSpan(
                                              text: 'Duration: ',
                                              style: TextStyle(color: Colors.black, fontSize: 1.6.h),
                                              children: <TextSpan>[
                                                TextSpan(text: catList[index].duration + " hr",
                                                  style: TextStyle(fontSize: 1.6.h,
                                                    fontWeight: FontWeight.w500,
                                                  ), )
                                              ],
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: 'Language: ',
                                              style: TextStyle(color: Colors.black, fontSize: 1.6.h),
                                              children: <TextSpan>[
                                                TextSpan(text: catList[index].language,
                                                  style: TextStyle(fontSize: 1.6.h,
                                                    fontWeight: FontWeight.w500,
                                                  ), )
                                              ],
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: 'Level: ',
                                              style: TextStyle(color: Colors.black, fontSize: 1.6.h),
                                              children: <TextSpan>[
                                                TextSpan(text: catList[index].level,
                                                  style: TextStyle(fontSize: 1.6.h,
                                                    fontWeight: FontWeight.w500,
                                                  ), )
                                              ],
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: 'Instructor: ',
                                              style: TextStyle(color: Colors.black, fontSize: 1.6.h),
                                              children: <TextSpan>[
                                                TextSpan(text: catList[index].instructorName,
                                                  style: TextStyle(fontSize: 1.6.h,
                                                    fontWeight: FontWeight.w500,
                                                  ), )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ))
                                    ],
                                  ),
                                  SizedBox(height: 1.h,),

                                  Text(catList[index].description,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 1.6.h,
                                        fontWeight: FontWeight.w500,
                                        color:Colors.grey),),
                                  // Expanded(child:  Container(
                                  //   padding: EdgeInsets.only(right: 10,left: 10),
                                  //   alignment: Alignment.center,
                                  //   child: Column(
                                  //     mainAxisAlignment: MainAxisAlignment.start,
                                  //     crossAxisAlignment: CrossAxisAlignment.start,
                                  //     children: [
                                  //
                                  //
                                  //     ],
                                  //   ),
                                  // ))
                                ],
                              )
                            ),
                            onTap: () {
                              Navigator.push(context,MaterialPageRoute(builder: (context) => Lesson(
                                  catList:catList[index].id,
                                  subCatId: catList[index].subcategoryId,
                                  catImage:catList[index].image,
                                  catName:catList[index].name,
                                  catDescription:catList[index].description,
                                  duration:catList[index].duration,
                                  instructorName:catList[index].instructorName,
                                  instructorImage:catList[index].instructorImage,
                                  language:catList[index].language,
                                  level:catList[index].level)));
                            },
                          );
                        }

                      }),
                )
            )
        ),
      ),
    );
  }
  void fetchCategoryList() {
    loader = false;
    print("sadfgtegf ${widget.subCatId}");
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
                ApiRepository().courses(value,widget.subCatId).then((value) {
                  if (value != null) {
                    setState(() {
                      catList = value.body.courses;
                      loader = true;
                      print("hello $catList");
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
}
