import 'package:cached_network_image/cached_network_image.dart';
import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/lms/lession.dart';
import 'package:evidya/lms/request_private_class.dart';
import 'package:evidya/network/repository/api_repository.dart';
import 'package:evidya/resources/app_colors.dart';
import 'package:evidya/screens/user/teacher_courses_list_page.dart';
import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:evidya/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sizer/sizer.dart';
class MentorDetailsPage extends StatefulWidget {
  final String id;
  final bool followed;
  const MentorDetailsPage({this.id,this.followed, Key key}) : super(key: key);

  @override
  State<MentorDetailsPage> createState() => _MentorDetailsPageState();
}

class _MentorDetailsPageState extends State<MentorDetailsPage> {
  String choice = "Courses";
  bool loader = false;
  var instructorDetails;
  bool follow;
  List courses;
  List followers;
  List watchTime;
  List meetings;
  List webinars;
  List liked;
  @override
  void initState() {
    // TODO: implement initState
    follow = widget.followed;
    allMentorDetails();
    super.initState();
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
        child: SafeArea(
          child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.transparent,
              body: Padding(
                padding: EdgeInsets.only(left: 1.h,right: 1.h,bottom: 1.h),
                child: Column(
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
                            padding: EdgeInsets.only(left: 3.h,right: 3.h,bottom: 1.h),
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
                                loader == true
                                    ? Text("${instructorDetails.name??""}",style:
                                TextStyle(color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: .5,
                                    fontSize: 17.sp),)
                                    : SizedBox(height: 20,width: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2,),),
                                loader == true
                                    ? Text("(${instructorDetails.experience} years of experience)",
                                  style: TextStyle(color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: .5,
                                      fontSize: 9.sp),)
                                    : Text(""),
                                loader == true
                                    ? Text("${instructorDetails.email}",
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: .5,
                                      fontSize: 11.sp),)
                                  : Text("Loading..."),
                                SizedBox(height: 1.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          loader == false ? TextSpan(text: "0 ",
                                            style: TextStyle(color: Colors.black,
                                                fontSize: 10.sp,fontWeight: FontWeight.bold),):
                                          TextSpan(text: "${followers[0].count} ",
                                            style: TextStyle(color: Colors.black,
                                                fontSize: 10.sp,fontWeight: FontWeight.bold),),
                                          TextSpan(text: 'Followers', style: TextStyle(fontSize: 10.sp,
                                              color: Colors.black,fontWeight: FontWeight.bold))
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          loader == false ? TextSpan(text: "0 ",
                                            style: TextStyle(color: Colors.black,
                                                fontSize: 10.sp,fontWeight: FontWeight.bold),):
                                          TextSpan(text: '${watchTime[0].total??"0"}', style: TextStyle(color: Colors.black,
                                              fontSize: 10.sp,fontWeight: FontWeight.bold),),
                                          TextSpan(text: ' Watch mins', style: TextStyle(fontSize: 10.sp,
                                              color: Colors.black,fontWeight: FontWeight.bold))
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                                SizedBox(height: 1.h,),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   GestureDetector(
                                       onTap: (){
                                         setState(() {
                                           follow = true;
                                         });
                                         followInstructor(widget.id);
                                       },
                                       child: Center(
                                         child: Container(
                                           width: 30.w,
                                           height: 5.h,
                                           decoration: follow == true
                                               ? BoxDecoration(
                                               borderRadius: BorderRadius.circular(10),
                                               color: Colors.grey.shade500
                                           )
                                               : BoxDecoration(
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
                                             child: Padding(
                                               padding: EdgeInsets.symmetric(vertical: 1.h,),
                                               child: follow == true
                                                   ? Text(
                                                 "Followed",
                                                 style: TextStyle(
                                                     color: Colors.white,
                                                     fontSize: 12.sp,
                                                     fontWeight: FontWeight.w700,
                                                     letterSpacing: .5
                                                 ),
                                               )
                                                   : Text(
                                                 "Follow",
                                                 style: TextStyle(
                                                     color: Colors.white,
                                                     fontSize: 12.sp,
                                                     fontWeight: FontWeight.w700,
                                                     letterSpacing: .5
                                                 ),
                                               ),
                                             ),
                                           ),
                                         ),)),
                                   GestureDetector(
                                       onTap: (){
                                         Navigator.push(context,MaterialPageRoute(builder: (context)=>
                                             RequestPrivateClass(
                                               instructorId: widget.id
                                             )));
                                       },
                                       child: Center(
                                         child: Container(
                                           width: 50.w,
                                           height: 5.h,
                                           decoration: BoxDecoration(
                                             image: DecorationImage(
                                                 image: AssetImage("assets/images/back_ground.jpg",),
                                                 fit: BoxFit.cover
                                             ),
                                             borderRadius: BorderRadius.circular(10),
                                           ),
                                           child:  Center(
                                             child: Padding(
                                                 padding: EdgeInsets.symmetric(vertical: 1.h,),
                                                 child:  Row(
                                                   mainAxisAlignment: MainAxisAlignment.center,
                                                   children: [
                                                     Text(
                                                       "Request for Classes",
                                                       style: TextStyle(
                                                           color: AppColors.white,
                                                           fontSize: 12.sp,
                                                           fontWeight: FontWeight.w700,
                                                           letterSpacing: .5
                                                       ),
                                                     ),
                                                     // SizedBox(width: 10,),
                                                     // Icon(Icons.arrow_forward_rounded,size: 18,
                                                     //   color: AppColors.white,)
                                                   ],
                                                 )
                                             ),
                                           ),
                                         ),)),
                                 ],
                               )
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
                            child: Stack(
                              children: [
                                Container(
                                   // margin: EdgeInsets.only(bottom: 5,right: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(width: 1,color: Colors.transparent),
                                      color: Colors.transparent,),
                                    child: loader == true?
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        StringConstant.IMAGE_URL + instructorDetails.image,
                                        height: 10.h,
                                        width: 21.w,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                        : ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        'assets/images/teacher.PNG',
                                        height: 10.h,
                                        width: 21.w,
                                        fit: BoxFit.fill,
                                      ),
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
                      height: 59.h,
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
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20)
                                ),
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
                                        Text("Courses",style: TextStyle(fontSize: 13.sp,
                                            fontWeight: FontWeight.w600),),
                                        SizedBox(height: 1.5.h,),
                                        Container(
                                          height: 2,
                                          width: 47.w,
                                          color: choice =="Courses"?
                                          AppColors.appNewDarkThemeColor
                                              :Colors.white,)
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
                                        Text("About",style: TextStyle(fontSize: 13.sp,
                                            fontWeight: FontWeight.w600)),
                                        SizedBox(height: 1.5.h,),
                                        Container(
                                            height: 2,
                                            width: 47.w,
                                            color: choice =="About"?
                                            AppColors.appNewDarkThemeColor
                                                :Colors.white)
                                      ],
                                    ),
                                    onTap: (){
                                      setState(() {
                                        choice ="About";
                                      });
                                    },
                                  )

                                ],
                              ),
                            ),
                          ),
                          choice =="About"
                              ? Expanded(
                              flex: 1,
                              child: Padding(
                               padding: EdgeInsets.symmetric(horizontal: 3.h,vertical: 1.h),
                               child:  SingleChildScrollView(
                                physics: ScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.wallet_travel,color: Colors.grey,),
                                        SizedBox(width: 2.w,),
                                        RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(text: 'Worked at ', style: TextStyle(fontSize: 10.sp,
                                                  color: Colors.black)),
                                              TextSpan(text: 'Bharat Arpanet PVT LTD.',
                                                style: TextStyle(color: Colors.black,
                                                    fontSize: 10.sp,fontWeight: FontWeight.bold),),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 1.h,),
                                    Row(
                                      children: [
                                        Icon(Icons.list_alt_outlined,color: Colors.grey,),
                                        SizedBox(width: 2.w,),
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              children: <TextSpan>[
                                                TextSpan(text: 'Specialization in ', style: TextStyle(fontSize: 10.sp,
                                                    color: Colors.black)),
                                                TextSpan(text: '${instructorDetails.specialization}',
                                                  style: TextStyle(color: Colors.black,
                                                      fontSize: 10.sp,fontWeight: FontWeight.bold),),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 1.h,),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on_outlined,color: Colors.grey,),
                                        SizedBox(width: 2.w,),
                                        Expanded(child: RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(text: 'Lives in ', style: TextStyle(fontSize: 10.sp,
                                                  color: Colors.black)),
                                              TextSpan(text: '${instructorDetails.address}, ${instructorDetails.city}, ${instructorDetails.state}, ${instructorDetails.country}',
                                                style: TextStyle(color: Colors.black,
                                                    fontSize: 10.sp,fontWeight: FontWeight.bold),),
                                            ],
                                          ),
                                        ),)
                                      ],
                                    ),
                                    SizedBox(height: 1.h,),
                                    Row(
                                      children: [
                                        Icon(Icons.history_edu,color: Colors.grey,),
                                        SizedBox(width: 2.w,),
                                        RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(text: 'Bvidya Educator since ', style: TextStyle(fontSize: 10.sp,
                                                  color: Colors.black)),
                                              TextSpan(text: '22nd March, 2022.',
                                                style: TextStyle(color: Colors.black,
                                                    fontSize: 10.sp,fontWeight: FontWeight.bold),),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 1.h,),
                                    Row(
                                      children: [
                                        Icon(Icons.language,color: Colors.grey,),
                                        SizedBox(width: 2.w,),
                                        RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(text: 'known ', style: TextStyle(fontSize: 10.sp,
                                                  color: Colors.black)),
                                              TextSpan(text: 'Hinglish, Hindi and English.',
                                                style: TextStyle(color: Colors.black,
                                                    fontSize: 10.sp,fontWeight: FontWeight.bold),),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 2.h,),
                                    Text("Similar Instructors",
                                      style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15.sp),),
                                    SizedBox(height: 1.h,),
                                    SizedBox(height: 14.h,
                                      child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context,i){
                                            return Container(
                                              width: 60.w,
                                              padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 1.h),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(15)
                                              ),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(10),
                                                    child: Image.asset(
                                                      'assets/images/teacher.PNG',
                                                      height: 12.h,
                                                      width: 20.w,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  SizedBox(width: 3.w,),
                                                  Expanded(child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Piyush Kanwal",
                                                          maxLines: 1,
                                                          style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15.sp)),
                                                      Text("Graphics Designer",
                                                        style: TextStyle(fontSize: 10.sp,
                                                            color: Colors.black),),
                                                      Text("2+ year experience",
                                                        style: TextStyle(fontSize: 9.sp,
                                                            color: Colors.black),),
                                                      Spacer(),
                                                      Row(

                                                        children: [
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text("35M+",
                                                                style: TextStyle(fontSize: 9.sp,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold),),
                                                              Text("followers",
                                                                style: TextStyle(fontSize: 7.sp,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                          SizedBox(width: 4.w,),
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text("345M+",
                                                                style: TextStyle(fontSize: 9.sp,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold),),
                                                              Text("watch min",
                                                                style: TextStyle(fontSize: 7.sp,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold),),
                                                            ],
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),)

                                                ],
                                              ),
                                            );
                                          },
                                          separatorBuilder: (_,__)=>SizedBox(width: 1.h,),
                                          itemCount: 8),
                                    ),
                                    SizedBox(height: 2.h,),
                                    Text("Reviews",
                                      style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15.sp),),
                                    SizedBox(height: 1.h,),
                                    SizedBox(height: 20.h,
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
                                                  SizedBox(height: 1.h,),
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
                                                    style: TextStyle(fontSize: 10.sp,
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
                              ),
                            )
                          )
                              : Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3.h,vertical: 1.h),
                                child:  CustomScrollView(
                                  slivers: [
                                    SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                            (BuildContext context, int index) {
                                          return Container(
                                             width: double.infinity,
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
                                                            loader == false
                                                                ?
                                                            Image.network(
                                                              StringConstant.IMAGE_URL+ "users/default.png",
                                                              height: 7.h,
                                                              width: 15.w,
                                                              fit: BoxFit.cover,
                                                            )
                                                                : Image.network(
                                                              StringConstant.IMAGE_URL+ courses[index].image,
                                                              height: 7.h,
                                                              width: 15.w,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 10,),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              loader == false
                                                                  ? SizedBox(height: 20,width: 20,
                                                                child: CircularProgressIndicator(),)
                                                                  : Text("${courses[index].name}",
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(fontSize: 14.sp),),
                                                              loader == false
                                                                  ? Text("Loading...")
                                                                  : Row(
                                                                children: [
                                                                  RatingBarIndicator(
                                                                    rating: double.parse(courses[index].rating),
                                                                    itemBuilder: (context, index) => const Icon(
                                                                      Icons.star,
                                                                      color: Colors.amber,
                                                                    ),
                                                                    itemCount: 5,
                                                                    itemSize: 15.0,
                                                                    direction: Axis.horizontal,
                                                                  ),
                                                                  SizedBox(width: 10,),
                                                                  Text("${courses[index].ratingCount} Ratings",style: TextStyle(fontSize: 8.sp,
                                                                      color: Colors.grey,fontWeight: FontWeight.w500),)
                                                                ],
                                                              ),
                                                              loader == false ? Text("")
                                                                  : Row(
                                                                children: [
                                                                  Text("${courses[index].duration} hr",style: TextStyle(fontSize: 8.sp,
                                                                      color: Colors.grey,fontWeight: FontWeight.bold),),
                                                                  SizedBox(width: 2.w,),
                                                                  Icon(Icons.circle,size: 5,color: Colors.grey,),
                                                                  SizedBox(width: 2.w,),
                                                                  Text("${courses[index].views} views",style: TextStyle(fontSize: 8.sp,
                                                                      color: Colors.grey,fontWeight: FontWeight.bold),)
                                                                ],
                                                              )



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
                                                      child:Icon(Icons.play_arrow_sharp,
                                                          color: Colors.white,
                                                          size:15
                                                      ),
                                                    ),
                                                    onTap: (){
                                                      Navigator.push(context,MaterialPageRoute(builder: (context) => Lesson(
                                                          catList:courses[index].id,
                                                          catImage:courses[index].image,
                                                          catName:courses[index].name,
                                                          catDescription:courses[index].description,
                                                          duration:courses[index].duration,
                                                          instructorName:instructorDetails.name,
                                                          instructorImage:instructorDetails.image,
                                                          language:courses[index].language,
                                                          level:courses[index].level)));
                                                    },
                                                  )
                                                ],
                                              )
                                          );
                                        },
                                        childCount: loader == false ? 3: courses.length > 3 ? 3 :courses.length,
                                      ),
                                    ),
                                    SliverToBoxAdapter(
                                        child: InkWell(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 0.h),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text("View More",
                                                style: TextStyle(fontWeight: FontWeight.bold,
                                                    color: AppColors.appNewDarkThemeColor,
                                                    fontSize: 10.sp),),
                                            ),
                                          ),
                                          onTap: (){
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (context)=>TeacherCoursesListPage(
                                                )));
                                          },
                                        )
                                    ),
                                    SliverToBoxAdapter(
                                      child: SizedBox(height: 1.h,),
                                    ),
                                    SliverToBoxAdapter(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("Most Viewed Courses",
                                          style: TextStyle(fontWeight: FontWeight.bold,
                                              fontSize: 2.3.h),),
                                      ),
                                    ),
                                    SliverToBoxAdapter(
                                      child: SizedBox(height: 1.h,),
                                    ),
                                    SliverToBoxAdapter(
                                      child: SizedBox(height: 28.h,
                                      child: loader == false
                                          ? Center(
                                        child:Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(height: 20,width: 20,
                                              child: CircularProgressIndicator(strokeWidth: 2,),
                                            ),
                                            Text("   Loading...",style: TextStyle(fontSize: 13.sp,
                                                fontWeight: FontWeight.bold),)
                                          ],
                                        ),
                                      )
                                          : Center(
                                             child: liked.isEmpty
                                            ? Text("No Any Videos Liked",
                                              style: TextStyle(fontSize: 18.sp,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold),)
                                            : Center(
                                                child:ListView.separated(
                                            shrinkWrap: true,
                                            separatorBuilder: (_,__)=>SizedBox(width: 10,),
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                width: 50.w,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    color: Colors.white
                                                ),
                                                child: Wrap(children: [
                                                  GestureDetector(
                                                      onTap: () {

                                                        // Navigator.push(
                                                        //     context,
                                                        //     MaterialPageRoute(
                                                        //         builder: (context) =>
                                                        //             VideoDetail()));
                                                      },
                                                      child: Container(
                                                        height: 38.h,
                                                        child: Stack(
                                                          children: <Widget>[
                                                            ClipRRect(
                                                                borderRadius: BorderRadius.only(topRight: Radius.circular(20),
                                                                    topLeft: Radius.circular(20)),
                                                                child: CachedNetworkImage(
                                                                  height: 15.h,
                                                                  fit: BoxFit.cover,
                                                                  width: 50.w,
                                                                  imageUrl:StringConstant.IMAGE_URL+ "${liked[index].image}",
                                                                  placeholder: (context, url) =>
                                                                      Helper.onScreenProgress(),
                                                                  errorWidget: (context, url, error) =>
                                                                  new Icon(Icons.error),
                                                                )),
                                                            Positioned(
                                                              top: 15.h,
                                                              child: Container(
                                                                width: 50.w,
                                                                padding:EdgeInsets.all(10),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    loader == false
                                                                        ? SizedBox(height: 20,width: 20,
                                                                      child: CircularProgressIndicator(),)
                                                                        : Text("${liked[index].name}",
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      style: TextStyle(fontSize: 14.sp),),
                                                                    loader == false
                                                                        ? SizedBox(height: 20,width: 20,
                                                                      child: CircularProgressIndicator(),)
                                                                        : Text("${liked[index].description}",
                                                                      maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      style: TextStyle(fontSize: 10.sp),),
                                                                    loader == false
                                                                        ? Text("Loading...")
                                                                        : Row(
                                                                      children: [
                                                                        RatingBarIndicator(
                                                                          rating: double.parse(liked[index].rating),
                                                                          itemBuilder: (context, index) => const Icon(
                                                                            Icons.star,
                                                                            color: Colors.amber,
                                                                          ),
                                                                          itemCount: 5,
                                                                          itemSize: 15.0,
                                                                          direction: Axis.horizontal,
                                                                        ),
                                                                        SizedBox(width: 10,),
                                                                        Text("${liked[index].ratingCount} Ratings",style: TextStyle(fontSize: 8.sp,
                                                                            color: Colors.grey,fontWeight: FontWeight.w500),)
                                                                      ],
                                                                    ),
                                                                    loader == false ? Text("")
                                                                        : Row(
                                                                      children: [
                                                                        Text("${liked[index].duration} hr",style: TextStyle(fontSize: 8.sp,
                                                                            color: Colors.grey,fontWeight: FontWeight.bold),),
                                                                        SizedBox(width: 2.w,),
                                                                        Icon(Icons.circle,size: 5,color: Colors.grey,),
                                                                        SizedBox(width: 2.w,),
                                                                        Text("${liked[index].views} views",style: TextStyle(fontSize: 8.sp,
                                                                            color: Colors.grey,fontWeight: FontWeight.bold),)
                                                                      ],
                                                                    )



                                                                  ],
                                                                ),
                                                              ),
                                                            )


                                                          ],
                                                        ),
                                                      )
                                                  ),
                                                ]),
                                              );
                                            },
                                            itemCount: loader == false ? 3:liked.length,
                                          ),
                                          ),
                                        ),
                                      )
                                    )
                                  ],
                                ),
                              )
                          ),


                        ],
                      ),
                    ),
                  ],
                ),
              )
          ),
        )
    );
  }

  void allMentorDetails() {
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
                ApiRepository().getInstructorProfile(value,widget.id).then((value) {
                  if (value != null) {
                    setState(() {
                      instructorDetails = value.body.profile;
                      courses = value.body.courses;
                      watchTime = value.body.watchtime;
                      meetings = value.body.meetings;
                      webinars = value.body.webinar;
                      liked = value.body.liked;
                      followers = value.body.followers;
                      loader = true;
                      print("hello $instructorDetails");
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
  void followInstructor(var instructorID) {
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
                ApiRepository().followInstructor(value,instructorID.toString()).then((value) {
                  if (value.status == "successfully") {
                    print("Success $value");
                    setState(() {
                      EasyLoading.showToast("You follow this instructor.",
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
