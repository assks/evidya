import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:evidya/constants/page_route_constants.dart';
import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/model/login/PrefranceData.dart';
import 'package:evidya/network/repository/api_repository.dart';
import 'package:evidya/resources/app_colors.dart';
import 'package:evidya/screens/bottom_navigation/bottom_navigaction_bar.dart';
import 'package:evidya/screens/createmeet/schudle_meet_screen.dart';
import 'package:evidya/screens/login/login_screen.dart';
import 'package:evidya/screens/meet/meeting/StartMeetScreen/instantMeetScreen.dart';
import 'package:evidya/screens/meet/meeting/StartMeetScreen/startmeetscreen.dart';
import 'package:evidya/screens/meet/meetlist/bloc/meetlist_bloc.dart';
import 'package:evidya/screens/user/user_profile.dart';
import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:evidya/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';

import 'meetlist.dart';

class MeetList_Screen extends StatefulWidget {
  const MeetList_Screen({Key key}) : super(key: key);

  @override
  _MeetList_ScreenState createState() => _MeetList_ScreenState();
}

class _MeetList_ScreenState extends State<MeetList_Screen> {
  dynamic userdata;
  var localdata;
  var name =" ";
  String role, image;
 // CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  DateTime _selectedDay;
  DateTime _focusedDay;
  List dateCollection;
  List filterData = [];
  bool filter = false;
  @override
  void initState() {
    SharedPreferencedata();
    _events = {};
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _scrollController.addListener(_onScroll);
    super.initState();
  }
  final _scrollController = ScrollController();
  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<MeetList_Bloc>().add(PostFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        height: size.height,
     child: Scaffold(
      backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.h),
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 7.h),
                            padding: EdgeInsets.only(left: 3.h,right: 3.h),
                            height: 15.h,
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
                                Row(
                                  children: [
                                    Expanded(child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Start an Instant Meeting",
                                          style: TextStyle(fontSize: 2.5.h,fontWeight: FontWeight.bold),),
                                        Text("Generate your meeting link to begin.",
                                            style: TextStyle(fontSize: 1.8.h,fontWeight: FontWeight.normal)),
                                      ],
                                    ),),
                                    InkWell(
                                      child: Container(
                                         padding: EdgeInsets.only(left: 2.h,right: 2.h,top: 5,bottom: 5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              AppColors.addedColor,
                                              AppColors.addedColor,
                                            ],
                                          ),
                                        ),

                                        child: Text("Start",
                                          style: TextStyle(color: Colors.black,
                                              fontSize: 1.8.h,
                                              fontWeight: FontWeight.bold),)
                                      ),
                                      onTap: (){
                                        EasyLoading.show();
                                        submitapi();
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
                                         fit: BoxFit.fill,
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
                      SizedBox(height: 2.h,),
                      // role != "user"
                      //     ?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            child: Container(
                              width: 41.w,
                              height: 5.h,
                              padding: EdgeInsets.symmetric(horizontal: 2.h,vertical: 0.h),
                              decoration:BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade300,
                              ),
                              child: Center(
                                child: Text("Join",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 2.2.h,
                                      fontWeight: FontWeight.bold),),
                              )
                            ),
                            onTap: (){
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context)=>StartMeetScreen(localdata.name)));
                            },
                          ),
                          InkWell(
                            child: Container(
                              width: 41.w,
                              height: 5.h,
                              padding: EdgeInsets.symmetric(horizontal: 2.h,vertical: 0.h),
                              decoration:BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade300,
                              ),
                              child: Center(
                                child: Text("Schedule",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 2.2.h,fontWeight: FontWeight.bold),),
                              ),
                              ),
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>
                              const Schudle_Meet_Screen()));
                            },
                          )
                        ],
                      ),
                         // : Container(),
                      SizedBox(height: 1.h,),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(left: 1.h,right: 1.h),
                  decoration:  BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    image: DecorationImage(
                        image: AssetImage("assets/images/grey_background.jpg",),
                        fit: BoxFit.cover
                    ),
                  ),
                  height: 48.h,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                      Padding(
                        padding:  EdgeInsets.only(top: 3.h,left: 4.h,right: 4.h,),
                        child: Text("Your Scheduled Meetings",
                          style: TextStyle(fontSize: 15.sp,color: Colors.black,
                              letterSpacing: .5,
                              fontWeight: FontWeight.w800),),
                      ),
                      SizedBox(height:1.h),
                     Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.h,vertical: 1.h),
                      child:  TableCalendar(
                        firstDay: DateTime.now(),
                        lastDay: DateTime(DateTime.now().year +1 , DateTime.now().month, DateTime.now().day),
                        focusedDay: _focusedDay,
                        daysOfWeekStyle: DaysOfWeekStyle(),
                        headerVisible: false,
                        // onDaySelected: (date, events,holidays) {
                        //   setState(() {
                        //     _selectedEvents = events;
                        //   });
                        // },
                        onDaySelected: (selectedDay,focusedDay) {
                          setState(() {
                             _selectedDay = selectedDay;
                             _focusedDay = focusedDay;
                             filter = true;
                             print("Date $_selectedDay");
                          });
                        },
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        onPageChanged: (focusedDay) {
                          _focusedDay = focusedDay;
                          print("Date $_focusedDay}");
                        },
                        calendarStyle: CalendarStyle(
                          canMarkersOverflow: true,
                          todayTextStyle: TextStyle(
                            fontSize: 2.2.h
                          )
                            ),
                        calendarBuilders: CalendarBuilders(
                          selectedBuilder: (context, date, events) => Container(
                              margin: const EdgeInsets.all(4.0),
                              alignment: Alignment.center,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    AppColors.addedColor,
                                    AppColors.addedColor,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10.0)),
                              child: Text(
                                _focusedDay.day.toString(),
                                style: TextStyle(color: AppColors.appNewDarkThemeColor,
                                    fontSize: 2.2.h,
                                    fontWeight: FontWeight.bold),
                              )),
                          todayBuilder: (context, date, events) => Container(
                              margin: const EdgeInsets.all(4.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Text(
                                date.day.toString(),
                                style: TextStyle(color: Colors.white,fontSize: 2.2.h,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                        calendarFormat: CalendarFormat.week,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        // eventLoader: (day) {
                        //   if (day.weekday == DateTime.monday) {
                        //     return [];
                        //   }
                        //   return [];
                        // },
                      ),
                    ),

                      BlocProvider(
                        create: (_) => MeetList_Bloc(httpClient: http.Client())
                          ..add(PostFetched()),
                        child: Expanded(
                            child: BlocBuilder<MeetList_Bloc, MeetList_State>(
                              builder: (context, state) {
                                filterData.clear();
                                switch (state.status) {
                                  case MeetList_Status.failure:
                                    return const Center(child: Text('failed to fetch posts'));
                                  case MeetList_Status.success:
                                    for(int j = 0; j< state.posts.length; j++)
                                    {
                                      if((_selectedDay.toString().split(" ")[0]).
                                      compareTo(state.posts[j].startsAt.split(" ")[0])==0){
                                        filterData.add(state.posts[j]);
                                        _getEventsForDay(_selectedDay);
                                        print("Hello I am here $filterData");
                                      }
                                      else{
                                        //print("List of data ${state.posts}");
                                      }
                                    }
                                    if (filterData.isEmpty) {
                                      return Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: <Widget>[
                                            Text('You currently have no meetings\n scheduled on the selected date. \n Select a different date.' ,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 11.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey),)
                                          ],
                                        ),
                                      );
                                    } else {
                                      if(filter == true){
                                        return SingleChildScrollView(
                                            physics: ScrollPhysics(),
                                            child: Padding(
                                              padding:  EdgeInsets.symmetric(vertical: 2.h,horizontal: 4.h,),
                                              child: ListView.separated(
                                                //physics: NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemBuilder: (BuildContext context, int index) {
                                                  return Material(
                                                    color: Colors.transparent,
                                                    child: Wrap(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            Helper.showAlert(context, filterData[index].name,
                                                                filterData[index].description,
                                                                filterData[index].meetingId,
                                                                filterData[index].startsAt,
                                                                filterData[index].id.toString(),
                                                                filterData[index].disable_video,
                                                                filterData[index].disable_audio
                                                            );
                                                          },
                                                          child: Container(
                                                              padding:  EdgeInsets.only(top: 15,bottom: 15,left: 0,right: 1.h),
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
                                                                        color: AppColors.addedColor,
                                                                        borderRadius: BorderRadius.circular(10)
                                                                    ),
                                                                  ),
                                                                  SizedBox(width: 2.h,),
                                                                  Expanded(
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children:  [
                                                                        Text(filterData[index].name.toString(),
                                                                          style: TextStyle(fontSize: 12.sp,
                                                                              color: Colors.black,
                                                                              letterSpacing: .5,
                                                                              fontWeight: FontWeight.w600),),
                                                                        Text(DateFormat.yMMMd().format(DateTime.parse(filterData[index].startsAt.split(" ")[0]))
                                                                            +", "+
                                                                            DateFormat.jm().format(DateTime.parse(filterData[index].startsAt.toString())),
                                                                            //+" - " + DateFormat.jm().format(DateTime.parse(post.endsAt.toString())),
                                                                            style: TextStyle(fontSize: 10.sp,
                                                                                color: Colors.grey,
                                                                                letterSpacing: .5,
                                                                                fontWeight: FontWeight.w500)
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  GestureDetector(
                                                                    child: Container(
                                                                      padding: EdgeInsets.symmetric(vertical: .6.h,horizontal: 2.h),
                                                                      decoration: BoxDecoration(
                                                                          gradient: LinearGradient(
                                                                            begin: Alignment.topCenter,
                                                                            end: Alignment.bottomCenter,
                                                                            colors: [
                                                                              AppColors.addedColor,
                                                                              AppColors.addedColor
                                                                            ],
                                                                          ),
                                                                          borderRadius: BorderRadius.circular(20)
                                                                      ),
                                                                      child: Text("View",style: TextStyle(fontSize: 8.sp,
                                                                          color: AppColors.appNewDarkThemeColor,
                                                                          letterSpacing: .5,
                                                                          fontWeight: FontWeight.w800),),
                                                                    ),
                                                                    onTap: (){
                                                                      Helper.showAlert(context, filterData[index].name,
                                                                          filterData[index].description,
                                                                          filterData[index].meetingId,
                                                                          filterData[index].startsAt,
                                                                          filterData[index].id.toString(),
                                                                          filterData[index].disable_video,
                                                                          filterData[index].disable_audio
                                                                      );
                                                                    },
                                                                  ),
                                                                  SizedBox(width: 1.h,),
                                                                  InkWell(
                                                                    child: Icon(Icons.delete,
                                                                      size: 4.h,
                                                                      color: AppColors.buttonColor,),
                                                                    onTap: (){
                                                                      logoutAlertBox(context,filterData[index].id.toString());
                                                                    },
                                                                  )
                                                                ],
                                                              )
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                                itemCount: filterData.length,
                                                controller: _scrollController,
                                                separatorBuilder: (BuildContext context, int index) =>SizedBox(height: 2.h,),
                                              ),
                                            )
                                        );
                                      } else {
                                        return SingleChildScrollView(
                                            physics: ScrollPhysics(),
                                            child: Padding(
                                              padding:  EdgeInsets.symmetric(vertical: 2.h,horizontal: 4.h,),
                                              child: ListView.separated(
                                                //physics: NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemBuilder: (BuildContext context, int index) {
                                                  return Material(
                                                    color: Colors.transparent,
                                                    child: Wrap(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            Helper.showAlert(context, filterData[index].name,
                                                                filterData[index].description,
                                                                filterData[index].meetingId,
                                                                filterData[index].startsAt,
                                                                filterData[index].id.toString(),
                                                                filterData[index].disable_video,
                                                                filterData[index].disable_audio
                                                            );
                                                          },
                                                          child: Container(
                                                              padding:  EdgeInsets.only(top: 15,bottom: 15,left: 0,right: 1.h),
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
                                                                        color: AppColors.addedColor,
                                                                        borderRadius: BorderRadius.circular(10)
                                                                    ),
                                                                  ),
                                                                  SizedBox(width: 2.h,),
                                                                  Expanded(
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children:  [
                                                                        Text(filterData[index].name.toString(),
                                                                          style: TextStyle(fontSize: 12.sp,
                                                                              color: Colors.black,
                                                                              letterSpacing: .5,
                                                                              fontWeight: FontWeight.w600),),
                                                                        Text(DateFormat.yMMMd().format(DateTime.parse(filterData[index].startsAt.split(" ")[0]))
                                                                            +", "+
                                                                            DateFormat.jm().format(DateTime.parse(filterData[index].startsAt.toString())),
                                                                            //+" - " + DateFormat.jm().format(DateTime.parse(post.endsAt.toString())),
                                                                            style: TextStyle(fontSize: 10.sp,
                                                                                color: Colors.grey,
                                                                                letterSpacing: .5,
                                                                                fontWeight: FontWeight.w500)
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  GestureDetector(
                                                                    child: Container(
                                                                      padding: EdgeInsets.symmetric(vertical: .6.h,horizontal: 2.h),
                                                                      decoration: BoxDecoration(
                                                                          gradient: LinearGradient(
                                                                            begin: Alignment.topCenter,
                                                                            end: Alignment.bottomCenter,
                                                                            colors: [
                                                                              AppColors.appNewLightThemeColor,
                                                                              AppColors.appNewDarkThemeColor
                                                                            ],
                                                                          ),
                                                                          borderRadius: BorderRadius.circular(20)
                                                                      ),
                                                                      child: Text("View",style: TextStyle(fontSize: 8.sp,
                                                                          color: Colors.white,
                                                                          letterSpacing: .5,
                                                                          fontWeight: FontWeight.w800),),
                                                                    ),
                                                                    onTap: (){
                                                                      Helper.showAlert(context, filterData[index].name,
                                                                          filterData[index].description,
                                                                          filterData[index].meetingId,
                                                                          filterData[index].startsAt,
                                                                          filterData[index].id.toString(),
                                                                          filterData[index].disable_video,
                                                                          filterData[index].disable_audio
                                                                      );
                                                                    },
                                                                  ),
                                                                  SizedBox(width: 1.h,),
                                                                  InkWell(
                                                                    child: Icon(Icons.delete,
                                                                      size: 4.h,
                                                                      color: AppColors.buttonColor,),
                                                                    onTap: (){
                                                                      logoutAlertBox(context,filterData[index].id.toString());
                                                                    },
                                                                  )
                                                                ],
                                                              )
                                                          ),
                                                        ),

                                                      ],
                                                    ),
                                                  );
                                                },
                                                itemCount: filterData.length,
                                                controller: _scrollController,
                                                separatorBuilder: (BuildContext context, int index) =>SizedBox(height: 2.h,),
                                              ),
                                            )
                                        );
                                      }
                                    }
                                    break;
                                  default:
                                    return Center(child:
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 20,
                                          width: 20,
                                          child:  CircularProgressIndicator(
                                            strokeWidth: 1,
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        Text("Fetching Data...",style: TextStyle(fontSize: 12.sp,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold),)
                                      ],
                                    ));
                                }
                              },
                            ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
     ),
    );
  }
  logoutAlertBox(BuildContext buildContext,var meetingId){
    return showDialog(
        context: buildContext,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.transparent,
                borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/whitebackground.png")
                ),
              ),
              height: 16.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Are you sure wants to delete this meeting ?",style: TextStyle(
                      fontSize: 12.sp,
                      letterSpacing: .5
                  ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 14,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FlatButton(
                          minWidth: 100,
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          child: Center(
                            child: Text(
                              "CANCEL",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: .5
                              ),
                            ),
                          )
                      ),
                      Container(
                        height: 30,
                        width: 2,
                        color: Colors.red,
                      ),
                      FlatButton(
                          minWidth: 100,
                          onPressed: (){
                            Navigator.pop(context);
                            deleteMeetings(meetingId);
                          },
                          child: Center(
                            child: Text(
                              "YES",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: .5
                              ),
                            ),
                          )
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  void deleteMeetings(var meetId) {
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
                ApiRepository().deleteMeeting(value, meetId).then((value) {
                  if (value['status']== 'successfull') {
                    setState(() {
                      EasyLoading.showToast('Meeting Deleted',
                          toastPosition: EasyLoadingToastPosition.bottom);
                    });
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => BottomNavbar(index: 0,),
                      ), (route) => false,
                    );
                  } else {
                    Helper.showMessage("Something Missing");
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
        {
          Helper.showNoConnectivityDialog(context)}
    });
  }

  _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  void submitapi() {
    Helper.checkConnectivity().then((value) => {
      if (value)
        {

          PreferenceConnector.getJsonToSharedPreference(
              StringConstant.loginData)
              .then((value) => {
            if (value != null)
              {
                ApiRepository()
                    .createmeeting('INSTANT MEET', "INSTANT MEETING", "1970-01-01", '00:00','00:00','0','0','0', value).then((value) {
                 EasyLoading.dismiss();
                  if (value != null) {
                    if (value.status == "successfull") {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>
                              InstantMeetScreen(localdata.name,value.body.meetingId,value.body.id)));
                    } else {
                      EasyLoading.dismiss();
                      EasyLoading.showToast("Meeting not started yet. ",
                          toastPosition: EasyLoadingToastPosition.bottom);
                    }
                  }
                })
              }
            else
              {
              EasyLoading.dismiss(),
              EasyLoading.showToast(
              "Something went wrong please logout and login again.",
              toastPosition: EasyLoadingToastPosition.bottom)
              }
          })
        }
      else
        {
          EasyLoading.showToast("Enter a Meeting ID",
              toastPosition: EasyLoadingToastPosition.bottom)
        }
    });
  }

  void SharedPreferencedata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    image = prefs.getString('profileImage');
    role = prefs.getString('role')??"user";
    print("Image $image Role $role");
   await PreferenceConnector.getJsonToSharedPreferencetoken(StringConstant.Userdata)
        .then((value) => {
              if (value != null)
                {
                  userdata = jsonDecode(value.toString()),
                  setState(() {
                    localdata = PrefranceData.fromJson(userdata);
                   var fullname=localdata.name;
                     name = fullname.split(' ')[0];
                  })
                }
            });
  }




}
