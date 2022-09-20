import 'package:cached_network_image/cached_network_image.dart';
import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/lms/lession.dart';
import 'package:evidya/network/repository/api_repository.dart';
import 'package:evidya/resources/app_colors.dart';
import 'package:evidya/screens/user/teacher_courses_list_page.dart';
import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:evidya/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
class ViewInstructorProfile extends StatefulWidget {
  final String token;
  final String id;
  const ViewInstructorProfile({this.token,this.id,Key key}) : super(key: key);

  @override
  State<ViewInstructorProfile> createState() => _ViewInstructorProfileState();
}

class _ViewInstructorProfileState extends State<ViewInstructorProfile> {
  bool loader = false;
  List courses;
  List followers;
  List watchTime;
  List meetings;
  List webinars;
  List liked;
  var profile;
  String choice = "details";
  @override
  void initState() {
    // TODO: implement initState
    instructorProfile(widget.id);
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
      child:  SafeArea(
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
                              loader == true
                                  ? Text("${profile.name}",style:
                              TextStyle(color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: .5,
                                  fontSize: 17.sp),)
                                  : SizedBox(height: 20,width: 20,
                                     child: CircularProgressIndicator(strokeWidth: 2,),
                              ),
                              loader == true?Text("${profile.email}",style:
                              TextStyle(color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: .5,
                                  fontSize: 13.sp))
                              :Text(""),
                              loader == true
                                  ? Text("(${profile.experience} years of experience)",
                                style: TextStyle(color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: .5,
                                    fontSize: 9.sp),)
                                  : Text(""),

                              SizedBox(height: 2.h,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                  height: 10.h,
                                  width: 21.w,
                                  //margin: EdgeInsets.only(bottom: 5,right: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(width: 1,color: Colors.transparent),
                                    color: Colors.transparent,),
                                  child:
                                  loader == true?
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.fill,
                                      width: 21.w,
                                      height:10.h,
                                      imageUrl: StringConstant.IMAGE_URL + profile.image,
                                      placeholder: (context, url) =>
                                          Helper.onScreenProgress(),
                                      errorWidget: (context, url, error) =>
                                      new Icon(Icons.error),
                                    )
                                    // Image.network(
                                    //   ,
                                    //   height: 10.h,
                                    //   width: 21.w,
                                    //   fit: BoxFit.fill,
                                    // ),
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
                    height: 60.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/grey_background.jpg",),
                          fit: BoxFit.cover
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight:Radius.circular(20),
                              ),
                              color: Colors.white
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                child: Column(
                                  children: [
                                    SizedBox(height: 1.5.h,),
                                    Text("Details",style: TextStyle(fontSize: 13.sp,
                                        fontWeight: FontWeight.w600),),
                                    SizedBox(height: 1.5.h,),
                                    Container(
                                      height: 2,
                                      width: 47.w,
                                      color: choice =="details"?
                                      AppColors.appNewDarkThemeColor
                                          :Colors.white,)
                                  ],
                                ),
                                onTap: (){
                                  setState(() {
                                    choice ="details";
                                  });
                                },
                              ),
                              InkWell(
                                child:  Column(
                                  children: [
                                    SizedBox(height: 1.5.h,),
                                    Text("Statistics",style: TextStyle(fontSize: 13.sp,
                                        fontWeight: FontWeight.w600)),
                                    SizedBox(height: 1.5.h,),
                                    Container(
                                        height: 2,
                                        width: 47.w,
                                        color: choice =="statistics"?
                                        AppColors.appNewDarkThemeColor
                                            :Colors.white)
                                  ],
                                ),
                                onTap: (){
                                  setState(() {
                                    choice ="statistics";
                                  });
                                },
                              )

                            ],
                          ),
                        ),
                        choice == "details"
                            ? Expanded(
                            flex: 1,
                            child: CustomScrollView(
                              slivers: [
                                SliverToBoxAdapter(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 3.h,vertical: 1.h),
                                      child: Column(
                                        children: [
                                          SizedBox(height: 1.h,),
                                          Row(
                                            children: [
                                              Text("Specification:",
                                                style: TextStyle(fontSize: 13.sp,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold),),
                                              Expanded(child: Divider(height: 2,
                                                thickness: 1,
                                                color: AppColors.appNewDarkThemeColor,indent: 10,))
                                            ],
                                          ),
                                          SizedBox(height: 1.h,),
                                          loader == false
                                          ? Text("Loading....",
                                            style: TextStyle(fontSize: 12.sp,
                                                fontWeight: FontWeight.bold),)
                                          : Text("${profile.specialization}",
                                            style: TextStyle(fontSize: 12.sp,
                                              fontWeight: FontWeight.bold),)
                                        ],
                                      ),
                                    )
                                ),
                                SliverToBoxAdapter(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 3.h,vertical: 1.h),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text("Courses",
                                                style: TextStyle(fontSize: 13.sp,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold),),
                                              Expanded(child: Divider(height: 2,
                                                thickness: 1,
                                                color: AppColors.appNewDarkThemeColor,indent: 10,))
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                ),
                                loader == false
                                    ? SliverToBoxAdapter(
                                    child: Center(
                                      child: Row(
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
                                )
                                  : courses.isEmpty
                                    ? SliverToBoxAdapter(
                                     child: Center(
                                       child:
                                        Text("No Courses Uploaded !",style: TextStyle(fontSize: 13.sp,
                                            fontWeight: FontWeight.bold),)
                                      )
                                    )
                                  : SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                      return Container(
                                          margin: EdgeInsets.symmetric(horizontal: 3.h,vertical: 1.h),
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
                                                            fit: BoxFit.fill,
                                                          )
                                                        : Image.network(
                                                                  StringConstant.IMAGE_URL+ courses[index].image,
                                                                  height: 7.h,
                                                                  width: 15.w,
                                                                  fit: BoxFit.fill,
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
                                                      instructorName:profile.name,
                                                      instructorImage:profile.image,
                                                      language:courses[index].language,
                                                      level:courses[index].level)));
                                                },
                                              )
                                            ],
                                          )
                                      );
                                    },
                                    childCount:  courses.length,
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: InkWell(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 3.h,vertical: 1.h),
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
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 3.h,vertical: 1.h),
                                          child: Row(
                                            children: [
                                              Text("Upcoming Meetings",
                                                style: TextStyle(fontSize: 13.sp,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold),),
                                              Expanded(child: Divider(height: 2,
                                                thickness: 1,
                                                color: AppColors.appNewDarkThemeColor,indent: 10,))
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 11.h,
                                          // padding: EdgeInsets.all(1.h),
                                          child: loader == false
                                              ? Center(
                                            child: Row(
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
                                            child: meetings.isEmpty
                                                ? Text("No Upcoming Meetings",
                                              style: TextStyle(fontSize: 18.sp,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold),)
                                               : ListView.separated(
                                                scrollDirection: Axis.horizontal,
                                                itemBuilder:(context,index){
                                                  return Wrap(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {},
                                                        child: Container(
                                                            width:50.w,
                                                            padding: const EdgeInsets.only(top: 15,bottom: 15,),
                                                            margin:EdgeInsets.symmetric(horizontal: 2.h,vertical: 1.h),
                                                            decoration:  BoxDecoration(
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      blurRadius: 10,
                                                                      offset: Offset(-1,1),
                                                                      color: Colors.grey.shade400
                                                                  ),
                                                                ],
                                                                borderRadius: BorderRadius.circular(15),
                                                                color: Colors.white
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Container(
                                                                  alignment: Alignment.center,
                                                                  height: 4.h,width: 3,
                                                                  decoration: BoxDecoration(
                                                                      color: const Color(0xFFf02b25),
                                                                      borderRadius: BorderRadius.circular(10)
                                                                  ),
                                                                ),
                                                                SizedBox(width: 20,),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children:  [
                                                                      Text("${meetings[index].name}",
                                                                        style: TextStyle(fontSize: 12.sp,
                                                                            color: Colors.black,
                                                                            letterSpacing: .5,
                                                                            fontWeight: FontWeight.w600),),
                                                                      Text(DateFormat.yMMMd().format(DateTime.parse(meetings[index].startsAt))
                                                                          +", "+
                                                                          DateFormat.jm().format(DateTime.parse(meetings[index].startsAt)),
                                                                          //+" - " + DateFormat.jm().format(DateTime.parse(post.endsAt.toString())),
                                                                          style: TextStyle(fontSize: 10.sp,
                                                                              color: Colors.grey,
                                                                              letterSpacing: .5,
                                                                              fontWeight: FontWeight.w500)
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                                separatorBuilder: (_,__)=>SizedBox(width: 1.h,),
                                                itemCount: meetings.length),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 3.h,vertical: 1.h),
                                          child: Row(
                                            children: [
                                              Text("Upcoming webinars",
                                                style: TextStyle(fontSize: 13.sp,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold),),
                                              Expanded(child: Divider(height: 2,
                                                thickness: 1,
                                                color: AppColors.appNewDarkThemeColor,indent: 10,))
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 18.h,
                                          child: loader == false
                                              ? Center(
                                            child: Row(
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
                                               child: webinars.isEmpty
                                                  ? Text("No Upcoming Webinars",
                                              style: TextStyle(fontSize: 18.sp,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold),)
                                                : ListView.separated(
                                                scrollDirection: Axis.horizontal,
                                                itemBuilder:(context,index){
                                                  return Wrap(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {},
                                                        child: Container(
                                                            width:40.w,
                                                            margin:EdgeInsets.symmetric(horizontal: 2.h,vertical: 1.h),
                                                            decoration:  BoxDecoration(
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      blurRadius: 10,
                                                                      offset: Offset(-1,1),
                                                                      color: Colors.grey.shade400
                                                                  ),
                                                                ],
                                                                borderRadius: BorderRadius.circular(15),
                                                                color: Colors.white
                                                            ),
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  alignment: Alignment.center,
                                                                  height: 8.h,width: double.infinity,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors.black12,
                                                                      borderRadius: BorderRadius.only(topRight: Radius.circular(15),
                                                                          topLeft: Radius.circular(15))
                                                                  ),
                                                                  child: ClipRRect(
                                                                   borderRadius: BorderRadius.only(topRight: Radius.circular(15),
                                                                   topLeft: Radius.circular(15)),
                                                                    child: Image.network( StringConstant.IMAGE_URL +"${webinars[index].image}",
                                                                      fit: BoxFit.fill,
                                                                      height: 8.h,width: double.infinity,
                                                                    ),
                                                                  )
                                                                ),
                                                                Container(
                                                                  height:8.h,
                                                                  padding:EdgeInsets.all(1.h),
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children:  [
                                                                      Text("${webinars[index].name}",
                                                                        maxLines:1,
                                                                        style: TextStyle(fontSize: 11.sp,
                                                                            color: Colors.black,
                                                                            fontWeight: FontWeight.bold),),
                                                                      Text(DateFormat.yMMMd().format(DateTime.parse(webinars[index].startsAt))
                                                                          +", "+
                                                                          DateFormat.jm().format(DateTime.parse(webinars[index].startsAt)),
                                                                          //+" - " + DateFormat.jm().format(DateTime.parse(post.endsAt.toString())),
                                                                          style: TextStyle(fontSize: 10.sp,
                                                                              color: Colors.grey,
                                                                              letterSpacing: .5,
                                                                              fontWeight: FontWeight.w500)
                                                                      )
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                                separatorBuilder: (_,__)=>SizedBox(width: 0.h,),
                                                itemCount: webinars.length),
                                          ),
                                        ),
                                        SizedBox(height: 1.h,),
                                      ],
                                    ),
                                ),
                                SliverToBoxAdapter(
                                  child: Column(
                                    children: [
                                     Padding(
                                       padding: EdgeInsets.symmetric(horizontal: 3.h,vertical: 1.h),
                                       child:  Row(
                                         children: [
                                           Text("Most Viewed Courses",
                                             style: TextStyle(fontSize: 13.sp,
                                                 color: Colors.black,
                                                 fontWeight: FontWeight.bold),),
                                           Expanded(child: Divider(height: 2,
                                             thickness: 1,
                                             color: AppColors.appNewDarkThemeColor,indent: 10,))
                                         ],
                                       ),
                                     ),
                                      Container(
                                        height: 26.h,
                                        // padding: EdgeInsets.all(1.h),
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
                                              :Center(
                                                child: ListView.separated(
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder:(context,index){
                                                return Wrap(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {},
                                                      child: Container(
                                                          width:40.w,
                                                          //padding: const EdgeInsets.only(top: 15,bottom: 15,left: 0,right: 20),
                                                          margin:EdgeInsets.symmetric(horizontal: 2.h,vertical: 1.h),
                                                          decoration:  BoxDecoration(
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    blurRadius: 10,
                                                                    offset: Offset(-1,1),
                                                                    color: Colors.grey.shade400
                                                                ),
                                                              ],
                                                              borderRadius: BorderRadius.circular(15),
                                                              color: Colors.white
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                alignment: Alignment.center,
                                                                height: 12.h,width: double.infinity,
                                                                decoration: BoxDecoration(
                                                                    color: Colors.black12,
                                                                    borderRadius: BorderRadius.only(topRight: Radius.circular(15),
                                                                        topLeft: Radius.circular(15))
                                                                ),
                                                                child: ClipRRect(
                                                                  borderRadius: BorderRadius.only(topRight: Radius.circular(15),
                                                                      topLeft: Radius.circular(15)),
                                                                  child: Image.network( StringConstant.IMAGE_URL +"${liked[index].image}",
                                                                    fit: BoxFit.fill,
                                                                    height: 12.h,width: double.infinity,
                                                                  ),
                                                                )
                                                              ),
                                                              Container(
                                                                height:11.h,
                                                                padding:EdgeInsets.all(1.h),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children:  [
                                                                    Text("${liked[index].name}",
                                                                      style: TextStyle(fontSize: 12.sp,
                                                                          color: Colors.black,
                                                                          letterSpacing: .5,
                                                                          fontWeight: FontWeight.w600),),

                                                                    Text("Timing: ${liked[index].duration} hr",
                                                                      style: TextStyle(fontSize: 10.sp,
                                                                          color: Colors.black,
                                                                          letterSpacing: .5,
                                                                          fontWeight: FontWeight.w600),),
                                                                    Row(
                                                                      children: [
                                                                        Text("${liked[index].rating}",
                                                                          style: TextStyle(color: Colors.amber,fontWeight: FontWeight.bold),),
                                                                        RatingBarIndicator(
                                                                          rating: double.parse(liked[index].rating),
                                                                          itemBuilder: (context, index) => const Icon(
                                                                            Icons.star,
                                                                            color: Colors.amber,
                                                                          ),
                                                                          itemCount: int.parse(liked[index].rating),
                                                                          itemSize: 15.0,
                                                                          direction: Axis.horizontal,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                      children: [
                                                                        Text("[${liked[index].ratingCount}]",
                                                                          style: TextStyle(color: Colors.black26,
                                                                              fontSize: 9.sp,
                                                                              fontWeight: FontWeight.bold),),
                                                                      ],
                                                                    )

                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          )
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                              separatorBuilder: (_,__)=>SizedBox(width: 0.h,),
                                              itemCount: liked.length),
                                        ),
                                      ),
                                      ),
                                      SizedBox(height: 2.h,),
                                    ],
                                  ),
                                )

                              ],
                            ),
                        )
                            : Expanded(
                               child: Padding(
                                 padding: EdgeInsets.symmetric(horizontal: 2.h),
                                 child: SingleChildScrollView(
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     children: [
                                       SizedBox(height: 1.h,),
                                       Card(
                                           color: Colors.red.shade300,
                                           shape: RoundedRectangleBorder(
                                               borderRadius: BorderRadius.circular(10)
                                           ),
                                           child:  Padding(
                                             padding: EdgeInsets.all(10),
                                             child: Column(
                                               children: [
                                                 Text("Course Subscribers: ",style: TextStyle(
                                                     fontSize: 13.sp,
                                                     fontWeight: FontWeight.bold,
                                                     color: Colors.white
                                                 ),),
                                                 SizedBox(height: 1.h,),
                                                 Align(
                                                   alignment: Alignment.center,
                                                   child: Column(
                                                     children: [
                                                       Text("1000",
                                                         style: TextStyle(
                                                             fontSize: 25.sp,
                                                             fontWeight: FontWeight.bold,
                                                             color: AppColors.appNewDarkThemeColor
                                                         ),),
                                                       Text("Subscribers",style: TextStyle(color: Colors.white,
                                                           fontSize: 8.sp),),
                                                     ],
                                                   ),
                                                 ),
                                               ],
                                             ),
                                           )
                                       ),
                                       SizedBox(height: 1.h,),
                                       Card(
                                           color: Colors.red.shade300,
                                           shape: RoundedRectangleBorder(
                                               borderRadius: BorderRadius.circular(10)
                                           ),
                                           child:  Padding(
                                             padding: EdgeInsets.all(10),
                                             child: Column(
                                               children: [
                                                 Text("No of views:",
                                                   style: TextStyle(
                                                       fontSize: 13.sp,
                                                       fontWeight: FontWeight.bold,
                                                       color: Colors.white
                                                   ),),
                                                 SizedBox(height: 1.h,),
                                                 Align(
                                                   alignment: Alignment.center,
                                                   child: Column(
                                                     children: [
                                                       Text("98765432",
                                                         style: TextStyle(
                                                             fontSize: 30.sp,
                                                             fontWeight: FontWeight.bold,
                                                             color: AppColors.appNewDarkThemeColor
                                                         ),),
                                                       Text("views",style: TextStyle(color: Colors.white,fontSize: 8.sp),),
                                                     ],
                                                   ),
                                                 ),
                                               ],
                                             ),
                                           )
                                       ),

                                       SizedBox(height: 1.h,),
                                       Card(
                                           color: Colors.red.shade300,
                                           shape: RoundedRectangleBorder(
                                               borderRadius: BorderRadius.circular(10)
                                           ),
                                           child:  Padding(
                                             padding: EdgeInsets.all(10),
                                             child: Column(
                                               children: [
                                                 Text("Watch time:",
                                                   style: TextStyle(
                                                       fontSize: 13.sp,
                                                       fontWeight: FontWeight.bold,
                                                       color: Colors.white
                                                   ),),
                                                 SizedBox(height: 1.h,),
                                                 Align(
                                                   alignment: Alignment.center,
                                                   child: Column(
                                                     children: [
                                                       Text("12345765",
                                                         style: TextStyle(
                                                             fontSize: 30.sp,
                                                             fontWeight: FontWeight.bold,
                                                             color: AppColors.appNewDarkThemeColor
                                                         ),),
                                                       Text("minutes",
                                                         style: TextStyle(color: Colors.white,fontSize: 8.sp),),
                                                     ],
                                                   ),
                                                 ),
                                               ],
                                             ),
                                           )
                                       ),

                                       SizedBox(height: 1.h,),
                                     ],
                                   ),
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
  void instructorProfile(var id) {
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
                ApiRepository().getInstructorProfile(value,id.toString()).then((value) {
                  if (value.status == "successfull") {
                     print("Hello I am here ${value.body}");
                     setState(() {
                       loader = true;
                       courses = value.body.courses;
                       profile = value.body.profile;
                       watchTime = value.body.watchtime;
                       meetings = value.body.meetings;
                       webinars = value.body.webinar;
                       liked = value.body.liked;
                       followers = value.body.followers;
                     });
                     PreferenceConnector().setProfileImage(profile.image);
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
