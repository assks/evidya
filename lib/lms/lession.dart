import 'package:cached_network_image/cached_network_image.dart';
import 'package:evidya/landscape_player/landscape_player.dart';
import 'package:evidya/lms/Videoplayer.dart';
import 'package:evidya/lms/lesson_component/Curriculum.dart';
import 'package:evidya/lms/lesson_component/Description.dart';
import 'package:evidya/resources/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sizer/sizer.dart';
import '../../constants/string_constant.dart';
import '../../model/lesson_modal.dart';
import '../../network/repository/api_repository.dart';
import '../../sharedpref/preference_connector.dart';
import '../../utils/helper.dart';
import '';
import '../model/courses_modal.dart';

class Lesson extends StatefulWidget {
  final String page;
  final dynamic catList;
  final dynamic subCatId;
  final String instructorImage;
  final String catImage;
  final String catName;
  final String duration;
  final String catDescription;
  final String instructorName;
  final String level;
  final String language;
  const Lesson({Key key,this.page,
    this.subCatId,
    this.catImage,this.catName,this.catDescription,this.duration,
    this.catList,this.instructorImage,this.language,this.instructorName,this.level,
  }) : super(key: key);

  @override
  State<Lesson> createState() => _LessonState();
}

class _LessonState extends State<Lesson> {
  String choice = "Description";
  List<Lessons> lessonlist;
  bool loader = false, loader1 = false;
  bool liked = false;
  bool isReadmore= false;
  double _ratingValue = 0.0;
  TextEditingController commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    fetchCategoryList(widget.catList);
    fetchlessonList(widget.catList);

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
         body: SafeArea(
           child: Container(
               height: 100.h,
               margin: EdgeInsets.only(left: 1.h,right: 1.h),
               width: double.infinity,
               decoration: BoxDecoration(
                 image: DecorationImage(
                     image: AssetImage("assets/images/grey_background.jpg",),
                     fit: BoxFit.cover
                 ),
                 borderRadius: BorderRadius.only(topLeft: Radius.circular(20),
                     topRight: Radius.circular(20)),
               ),
               child:  Column(
                 children: [
                   Stack(
                     children: [
                       Container(
                         padding: EdgeInsets.all(1.h),
                         child: ClipRRect(
                           borderRadius: BorderRadius.circular(20),
                           child: CachedNetworkImage(
                             height: 25.h,
                             width: double.infinity,
                             fit: BoxFit.cover,
                             imageUrl:StringConstant.IMAGE_URL+ widget.catImage,
                           ),
                         )
                       ),
                       Positioned(
                         top: 10,
                           left: 10,
                           child: CircleAvatar(
                             radius: 2.5.h,
                            backgroundColor: Colors.black26,
                             child: IconButton(
                               icon: Icon(Icons.keyboard_backspace,
                               size: 3.h,
                               color: Colors.white,),
                             onPressed: (){
                               Navigator.pop(context);
                           },
                         ),
                       ),
                       ),
                     ],
                   ),

                   Padding(
                     padding: EdgeInsets.all(1.h),
                     child: Column(
                       children: <Widget>[
                         Row(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             SizedBox(
                                 width: 70.w,
                                 child: Text(
                                   widget.catName,
                                   style: TextStyle(fontSize: 2.h,
                                       color: Colors.black,
                                       fontWeight: FontWeight.w600
                                   ),
                                 ),
                             ),
                             CircleAvatar(
                               backgroundColor:AppColors.addedColor,
                               radius: 2.2.h,
                               child:  InkWell(
                                 child: Icon(
                                     Icons.favorite,
                                     color: liked == false
                                         ? Colors.white
                                         : Colors.redAccent,
                                     size:3.h
                                 ),
                                 onTap: () {
                                   setState(() {
                                     liked = true;
                                   });
                                   likedCourses(widget.catList);
                                 },
                               ),
                             )
                           ],
                         ),
                         SizedBox(
                           height: 2.h,
                         ),
                         Row(
                           crossAxisAlignment: CrossAxisAlignment.center,
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Row(
                               children: [
                                 widget.instructorImage != ""?CircleAvatar(
                                   radius: 2.1.h, // Image radius
                                   backgroundImage: NetworkImage(
                                     StringConstant.IMAGE_URL + widget.instructorImage,
                                   ),
                                 )
                                 :CircleAvatar(
                                   radius: 2.1.h, // Image radius
                                   backgroundImage: NetworkImage(
                                     StringConstant.IMAGE_URL + 'users/default.png',
                                   ),
                                 ),
                                 SizedBox(width: 4,),
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     FittedBox(
                                       fit: BoxFit.cover,
                                       child: Text('Created by',
                                         style: TextStyle(fontSize: 1.4.h),),
                                     ),
                                     FittedBox(
                                       fit: BoxFit.cover,
                                       child: Text(
                                         '${widget.instructorName}',
                                         style: TextStyle(
                                             fontSize: 1.4.h,
                                             fontWeight: FontWeight.bold),
                                       ),
                                     ),
                                   ],
                                 ),
                               ],
                             ),
                             Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: <Widget>[
                                 FittedBox(
                                   fit: BoxFit.cover,
                                   child: loader1 == true
                                     ? RatingBarIndicator(
                                     rating: double.parse(catList.rating),
                                     itemBuilder: (context, index) => const Icon(
                                       Icons.star,
                                       color: Colors.amber,
                                     ),
                                     itemCount: 5,
                                     itemSize: 15.0,
                                     direction: Axis.horizontal,
                                   )
                                     : Text('Rating ..',
                                     style: TextStyle(fontSize: 1.4.h),),
                                 ),
                                 FittedBox(
                                   fit: BoxFit.cover,
                                   child: Text("language: " + widget.language,style: TextStyle(
                                       fontSize: 1.4.h,
                                       fontWeight: FontWeight.bold),),
                                 ),
                               ],
                             ),
                             Row(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Icon(Icons.remove_red_eye_outlined,
                                   size: 4.h,
                                   color: Colors.grey,),
                                 SizedBox(width: 4,),
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     FittedBox(
                                       fit: BoxFit.cover,
                                       child: Text("Views",style: TextStyle(
                                         fontSize: 1.4.h,),),
                                     ),
                                     FittedBox(
                                       fit: BoxFit.cover,
                                       child: loader1 == true
                                       ? Text("${catList.views}",
                                         style: TextStyle(
                                           fontSize: 1.4.h,
                                           fontWeight: FontWeight.bold),)
                                       : Text("0"),
                                     ),
                                   ],
                                 ),
                               ],
                             ),
                           ],
                         ),
                         SizedBox(
                           height: 1.h,
                         ),

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
                                 SizedBox(height: 1.h,),
                                 Text("Description",
                                   style: TextStyle(fontSize: 2.1.h,
                                     fontWeight: FontWeight.w600),),
                                 SizedBox(height: 1.h,),
                                 Container(
                                   height: 2,
                                   width: 47.w,
                                   color: choice =="Description"?
                                   AppColors.appNewDarkThemeColor
                                       :Colors.white,)
                               ],
                             ),
                             onTap: (){
                               setState(() {
                                 choice ="Description";
                               });
                             },
                           ),
                           InkWell(
                             child:  Column(
                               children: [
                                 SizedBox(height: 1.h,),
                                 Text("Curriculum",style: TextStyle(fontSize: 2.1.h,
                                     fontWeight: FontWeight.w600)),
                                 SizedBox(height: 1.h,),
                                 Container(
                                     height: 2,
                                     width: 47.w,
                                     color: choice =="Curriculum"?
                                     AppColors.appNewDarkThemeColor
                                         :Colors.white)
                               ],
                             ),
                             onTap: (){
                               setState(() {
                                 choice ="Curriculum";
                               });
                             },
                           )

                         ],
                       ),
                     ),
                   ),
                   SizedBox(height: 1.h,),
                   choice =="Description"
                       ? Expanded(
                          flex:1,
                          child: loader1 == false
                              ? Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 30,width: 30,
                                  child: CircularProgressIndicator(strokeWidth: 2,),),
                                SizedBox(width:10),
                                Text("Fetching Data...",style: TextStyle(fontSize: 2.1.h,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),)
                              ],
                            ),
                          )
                              : SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 1.h),
                                  color: Colors.white,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(width: 43.w,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children:  [
                                                RichText(
                                                  text: TextSpan(
                                                    children: <TextSpan>[
                                                      TextSpan(text: 'Duration: ', style: TextStyle(fontSize: 1.6.h,
                                                          color: Colors.black,fontWeight: FontWeight.w500)),
                                                      TextSpan(text: widget.duration + ' hr',
                                                       style: TextStyle(color: Colors.black,
                                                           fontSize: 1.5.h,fontWeight: FontWeight.bold),),
                                                    ],
                                                  ),
                                                ),
                                                Icon(Icons.access_time_rounded,size: 2.5.h,),
                                              ],
                                            ),
                                           SizedBox(height: .5.h,),
                                           Divider(height: .5,thickness: .5,color: Colors.grey,),
                                            SizedBox(height: .5.h,),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children:  [
                                                RichText(
                                                  text: TextSpan(
                                                    children: <TextSpan>[
                                                      TextSpan(text: 'Lectures: ', style: TextStyle(fontSize: 1.6.h,
                                                          color: Colors.black,fontWeight: FontWeight.w500)),
                                                      TextSpan(text: catList.numberOfLesson,
                                                        style: TextStyle(color: Colors.black,
                                                            fontSize: 1.5.h,fontWeight: FontWeight.bold),),
                                                    ],
                                                  ),
                                                ),
                                                Icon(Icons.menu_book_outlined,size: 2.5.h,),
                                              ],
                                            ),
                                            SizedBox(height: .5.h,),
                                            Divider(height: .5,thickness: .5,color: Colors.grey,),
                                            SizedBox(height: .5.h,),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children:  [
                                                RichText(
                                                  text: TextSpan(
                                                    children: <TextSpan>[
                                                      TextSpan(text: '', style: TextStyle(fontSize: 1.6.h,
                                                          color: Colors.black,fontWeight: FontWeight.w500)),
                                                      TextSpan(text: 'Certification',
                                                        style: TextStyle(color: Colors.black,
                                                            fontSize: 1.5.h,fontWeight: FontWeight.bold),),
                                                    ],
                                                  ),
                                                ),
                                                Icon(Icons.receipt_long_rounded,size: 2.5.h,),
                                              ],
                                            ),

                                          ],
                                        ),

                                      ),
                                      SizedBox(width: 43.w,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children:  [
                                                RichText(
                                                  text: TextSpan(
                                                    children: <TextSpan>[
                                                      TextSpan(text: 'Level: ', style: TextStyle(fontSize: 1.6.h,
                                                          color: Colors.black,fontWeight: FontWeight.w500)),
                                                      TextSpan(text: widget.level,
                                                        style: TextStyle(color: Colors.black,
                                                            fontSize: 1.5.h,fontWeight: FontWeight.bold),),
                                                    ],
                                                  ),
                                                ),
                                                Icon(Icons.auto_graph_rounded,size: 2.5.h,),
                                              ],
                                            ),
                                            SizedBox(height: .5.h,),
                                            Divider(height: .5,thickness: .5,color: Colors.grey,),
                                            SizedBox(height: .5.h,),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children:  [
                                                RichText(
                                                  text: TextSpan(
                                                    children: <TextSpan>[
                                                      TextSpan(text: '', style: TextStyle(fontSize: 1.6.h,
                                                          color: Colors.black,fontWeight: FontWeight.w500)),
                                                      TextSpan(text: 'Full Time Access',
                                                        style: TextStyle(color: Colors.black,
                                                            fontSize: 1.5.h,fontWeight: FontWeight.bold),),
                                                    ],
                                                  ),
                                                ),
                                                Icon(Icons.all_inclusive,size: 2.5.h,),
                                              ],
                                            ),
                                            // SizedBox(height: .5.h,),
                                            // Divider(height: .5,thickness: .5,color: Colors.grey,),
                                            // SizedBox(height: .5.h,),
                                            // Row(
                                            //   crossAxisAlignment: CrossAxisAlignment.center,
                                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            //   children:  [
                                            //     RichText(
                                            //       text: TextSpan(
                                            //         children: <TextSpan>[
                                            //           TextSpan(text: 'Lectures: ', style: TextStyle(fontSize: 1.6.h,
                                            //               color: Colors.black,fontWeight: FontWeight.w500)),
                                            //           TextSpan(text: catList.numberOfLesson,
                                            //             style: TextStyle(color: Colors.black,
                                            //                 fontSize: 1.5.h,fontWeight: FontWeight.bold),),
                                            //         ],
                                            //       ),
                                            //     ),
                                            //     Icon(Icons.menu_book_outlined,size: 2.5.h,),
                                            //     Text("Duration: "+widget.duration + " hr",
                                            //       style: TextStyle(
                                            //           fontSize: 1.6.h
                                            //       ),),
                                            //     SizedBox(width:2.w,),
                                            //     Icon(Icons.access_time_rounded,size: 2.5.h,),
                                            //   ],
                                            // ),

                                          ],
                                        ),

                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 1.h,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 1.h),
                                  color: Colors.white,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 1.h,),
                                      Text("Description",
                                          style: TextStyle(fontSize: 2.5.h, fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      buildText("${widget.catDescription}",),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: TextButton(onPressed: (){
                                          setState(() {
                                            // toggle the bool variable true or false
                                            isReadmore = !isReadmore;
                                          });
                                        }, child: Text((isReadmore?'Read Less' : 'Read More'))),
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      Text("Objective",
                                          style: TextStyle(fontSize: 2.5.h, fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      Text("${catList.objective}",
                                        style: TextStyle(fontSize: 1.8.h,color: Colors.black),),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      Text("Future Benefits",
                                          style: TextStyle(fontSize: 2.5.h, fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        height: .5.h,
                                      ),
                                      Text("${catList.benefit}",
                                        style: TextStyle(fontSize: 1.8.h,color: Colors.black),),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      Text("Audience Target",
                                          style: TextStyle(fontSize: 2.h, fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        height: .5.h,
                                      ),
                                      Text("${catList.audience}",
                                        style: TextStyle(fontSize: 1.8.h,color: Colors.black),),
                                      SizedBox(
                                        height: 1.h,
                                      ),


                                    ],
                                  ),
                                ),
                                SizedBox(height: 2.h,),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 0.h),
                                  child: Text("Student Feedback",
                                    style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15.sp),),
                                ),
                                Container(height: 20.h,
                                  padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 1.h),
                                  child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context,i){
                                        return Container(
                                          width: 70.w,
                                          padding: EdgeInsets.symmetric(horizontal: 2.h,vertical: 1.h),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(15)
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Piyush Kanwal",
                                                  style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15.sp)),
                                              Text("Learner",style: TextStyle(fontSize: 11.sp,
                                                  color: Colors.grey),),
                                              RatingBarIndicator  (
                                                rating: 5.0,
                                                itemBuilder: (context, index) => const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                itemCount: 5,
                                                itemSize: 15.0,
                                                direction: Axis.horizontal,
                                              ),
                                              SizedBox(height: .5.h,),
                                              Text("I have learned so much in my classes with"
                                                  " (TN). She/He paces the class just right"
                                                  " so you feel challenged but not overwhelmed."
                                                  " So many other classes you just read from a "
                                                  "text book but in his classes (TN) asks questions "
                                                  "and gets the students to respond which is both "
                                                  "fun and promotes faster learning. She/He is "
                                                  "patient and eager to help. I’m thrilled to"
                                                  " have found her/his class!",
                                                maxLines: 4,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(fontSize: 1.5.h,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                      separatorBuilder: (_,__)=>SizedBox(width: 1.h,),
                                      itemCount: 8),
                                ),
                              ],
                            ),
                          )
                         )
                       : loader == true
                       ? Expanded(child: ListView.builder(
                             shrinkWrap: true,
                             physics: ScrollPhysics(),
                             scrollDirection: Axis.vertical,
                             itemCount: lessonlist.length,
                            itemBuilder: (context, position) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 0.h),
                            child: Wrap(children: [
                              GestureDetector(
                                   child: Card(
                                       elevation: 2,
                                       margin: EdgeInsets.all(.5.h),
                                       shape: RoundedRectangleBorder(
                                       borderRadius: BorderRadius.circular(10.0)),
                                     child: Container(
                                       width: double.infinity,
                                       padding: EdgeInsets.symmetric(horizontal:1.h,vertical: 1.h),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                             children: [
                                               Expanded(
                                                 child: Column(
                                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                   children: [
                                                     Text("Lesson: ${position+1}",
                                                         style: TextStyle(fontSize: 1.6.h,
                                                             color: Colors.grey,
                                                             fontWeight: FontWeight.bold)),
                                                     SizedBox(height: .5.h,),
                                                     loader == false ? Text("Loading...")
                                                         :Text("${lessonlist[position].name}",
                                                       maxLines: 2,
                                                       overflow: TextOverflow.ellipsis,
                                                       style: TextStyle(fontSize: 1.8.h,fontWeight: FontWeight.bold),),
                                                   ],
                                                 ),
                                               ),
                                               SizedBox(width: 1.h,),
                                               if(position == 0)
                                               InkWell(
                                                 child: Icon(Icons.play_circle_fill_rounded,
                                                     color: AppColors.appNewDarkThemeColor,
                                                   size: 3.h,
                                                 ),
                                                 onTap: (){
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                    builder: (context) => LandscapePlayer(
                                                    lessonId: lessonlist[0].id.toString(),
                                                    videourl: lessonlist[0].videoUrl,
                                                    vidoeid:lessonlist[0].videoId.toString(),
                                                    userid:lessonlist[0].userId.toString(),
                                                    )));
                                                 },
                                               )
                                             ],
                                            ),
                                            // if(position == 0)
                                            //   Column(
                                            //     children: [
                                            //         Divider(height: 2.h,
                                            //           thickness: .5,
                                            //           color: Colors.black,),
                                            //       loader == false
                                            //           ? Text("......")
                                            //           : Text("${lessonlist[position].description}",
                                            //         maxLines: 2,
                                            //         overflow: TextOverflow.ellipsis,
                                            //         style: TextStyle(fontSize: 1.5.h,
                                            //             color: Colors.grey
                                            //         ),),
                                            //
                                            //     ],
                                            //   ),



                                          ],
                                        ),
                                 )
                             ),
                                onTap: (){
                                     if(position == 0){
                                      Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => LandscapePlayer(
                                        lessonId: lessonlist[0].id.toString(),
                                        videourl: lessonlist[0].videoUrl,
                                        vidoeid:lessonlist[0].videoId.toString(),
                                        userid:lessonlist[0].userId.toString(),
                                      )));}
                                     else{
                                       EasyLoading.showToast("Please subscribe course first.",
                                           toastPosition: EasyLoadingToastPosition.bottom);
                                     }
                                },
                           )
                         ]),);
                     },
                   ),)
                       : Expanded(child: Center(
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         SizedBox(height: 30,width: 30,
                           child: CircularProgressIndicator(strokeWidth: 2,),),
                         SizedBox(width:10),
                         Text("Fetching Data...",style: TextStyle(fontSize: 2.1.h,
                             color: Colors.grey,
                             fontWeight: FontWeight.bold),)
                       ],
                     ),
                   ),
                   ),
                 ],
               )
           ),
         ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.addedColor,
            onPressed: (){
              showRatingBar(context, widget.catList);
            },
            child: Icon(Icons.message,
              size: 3.h,
              color: AppColors.appNewDarkThemeColor,),),
        bottomNavigationBar: Container(
          margin: EdgeInsets.only(left:1.h,right: 1.h,bottom: 1.h),
         decoration: BoxDecoration(
           color: Colors.white,
           borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),
               bottomLeft: Radius.circular(20)),
          ),
          height: 8.h,
          padding: EdgeInsets.all(1.h),
          child: GestureDetector(
              onTap: (){
                  if(lessonlist.isNotEmpty){
                    subscribeLesson(widget.catList);
                  }else{
                    EasyLoading.showInfo("No data Found ");
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
                    child: Text(
                      "Subscription",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 2.1.h,
                          fontWeight: FontWeight.w700,
                          letterSpacing: .5
                      ),
                    ),
                  ),
                ),)),
        ),
          )
    );
  }

  Widget buildText(String text){

    // if read more is false then show only 3 lines from text
    // else show full text
    final lines = isReadmore ? null : 10;
    return Text(
      text,
      style: TextStyle(fontSize: 1.8.h,color: Colors.black),
      maxLines: lines,
      // overflow properties is used to show 3 dot in text widget
      // so that user can understand there are few more line to read.
      overflow: isReadmore ? TextOverflow.visible: TextOverflow.ellipsis,
    );
  }



  var catList;

  void fetchCategoryList(var courseId) {
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
                ApiRepository().courseDetails(value,courseId.toString()).then((value) {
                  if (value != null) {
                    setState(() {
                      catList = value.body.course;
                      loader1 = true;
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


  void fetchlessonList(var course_id) {
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
                ApiRepository().lesson(value,course_id.toString()).then((value) {
                  if (value != null) {
                    setState(() {
                      lessonlist = value.body.lessons;
                      loader = true;
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

  void subscribeLesson(var course_id) {
    EasyLoading.show();
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
                ApiRepository().subscribeLesson(value,course_id.toString()).then((value) {
                  if (value['status'] == "successfully") {
                    print("Success $value");
                    setState(() {
                      EasyLoading.showToast("You have successfully subscribe this lesson.",
                      toastPosition: EasyLoadingToastPosition.top,
                          duration: Duration(seconds: 2));
                      EasyLoading.dismiss();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LandscapePlayer(
                            lessonId: lessonlist[0].id.toString(),
                            videourl: lessonlist[0].videoUrl,
                            vidoeid:lessonlist[0].videoId.toString(),
                            userid:lessonlist[0].userId.toString(),
                          )));
                    });
                  } else {
                    EasyLoading.dismiss();
                    EasyLoading.showToast("Error! Something went wrong.");
                  }
                })
              }
            else
              {
               EasyLoading.dismiss(),
                EasyLoading.showToast(
                    "Something went wrong please logout and login again.")
              }
          })
        }
      else
        {Helper.showNoConnectivityDialog(context)}
    });
  }

  void likedCourses(var course_id) {
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
                ApiRepository().likeCourse(value,course_id.toString()).then((value) {
                  if (value.status == "successfully") {
                    print("Success $value");
                    setState(() {
                      EasyLoading.showToast("You liked this course.",
                          toastPosition: EasyLoadingToastPosition.bottom,
                          duration: Duration(seconds: 2));

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

  showRatingBar(BuildContext cnx,var courseId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
          return SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.only(top: 10,bottom:MediaQuery.of(context).viewInsets.bottom +20,left: 20,right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft:Radius.circular(20),
                    topRight: Radius.circular(20),),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 1.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Give Feedback",style: TextStyle(fontSize: 18.sp,),),
                        InkWell(
                          child: Icon(Icons.cancel_outlined,size: 25,),
                          onTap: (){
                            commentController.clear();
                            _ratingValue == "null";
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),

                    SizedBox(height: 2.h,),
                    RatingBar(
                        initialRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        ratingWidget: RatingWidget(
                            full: const Icon(Icons.star, color: Colors.orange),
                            half: const Icon(
                              Icons.star_half,
                              color: Colors.orange,
                            ),
                            empty:  Icon(
                              Icons.star_outline,
                              color: Colors.black,
                            )),
                        onRatingUpdate: (value) {
                          setState(() {
                            _ratingValue = value;
                          });
                        }),
                    SizedBox(height: 2.h,),
                    Form(
                      key: _formKey,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: .5,color:Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          style:  TextStyle(color: Colors.black,fontSize: 2.0.h),
                          autofocus: false,
                          cursorColor: Colors.black,
                          controller: commentController,
                          maxLines: 5,
                          decoration:  InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 2.h,vertical: 1.h),
                            border: InputBorder.none,
                            hintText: 'Comment',
                            hintStyle: TextStyle(color: Colors.grey,fontSize: 2.0.h),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter Comment here!';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h,),
                    GestureDetector(
                      child: Card(
                        elevation: 0,
                        color: AppColors.appNewDarkThemeColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child:
                              Text("Submit",style:TextStyle(fontSize: 2.1.h,
                                  letterSpacing: .5,
                                  color: Colors.white
                              )),

                            )
                        ),
                      ),
                      onTap: (){
                        print("Rating $_ratingValue");
                        if(_formKey.currentState.validate()){
                          print("Rating12233 $_ratingValue");
                          Navigator.pop(context);
                          rating(courseId);
                          EasyLoading.showToast("Feedback Submitted.",
                              duration: Duration(seconds: 2),
                              toastPosition: EasyLoadingToastPosition.bottom);
                        }
                      },
                    ),


                  ],
                )
            ),
          );
        });

      },
    );
  }


  void rating(var course_id) {
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
                ApiRepository().courseFeedback(
                  courseId: course_id.toString(),
                  token: value,
                  rating: _ratingValue.toString(),
                  comment: commentController.text
                ).then((value) {
                  if (value['status'] == "successfully") {
                    print("Success $value");
                    setState(() {
                      EasyLoading.showToast("Thank you for your feedback.",
                          toastPosition: EasyLoadingToastPosition.bottom,
                          duration: Duration(seconds: 2));

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
