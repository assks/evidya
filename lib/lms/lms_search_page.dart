import 'package:cached_network_image/cached_network_image.dart';
import 'package:evidya/lms/lession.dart';
import 'package:evidya/lms/mentor_detail_page.dart';
import 'package:evidya/model/courses_modal.dart';
import 'package:evidya/model/login/contactsmatch_Modal.dart';
import 'package:evidya/network/repository/api_repository.dart';
import 'package:evidya/resources/app_colors.dart';
import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;
import '../constants/string_constant.dart';
class LMSSearchPage extends StatefulWidget {
  const LMSSearchPage({Key key}) : super(key: key);

  @override
  State<LMSSearchPage> createState() => _LMSSearchPageState();
}

class _LMSSearchPageState extends State<LMSSearchPage> {

  String choice = "Courses";
  List coursesList = [];
  List instructorList = [];
  bool loader = false;
  TextEditingController searchController;
  @override
  initState() {
    // at the beginning, all users are shown
    super.initState();
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    if (enteredKeyword.length > 2) {
      searchLMSData(enteredKeyword);
    }
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
      child:  Scaffold(
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
            title: Text("Search Here"),
          ),
          body: Container(
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
            child: SafeArea(
              child: Column(
                children: [

                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.h,vertical: 1.h),
                    child: Column(
                      children: [
                        TextFormField(
                          style: const TextStyle(color: Colors.black),
                          autofocus: false,
                          cursorColor: Colors.black,
                          controller: searchController,
                          decoration:  InputDecoration(
                              isDense: false,
                              border: InputBorder.none,
                              hintText: 'Search Here',
                              contentPadding: EdgeInsets.symmetric(horizontal:10,vertical: 10),
                              hintStyle: TextStyle(color: Colors.black,fontSize: 2.1.h),
                              suffixIcon: Icon(Icons.search,
                                size: 3.h,
                                color: Colors.black,)
                          ),
                          onChanged: (value){
                            _runFilter(value);
                          },
                        ),
                        const Divider(color: Colors.black,thickness: 1,
                          height: 1,
                          indent: 10,endIndent: 10,),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        color: Colors.white
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            child: Column(
                              children: [
                                SizedBox(height: 1.5.h,),
                                Text("Courses",style: TextStyle(fontSize: 2.1.h,
                                    fontWeight: FontWeight.w600),),
                                SizedBox(height: 1.5.h,),
                                Container(
                                  height: 2,
                                  width: 47.w,
                                  color: choice =="Courses"
                                      ? AppColors.appNewDarkThemeColor
                                      : Colors.white,
                                )
                              ],
                            ),
                            onTap: (){
                              setState(() {
                                choice ="Courses";
                              });
                            },
                          ),
                          InkWell(
                            child:  Column(
                              children: [
                                SizedBox(height: 1.5.h,),
                                Text("Instructor",style: TextStyle(fontSize: 2.1.h,
                                    fontWeight: FontWeight.w600)),
                                SizedBox(height: 1.5.h,),
                                Container(
                                    height: 2,
                                    width: 47.w,
                                    color: choice =="Instructor"
                                        ? AppColors.appNewDarkThemeColor
                                        : Colors.white
                                )
                              ],
                            ),
                            onTap: (){
                              setState(() {
                                choice ="Instructor";
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                     choice =="Courses"?
                      loader == false ?
                      coursesList.length != 0
                          ? Expanded(
                       flex: 1,
                       child: Padding(
                         padding: EdgeInsets.symmetric(horizontal: 2.h),
                         child: ListView.separated(
                             separatorBuilder: (_,__)=>SizedBox(height: 1.h,),
                             itemCount: coursesList.length,
                             itemBuilder: (BuildContext ctx, index) {
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
                                                     fit: BoxFit.fill,
                                                     imageUrl: StringConstant.IMAGE_URL + coursesList[index].image,
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
                                                 children: [
                                                   Text(coursesList[index].name,
                                                     maxLines: 2,
                                                     overflow: TextOverflow.ellipsis,
                                                     style: TextStyle(fontSize: 14.sp,
                                                         fontWeight: FontWeight.w700,
                                                         color:AppColors.appNewLightThemeColor),),
                                                   RichText(
                                                     text: TextSpan(
                                                       text: 'Duration: ',
                                                       style: TextStyle(color: Colors.black, fontSize: 10.sp),
                                                       children: <TextSpan>[
                                                         TextSpan(text: coursesList[index].duration + " hr",
                                                           style: TextStyle(fontSize: 10.sp,
                                                             fontWeight: FontWeight.w500,
                                                           ), )
                                                       ],
                                                     ),
                                                   ),
                                                   RichText(
                                                     text: TextSpan(
                                                       text: 'Language: ',
                                                       style: TextStyle(color: Colors.black, fontSize: 10.sp),
                                                       children: <TextSpan>[
                                                         TextSpan(text: coursesList[index].language,
                                                           style: TextStyle(fontSize: 10.sp,
                                                             fontWeight: FontWeight.w500,
                                                           ), )
                                                       ],
                                                     ),
                                                   ),
                                                   RichText(
                                                     text: TextSpan(
                                                       text: 'Level: ',
                                                       style: TextStyle(color: Colors.black, fontSize: 10.sp),
                                                       children: <TextSpan>[
                                                         TextSpan(text: coursesList[index].level,
                                                           style: TextStyle(fontSize: 10.sp,
                                                             fontWeight: FontWeight.w500,
                                                           ), )
                                                       ],
                                                     ),
                                                   ),
                                                   RichText(
                                                     text: TextSpan(
                                                       text: 'Instructor: ',
                                                       style: TextStyle(color: Colors.black, fontSize: 10.sp),
                                                       children: <TextSpan>[
                                                         TextSpan(text: coursesList[index].instructorName,
                                                           style: TextStyle(fontSize: 10.sp,
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

                                           Text(coursesList[index].description,
                                             maxLines: 3,
                                             overflow: TextOverflow.ellipsis,
                                             style: TextStyle(fontSize: 10.sp,
                                                 fontWeight: FontWeight.w500,
                                                 color:Colors.grey),),
                                         ],
                                       )
                                   ),
                                   onTap: () {
                                     Navigator.push(context,MaterialPageRoute(builder: (context) => Lesson(
                                         catList:coursesList[index].id,
                                         subCatId: coursesList[index].subcategoryId,
                                         catImage : coursesList[index].image,
                                         catName :coursesList[index].name,
                                         catDescription :coursesList[index].description,
                                         duration: coursesList[index].duration,
                                         instructorName: coursesList[index].instructorName,
                                         instructorImage : coursesList[index].instructorImage,
                                         language: coursesList[index].language,
                                         level:coursesList[index].level)));
                                   }
                               );

                             }),
                           ),
                         )
                          : Expanded(
                              child: Center(child: Text("No Course Found!",
                                style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20.sp
                               ),
                              ),
                              ),
                      )
                          : Expanded(child: Center(
                             child: Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             SizedBox(
                               height: 20,
                               width: 20,
                               child: CircularProgressIndicator(strokeWidth: 1.5,),
                             ),

                             Text("   Loading...", style: TextStyle(color: Colors.black, fontSize: 2.1.h),)
                           ],

                         )
                     ))
                         : loader == false ?
                           instructorList.length != 0
                         ? Expanded(
                         flex: 1,
                         child: Padding(
                           padding: EdgeInsets.symmetric(horizontal: 2.h),
                           child: ListView.separated(
                               separatorBuilder: (_,__)=>SizedBox(height: 1.h,),
                               itemCount: instructorList.length,
                               itemBuilder: (BuildContext ctx, index) {
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
                                                     imageUrl: StringConstant.IMAGE_URL + instructorList[index].image,
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
                                                 children: [
                                                   Text(instructorList[index].name,
                                                     maxLines: 2,
                                                     overflow: TextOverflow.ellipsis,
                                                     style: TextStyle(fontSize: 14.sp,
                                                         fontWeight: FontWeight.w700,
                                                         color:AppColors.appNewLightThemeColor),),

                                                   Text("${instructorList[index].specialization}",
                                                     maxLines: 2,
                                                     overflow: TextOverflow.ellipsis,
                                                     style: TextStyle(fontSize: 11.sp,
                                                         fontWeight: FontWeight.bold,
                                                         color:Colors.black),),

                                                   Text("Experience: ${instructorList[index].experience} Years",
                                                     maxLines: 2,
                                                     overflow: TextOverflow.ellipsis,
                                                     style: TextStyle(fontSize: 10.sp,
                                                         fontWeight: FontWeight.w500,
                                                         color:Colors.black),),
                                                 ],
                                               ))
                                             ],
                                           ),
                                         ],
                                       )
                                   ),
                                   onTap: () {
                                     Navigator.push(
                                         context,
                                         MaterialPageRoute(
                                             builder: (context) => MentorDetailsPage(
                                               id: instructorList[index].id.toString(),
                                             )));
                                   },
                                 );
                               }),
                         ))
                         : Expanded(
                          child: Center(child: Text("No Instructor Found!",
                           style: TextStyle(
                             color: Colors.grey,
                             fontSize: 20.sp
                             ),
                            ),
                           ),
                         )
                         : Expanded(child: Center(
                          child: Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             SizedBox(
                               height: 20,
                               width: 20,
                               child: CircularProgressIndicator(strokeWidth: 1.5,),
                             ),
                             Text("   Loading...", style: TextStyle(color: Colors.black, fontSize: 2.1.h),)
                           ],
                         ),
                       ),
                     ),
                ],
              ),
            ),
          ),
      ),
    );
  }

  void searchLMSData(String key) {
    setState(() {
      loader = true;
    });
    PreferenceConnector.getJsonToSharedPreferencetoken(StringConstant.loginData)
        .then((value) => {
      if (value != null)
        {
          ApiRepository().lmsSearch(key,value)
              .then((value) {
            if (value != null) {
              if (value.status == "successfull") {
                setState(() {
                  coursesList = value.body.courses;
                  instructorList = value.body.instructors;
                  print("User List ${coursesList.length}");
                  loader = false;
                });
              } else {
              }
            }
          })
        }
    });
  }
}
