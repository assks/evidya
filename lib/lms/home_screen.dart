import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:evidya/lms/all_mentor_list.dart';
import 'package:evidya/lms/banner_details.dart';
import 'package:evidya/lms/cources/my_learning.dart';
import 'package:evidya/lms/cources/sub_category.dart';
import 'package:evidya/lms/lession.dart';
import 'package:evidya/lms/lms_live_class.page.dart';
import 'package:evidya/lms/lms_search_page.dart';
import 'package:evidya/lms/mentor_detail_page.dart';
import 'package:evidya/lms/video/bloc/HomeState.dart';
import 'package:evidya/lms/video/bloc/homeBloc.dart';
import 'package:evidya/lms/video/bloc/homeEvent.dart';
import 'package:evidya/lms/video/mentorvideolist.dart';
import 'package:evidya/lms/video/videolist_screen.dart';
import 'package:evidya/lms/videodetail_screen.dart';
import 'package:evidya/model/login/PrefranceData.dart';
import 'package:evidya/resources/app_colors.dart';
import 'package:evidya/screens/user/teacher_courses_list_page.dart';
import 'package:evidya/screens/user/teacherdetail_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'package:simple_tags/simple_tags.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:evidya/constants/page_route_constants.dart';
import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/model/home.dart';
import 'package:evidya/model/login_res.dart';
import 'package:evidya/model/profile.dart';
import 'package:evidya/network/repository/api_repository.dart';

import 'package:evidya/screens/welcome_screen/welcome_screen.dart';
import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:evidya/utils/SizeConfigs.dart';
import 'package:evidya/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:custom_progress_dialog/custom_progress_dialog.dart';
import 'package:flutter/services.dart';
import '../../main.dart';

import 'package:video_player/video_player.dart';
import 'cources/category.dart';
class HomeScreen extends StatefulWidget {

  const HomeScreen({Key key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  Map loginJson;
  LoginData userData;
  Map profileJson;
  Data profileData;
  String profileUrl = "";
  var name,instructorId;
  bool notification = true;
  String role, image1;
  int unreadNotificationCount = 0;
  String firstName = "";
  var token = "";
  List courseList;
  var imageurl = "";
  int mainindex = 0;
  bool loader = false,loader1 = false;
  var names, email, phoneno;
  ProgressDialog _progressDialog = ProgressDialog();
  List images;
  List topCategories;
  List featuredCategory;
  List topCourses;
  List popularInstructor;
  List popularCourses;
  List liveClass;
  List imageList = [];
  String check = '';
  HomeBloc _homebloc;
  String image = "";
 // String? bloc;

  String feature = 'All';
  final List<String> content = [
    'Prograhrg',
    'Design',
    'Marketing',
    'Business',
    'Video Editing',
    'Arts',
    'Foreign Language',
  ];
  final List<String> featured = [
    'All',
    'Trending',
    'Most Viewed',
    'Popular',
    'Most Liked',
  ];

  _getVideoBackground() {
    VideoPlayer(_controller);
  }

  // get Initial => InitialLoader;
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    sharePreferenceData();
    _FetchData();
    _homebloc=HomeBloc(HomeState(false));
    _controller = VideoPlayerController.network('https://bvidya.websites4demo.com/temporary/video/Bvidya-Video.mp4')
      ..initialize().then((_) {
        setState(() {

        });
      });
  }

  void sharePreferenceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    image1 = prefs.getString('profileImage');
    role = prefs.getString('role')??"user";
    print("Image $image1 Role $role");
    await PreferenceConnector.getJsonToSharedPreferencetoken(StringConstant.Userdata)
        .then((value) => {
      if (value != null)
        {
          userdata = jsonDecode(value.toString()),
          setState(() {
            localdata = PrefranceData.fromJson(userdata);
            name = localdata.name;
            email = localdata.email;
            var Role = localdata.role;
            instructorId = localdata.id;
            token = userdata['auth_token'];
            print("UserToken $token Roles $instructorId");
            instructorCourses(instructorId);
          }),
        }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller != null) {
      _controller.dispose();
      _controller = null;
    }
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
      child:SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            height: 100.h,
            margin: EdgeInsets.only(top: 1.h,left: 1.h,right: 1.h),
            padding: EdgeInsets.only(top: 2.h,left: 2.h,right: 2.h),
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/whitebg.png",),
                  fit: BoxFit.cover
              ),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),
                  topRight: Radius.circular(20)),
            ),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 1.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:  [
                            RichText(
                              text: TextSpan(
                                text: 'b',
                                style: TextStyle(fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    fontSize: 18.sp),
                                children: <TextSpan>[
                                  TextSpan(text: 'Learn', style: TextStyle(fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 18.sp),),
                                ],
                              ),
                            ),
                            InkWell(
                                 child: Container(
                                     padding: EdgeInsets.all(5),
                                     decoration: BoxDecoration(
                                         borderRadius: BorderRadius.circular(10),
                                         gradient: LinearGradient(
                                           begin: Alignment.topCenter,
                                           end: Alignment.bottomCenter,
                                           colors: [
                                             AppColors.addedColor,
                                             AppColors.addedColor,
                                           ],
                                         )
                                     ),
                                     child: Icon(Icons.search,
                                       color: AppColors.appNewLightThemeColor,
                                       size: 3.h,)
                                 ),
                                 onTap: (){
                                   Navigator.push(context,
                                       MaterialPageRoute(builder: (context)=>LMSSearchPage()));
                                 },
                             )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(1.h),
                        child: CarouselSlider.builder(
                          itemCount: loader == false
                              ? 3
                              : imageList.length,
                          options: CarouselOptions(
                            enlargeCenterPage: true,
                            height: 17.h,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            reverse: false,
                            aspectRatio: 5.0,
                          ),
                          itemBuilder: (context, i, id){
                            //for onTap to redirect to another screen
                            return GestureDetector(
                              child: Container(
                                width: 100.w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: Colors.white,)
                                ),
                                //ClipRRect for image border radius
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: loader == true
                                      ? Image.network(
                                    imageList[i],
                                    width: 100.w,
                                    fit: BoxFit.cover,
                                  )
                                      : Image.network(
                                    StringConstant.IMAGE_URL + 'users/default.png',
                                    width: 100.w,

                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              onTap: (){
                                var url = imageList[i];
                                print(url.toString());
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            BannerDetails(bannerImage: imageList[i],)));
                              },
                            );
                          },
                        ),
                      ),
                      role == 'user'
                          ? Container()
                          : Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 1.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:  [
                                Text(
                                  "Uploaded Courses",
                                  style: TextStyle(
                                      fontSize: 2.3.h,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => TeacherCoursesListPage(
                                          id: instructorId.toString(),
                                          name: name,
                                          image: image1??"",
                                        )));
                                  },
                                  child: Text(
                                    "See All",
                                    style: TextStyle(color: AppColors.addedColor,
                                        fontSize: 1.5.h
                                    ),
                                  ),

                                ),
                              ],
                            ),
                          ),
                          Container(
                              height: 11.h,
                              padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 1.h),
                              child: loader1 == false
                                  ? ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index){
                                    return InkWell(
                                      child: Container(
                                          width: 70.w,
                                          padding: EdgeInsets.all(1.h),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.grey.shade100,
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
                                                          child: SizedBox(
                                                            height: 20,width: 20,
                                                            child: CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                            ),
                                                          )
                                                      ),
                                                    ),
                                                    SizedBox(width: 10,),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("Loading....",
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(fontSize: 8.sp),),

                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                      onTap: (){

                                      },
                                    );
                                  },
                                   separatorBuilder: (_, __)=>SizedBox(width: 10,),
                                   itemCount:  3)
                                  : courseList.length == 0
                                  ? Center(
                                     child: Text("No Course Uploaded!"),
                                    )
                                  : ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index){
                                    return InkWell(
                                      child: Container(
                                          width: 70.w,
                                          padding: EdgeInsets.all(1.h),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.grey.shade100,
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
                                                            fit: BoxFit.cover,
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
                                                          Text("${courseList[index].name}",
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(fontSize: 2.h),),
                                                          Text("${courseList[index].description}",
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(fontSize: 1.5.h,
                                                                color: Colors.grey),),
                                                          Text("Duration: ${courseList[index].duration} hr",
                                                            style: TextStyle(fontSize: 1.5.h,
                                                              color: Colors.grey,fontWeight: FontWeight.bold),),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                      onTap: (){
                                        Navigator.push(context,MaterialPageRoute(
                                            builder: (context) => Lesson(
                                                catList:courseList[index].id,
                                                catImage:courseList[index].image,
                                                catName:courseList[index].name,
                                                catDescription:courseList[index].description,
                                                duration:courseList[index].duration,
                                                instructorName:name,
                                                instructorImage:image1??"",
                                                language:courseList[index].language,
                                                level:courseList[index].level)));
                                      },
                                    );
                                  },
                                  separatorBuilder: (_, __)=>SizedBox(width: 10,),
                                  itemCount: loader1 == false ? 3: courseList.length)
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 1.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:  [
                            Text(
                              "Categories",
                              style: TextStyle(
                                  fontSize: 2.3.h,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => CategoryScreen()));
                              },
                              child: Text(
                                "See All",
                                style: TextStyle(color: AppColors.addedColor,
                                    fontSize: 1.5.h
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      loader == false
                          ? Wrap(
                        spacing: 6.0,
                        runSpacing: 6.0,
                        children: List<Widget>.generate(3, (int index) {
                          return Chip(
                            backgroundColor: Colors.white,
                            label: Text("Loading...",
                              style: TextStyle(fontSize: 2.h),
                            ),
                          );
                        }),
                      )
                          : Wrap(
                        spacing: 1.5.h,
                        runSpacing: 6.0,
                        children: List<Widget>.generate(featuredCategory.length, (int index) {
                          return InkWell(
                            child: Chip(
                              shape: StadiumBorder(
                                  side: BorderSide(
                                    width: .5,
                                    color: Colors.black,
                                  )),
                              backgroundColor: Colors.white,
                              label: Text("${featuredCategory[index].name}",
                                style: TextStyle(fontSize: 1.8.h),
                              ),
                            ),
                            onTap: (){
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context)=>SubCategory(
                                    catId: featuredCategory[index].id.toString(),
                                    title: featuredCategory[index].name,
                                  )));
                            },
                          );
                        }),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 1.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:  [
                            Text(
                              "Live Classes",
                              style: TextStyle(
                                  fontSize: 2.3.h,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => LMSLiveClass()));
                              },
                              child: Text(
                                "See All",
                                style: TextStyle(color: AppColors.addedColor,
                                    fontSize: 1.5.h
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          height: 28.h,
                          child: liveClasses(),
                      ),
                      SizedBox(height: 1.h,),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:  [
                            Text(
                              "Top Courses",
                              style: TextStyle(
                                  fontSize: 2.3.h,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => VideoList(
                                        title: "Top Courses",
                                        data: topCourses
                                    )));
                              },
                              child: Text(
                                "See All",
                                style: TextStyle(color: AppColors.addedColor,
                                    fontSize: 1.5.h
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int position) {
                      return Container(
                          margin: EdgeInsets.only(top: 0.h,bottom: 1.h),
                          padding: EdgeInsets.all(1.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade100,
                              border: Border.all(width: .5,color: Colors.black54)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
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
                                        child: loader == false
                                            ? Image.network(
                                          StringConstant.IMAGE_URL+ "users/default.png",
                                          height: 7.h,
                                          width: 15.w,
                                          fit: BoxFit.cover,
                                        )
                                            : Image.network(
                                          StringConstant.IMAGE_URL+ topCourses[position].image,
                                          height: 7.h,
                                          width: 15.w,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    loader == false
                                          ? Text("Loading...")
                                          : Expanded(
                                          flex: 1,
                                            child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("${topCourses[position].name}",
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(fontSize: 2.h,
                                                      fontWeight: FontWeight.bold),),
                                                Text(
                                                  "Level : ${topCourses[position].level}",
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      fontSize: 1.5.h, color: Colors.black54),
                                                ),
                                                Text(
                                                  "Language: ${topCourses[position].language}",
                                                  style: TextStyle(fontSize: 1.5.h),
                                                ),
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
                                        AppColors.addedColor,
                                        AppColors.addedColor,
                                      ],
                                    ),
                                  ),
                                  child:Icon(Icons.arrow_forward_ios_sharp,
                                      color: AppColors.appNewDarkThemeColor,
                                      size:2.h
                                  ),
                                ),
                                onTap: (){
                                  Navigator.push(context,MaterialPageRoute(
                                      builder: (context) => Lesson(
                                          catList:topCourses[position].id,
                                          subCatId: topCourses[position].subcategoryId,
                                          catImage : topCourses[position].image,
                                          catName :topCourses[position].name,
                                          catDescription :topCourses[position].description,
                                          duration: topCourses[position].duration,
                                          instructorName: topCourses[position].instructorName,
                                          instructorImage : topCourses[position].instructorImage,
                                          language: topCourses[position].language,
                                          level:topCourses[position].level)));
                                },
                              )
                            ],
                          )
                      );
                    },
                    childCount: loader == false ? 3
                        :topCourses.length > 4 ? 4 : topCourses.length ,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:  [
                            Text(
                              "Learn From The Best",
                              style: TextStyle(
                                  fontSize: 2.3.h,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder:
                                        (context) => AllMentorList()));
                              },
                              child: Text(
                                "See All",
                                style: TextStyle(color: AppColors.addedColor,
                                    fontSize: 1.5.h
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 23.h,
                        child: getMentor(),
                      ),
                      SizedBox(height: 1.h,),
                      // Padding(
                      //   padding: const EdgeInsets.all(10.0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children:  [
                      //       Text(
                      //         "Complete in hours",
                      //         style: TextStyle(
                      //             fontSize: 2.3.h,
                      //             color: Colors.black,
                      //             fontWeight: FontWeight.w600),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
                // SliverList(
                //   delegate: SliverChildBuilderDelegate(
                //         (BuildContext context, int index) {
                //       return Container(
                //           margin: EdgeInsets.only(top: 0.h,bottom: 1.h),
                //           padding: EdgeInsets.all(1.h),
                //           decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(10),
                //               color: Colors.grey.shade100,
                //               border: Border.all(width: .5,color: Colors.black54)
                //           ),
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             children: [
                //               Expanded(
                //                 flex: 1,
                //                 child: Row(
                //                   children: [
                //                     Container(
                //                       height: 7.h,
                //                       width: 15.w,
                //                       decoration: BoxDecoration(
                //                         borderRadius: BorderRadius.circular(10),
                //                         border:Border.all(width: 1,color: Colors.white),
                //                         color:  Colors.white,),
                //                       child: ClipRRect(
                //                         borderRadius: BorderRadius.circular(10),
                //                         child: loader == false
                //                             ? Image.network(
                //                           StringConstant.IMAGE_URL+ "users/default.png",
                //                           height: 7.h,
                //                           width: 15.w,
                //                           fit: BoxFit.fill,
                //                         )
                //                             : Image.network(
                //                           StringConstant.IMAGE_URL+ popularCourses[index].image,
                //                           height: 7.h,
                //                           width: 15.w,
                //                           fit: BoxFit.fill,
                //                         ),
                //                       ),
                //                     ),
                //                     SizedBox(width: 10,),
                //                     Expanded(
                //                       flex: 1,
                //                       child: Column(
                //                         crossAxisAlignment: CrossAxisAlignment.start,
                //                         children: [
                //                           loader == false ? SizedBox(height: 20,width: 20,child: CircularProgressIndicator(strokeWidth: 2,),)
                //                               : Text("${popularCourses[index].duration} hr",style: TextStyle(fontSize: 2.h,
                //                               color: Colors.grey,fontWeight: FontWeight.bold),),
                //                           loader == false ? Text("Loading...")
                //                               :Text("${popularCourses[index].name}",
                //                             maxLines: 1,
                //                             overflow: TextOverflow.ellipsis,
                //                             style: TextStyle(fontSize: 2.5.h),)
                //                         ],
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //               InkWell(
                //                 child: Container(
                //                   padding:EdgeInsets.all(8),
                //                   decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(30),
                //                     gradient: LinearGradient(
                //                       begin: Alignment.topCenter,
                //                       end: Alignment.bottomCenter,
                //                       colors: [
                //                         AppColors.addedColor,
                //                         AppColors.addedColor,
                //                       ],
                //                     ),
                //                   ),
                //                   child:Icon(Icons.arrow_forward_ios_sharp,
                //                       color: AppColors.appNewDarkThemeColor,
                //                       size:2.h
                //                   ),
                //                 ),
                //                 onTap: (){
                //                   Navigator.push(context,MaterialPageRoute(builder: (context) => Lesson(
                //                       catList:popularCourses[index].id,
                //                       subCatId: popularCourses[index].subcategoryId,
                //                       catImage:popularCourses[index].image,
                //                       catName:popularCourses[index].name,
                //                       catDescription:popularCourses[index].description,
                //                       duration:popularCourses[index].duration,
                //                       instructorName:popularCourses[index].instructorName,
                //                       instructorImage:popularCourses[index].instructorImage,
                //                       language:popularCourses[index].language,
                //                       level:popularCourses[index].level)));
                //                 },
                //               )
                //             ],
                //           )
                //       );
                //     },
                //     childCount: loader == false ? 3
                //         :popularCourses.length > 4 ? 4 : popularCourses.length ,
                //   ),
                // ),
              ],
              /* add child content here */
            ),
          )
        ),
      )
    );
  }

  Widget getMentor() {
    return popularInstructor != null
        ? Container(
          color: Colors.transparent,
            child: ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (_,__)=>SizedBox(width:1.h),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, position) {
                return Container(
                    width: 60.w,
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                   color: Colors.grey.shade100
                   ),
                  child:GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MentorDetailsPage(
                                id: popularInstructor[position].id.toString(),
                              )));
                    },
                    child: Container(
                      width: 60.w,
                      padding: EdgeInsets.all(1.h),
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  width: 7.h,
                                  height:7.h,
                                  imageUrl: StringConstant.IMAGE_URL+ popularInstructor[position].image.toString(),
                                  placeholder: (context, url) =>
                                      Helper.onScreenProgress(),
                                  errorWidget: (context, url, error) =>
                                  new Icon(Icons.error),
                                ),
                              ),
                              SizedBox(width:1.h,),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(popularInstructor[position].name.toString(),
                                      style: TextStyle(
                                        fontSize: 2.h,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text("Experience: ${popularInstructor[position].experience} years",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 1.5.h,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 1.h,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${popularInstructor[position].specialization}",
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 2.h,
                                  fontWeight: FontWeight.normal,
                                ),),
                              SizedBox(height: 1.h,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: Row(
                                    children: [
                                      Icon(Icons.star,size: 3.h,color: Colors.yellow,),
                                      SizedBox(width: 5,),
                                      Text("5",
                                        style: TextStyle(fontSize: 2.h,
                                          fontWeight: FontWeight.normal,
                                        ),),
                                    ],
                                  ),),
                                  Expanded(child: Row(
                                    children: [
                                      Icon(Icons.reviews_rounded,size: 2.5.h,
                                        color: AppColors.appNewLightThemeColor,),
                                      SizedBox(width: 5,),
                                      Text("100",
                                        style: TextStyle(fontSize: 2.h,
                                          fontWeight: FontWeight.normal,
                                        ),),
                                    ],
                                  ),),
                                  Expanded(child: Row(
                                    children: [
                                      Icon(Icons.thumb_up,size: 2.5.h,color: Colors.blue,),
                                      SizedBox(width: 5,),
                                      Text("1.5k",
                                        style: TextStyle(fontSize: 2.h,
                                          fontWeight: FontWeight.normal,
                                        ),),
                                    ],
                                  )),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )
                    ),
                  ),
                );
              },
              itemCount: popularInstructor.length,
            ),
          )
        : Container(
           child: Center(
             child: Text("Loading..."),
           )
    );
  }

  Widget getVideos() {
    return  loader == true
        ? ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (_,__)=>SizedBox(width: 10,),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, position) {
        return Container(
          width: 50.w,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.shade100
          ),
          child:  GestureDetector(
              onTap: () {
                setState(() {
                  imageurl = topCourses[position].image.toString();
                  mainindex = position;
                });
                Navigator.push(context,MaterialPageRoute(
                    builder: (context) => Lesson(
                    catList:topCourses[position].id,
                    subCatId: topCourses[position].subcategoryId,
                    catImage : topCourses[position].image,
                    catName :topCourses[position].name,
                    catDescription :topCourses[position].description,
                    duration: topCourses[position].duration,
                    instructorName: topCourses[position].instructorName,
                    instructorImage : topCourses[position].instructorImage,
                    language: topCourses[position].language,
                    level:topCourses[position].level)));
              },
              child: Container(
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(20),
                            topLeft: Radius.circular(20)),
                        child: CachedNetworkImage(
                          height: 15.h,
                          width: 50.w,
                          fit: BoxFit.cover,
                          imageUrl:StringConstant.IMAGE_URL+ topCourses[position].image.toString(),
                          placeholder: (context, url) =>
                              Helper.onScreenProgress(),
                          errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                        )),
                    Container(
                      width: 50.w,
                      padding:EdgeInsets.symmetric(vertical: .5.h,horizontal: 1.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${topCourses[position].name}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold,
                                fontSize: 2.h),
                          ),
                          Text(
                            "Level : ${topCourses[position].level}",
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 1.8.h, color: Colors.black54),
                          ),
                          Text(
                            "Language: ${topCourses[position].language}",
                            style: TextStyle(fontSize: 1.8.h),
                          ),
                          SizedBox(height: .5.h,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.timer_outlined, color: Colors.black,size: 3.h,),
                              Text(
                                " ${topCourses[position].duration} hr",
                                style: TextStyle(fontSize: 1.5.h),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),


                  ],
                ),
              )
          ),
        );
      },
      itemCount: topCourses.length,
    )
        : ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (_,__)=>SizedBox(width: 10,),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, position) {
        return Container(
          width: 50.w,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(20),
                  topLeft: Radius.circular(20)),
              color: Colors.white
          ),
          child: Wrap(children: [
            GestureDetector(
                onTap: () {
                  setState(() {

                  });
                },
                child: Container(
                  height: 38.h,
                  child: Stack(
                    children: <Widget>[
                      ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            height: MediaQuery.of(context).size.height * 0.20,
                            fit: BoxFit.cover,
                            imageUrl:StringConstant.IMAGE_URL+ "users/default.png",
                            placeholder: (context, url) =>
                                SizedBox(),
                            errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                          )),
                      Positioned(
                        top: 20.h,
                        child: Container(
                          width: 50.w,
                          padding:EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height:20,width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2,),),
                              SizedBox(height: .5.h,),
                              Text(
                                "Loading...",
                                maxLines: 2,
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.sp),
                              ),
                              SizedBox(height: .5.h,),

                              SizedBox(height: .5.h,),

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
      itemCount: 2,
    );
  }

  Widget liveClasses() {
    return loader == true
        ? ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (_,__)=>SizedBox(width: 10,),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, position) {
            return Container(
              width: 50.w,

              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade100
              ),
             child: GestureDetector(
              onTap: () {
                setState(() {
                  imageurl = liveClass[position].image.toString();
                  mainindex = position;
                });
                EasyLoading.showToast("${liveClass[position].name} class is not Starting yet.",
                    toastPosition: EasyLoadingToastPosition.bottom,
                    duration: Duration(seconds: 2));
              },
              child: Container(
                height: 28.h,
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        child: CachedNetworkImage(
                          height: 15.h,
                          width: 50.w,
                          fit: BoxFit.cover,
                          imageUrl:StringConstant.IMAGE_URL+ liveClass[position].image.toString(),
                          placeholder: (context, url) =>
                              Helper.onScreenProgress(),
                          errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                        )),
                    Container(
                      width: 50.w,
                      padding:EdgeInsets.symmetric(horizontal: 1.h,vertical: .5.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${liveClass[position].name}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold,
                                fontSize: 2.h),
                          ),
                          SizedBox(height: .5.h,),
                          Text(
                            "${liveClass[position].description}",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 1.5.h, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),


                  ],
                ),
              )
          ),
        );
      },
      itemCount: liveClass.length,
    )
        : ListView.separated(
           shrinkWrap: true,
            separatorBuilder: (_,__)=>SizedBox(width: 10,),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, position) {
              return Container(
               width: 50.w,
                decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(20),
                  topLeft: Radius.circular(20)),
              color: Colors.grey.shade100
          ),
          child: Wrap(children: [
            GestureDetector(
                onTap: () {
                  setState(() {

                  });
                },
                child: Container(
                  height: 30.h,
                  child: Stack(
                    children: <Widget>[
                      ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            height: MediaQuery.of(context).size.height * 0.20,
                            fit: BoxFit.cover,
                            imageUrl:StringConstant.IMAGE_URL+ "users/default.png",
                            placeholder: (context, url) => SizedBox(),
                            errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                          )),
                      Positioned(
                        top: 20.h,
                        child: Container(
                          width: 50.w,
                          padding:EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height:20,width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2,),),
                              SizedBox(height: .5.h,),
                              Text(
                                "Loading...",
                                maxLines: 2,
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.sp),
                              ),
                              SizedBox(height: .5.h,),

                              SizedBox(height: .5.h,),
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
      itemCount: 2,
    );
  }

  void _FetchData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      image = prefs.getString('profileImage');
      print("Image $image");
    });
    Helper.checkConnectivity().then((value) => {
      if (value)
        {
          loader = false,

          PreferenceConnector.getJsonToSharedPreference(
              StringConstant.loginData)
              .then((value) => {
            if (value != null)
              {
                ApiRepository().getHomeList(value).then((value) {
                  if (value != null) {
                    if (value.status == "successfull") {
                      setState(() {
                        loader = true;
                        imageList = value.body.banners;
                        featuredCategory = value.body.featuredCategories;
                        topCourses = value.body.featuredCourses;
                        liveClass = value.body.liveClasses;
                        popularCourses = value.body.popularCourses;
                        popularInstructor = value.body.popularInstructors;
                      });
                    } else {
                      Helper.showMessage(
                          "Something went wrong please logout and login again.");
                    }
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

  void instructorCourses(var id) {
    loader1 = false;
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
                      loader1 = true;
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


