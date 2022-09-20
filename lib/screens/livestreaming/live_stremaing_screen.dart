import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/model/home.dart';
import 'package:evidya/model/login/PrefranceData.dart';
import 'package:evidya/model/rtm_token_model.dart';
import 'package:evidya/network/repository/api_repository.dart';
import 'package:evidya/resources/app_colors.dart';
import 'package:evidya/screens/bottom_navigation/bottom_navigaction_bar.dart';
import 'package:evidya/screens/livestreaming/broadcast/CallPage.dart';
import 'package:evidya/screens/livestreaming/liveclass.dart';
import 'package:evidya/screens/livestreaming/schudleclass_screen.dart';

import 'package:evidya/screens/livestreaming/testing_live_stream.dart';
import 'package:evidya/screens/login/login_screen.dart';
import 'package:evidya/screens/user/user_profile.dart';
import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:evidya/utils/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:table_calendar/table_calendar.dart';

class LiveStreamingScreen extends StatefulWidget {
  const LiveStreamingScreen({Key key}) : super(key: key);

  @override
  _LiveStreamingScreenState createState() => _LiveStreamingScreenState();
}

class _LiveStreamingScreenState extends State<LiveStreamingScreen> {
  final _tokenController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  ProgressDialog pr;
  dynamic profileJson;
  var Logindata;
  dynamic userdata;
  RtmToken rtmtoken;
  List<LiveClasses> liveClasses;
  var imageurl = "";
  int mainindex = 0;
  var fullname = '';
  var name =" ";
  DateTime _selectedDay;
  DateTime _focusedDay;
  List dateCollection;
  List filterData = [];
  bool filter = false;
  String role, image;
  @override
  void initState() {
    _fetchClasseslistData();
    SharedPreferencedata();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    super.initState();
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
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
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        height: size.height,
        child: SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 7.h),
                          padding: EdgeInsets.only(left: 3.h,right: 3.h),
                          //height: .h,
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
                              Form(
                                key: _formKey,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2.h,vertical: 0.h),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Broadcast ID or link ",
                                            style: TextStyle(
                                                fontSize: 2.1.h,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          role != "user"
                                              ? InkWell(
                                                 child: CircleAvatar(
                                                   radius: 2.5.h,
                                                 backgroundColor: AppColors.addedColor,
                                              child: Icon(Icons.add,size: 4.h,
                                                color: AppColors.appNewDarkThemeColor,),
                                            ),
                                              onTap: (){
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => SchudleClass_screen(),
                                                  ));
                                            },
                                          )
                                              :Container()
                                        ],
                                      ),

                                      TextFormField(
                                        style: const TextStyle(color: Colors.black),
                                        autofocus: false,
                                        //showCursor: false,
                                        cursorColor: Colors.black,
                                        controller: _tokenController,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          border: InputBorder.none,
                                          hintText: 'Enter your broadcast ID or link here',
                                          hintStyle:
                                          TextStyle(color: Colors.grey, fontSize: 9.sp,),
                                        ),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please enter broadcast Id or link !';
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                      const Divider(
                                        color: Colors.black,
                                        height: 1,
                                        thickness: 1,
                                      ),
                                      SizedBox(
                                        height: 3.h,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            if (_formKey.currentState.validate()) {
                                              bool isProgressDialogShowing = pr.isShowing();
                                              print(isProgressDialogShowing);
                                              _validaction(_tokenController.text);
                                            } else {}
                                          },
                                          child: Center(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppColors.addedColor,
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
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                  EdgeInsets.symmetric(vertical: 2.h),
                                                  child: Text(
                                                    "Join",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 2.15.h,
                                                      letterSpacing: .5,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),
                                      SizedBox(
                                        height: 2.h,
                                      ),

                                    ],
                                  ),
                                ),
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
                  Spacer(),
                  Container(
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
                    height: 45.h,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:  [
                        Padding(
                          padding:  EdgeInsets.only(top: 3.h,left: 4.h,right: 4.h,),
                          child: Text("Your Scheduled Broadcasts",
                            style: TextStyle(fontSize: 2.5.h,color: Colors.black,
                                letterSpacing: .5,
                                fontWeight: FontWeight.w800),),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.h,vertical: 1.h),
                          child:  TableCalendar(
                            firstDay: DateTime.now(),
                            lastDay: DateTime(DateTime.now().year +1 , DateTime.now().month, DateTime.now().day),
                            focusedDay: _focusedDay,
                            headerVisible: false,
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                                filter = true;
                                print("Date $_selectedDay");// update `_focusedDay` here as well
                              });
                            },
                            selectedDayPredicate: (day) {
                              return isSameDay(_selectedDay, day);
                            },
                            onPageChanged: (focusedDay) {
                              _focusedDay = focusedDay;
                              print("Date $_focusedDay}");
                            },
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
                                        fontSize: 2.15.h,
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
                                    style: TextStyle(color: Colors.white,fontSize: 2.15.h,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                            calendarFormat: CalendarFormat.week,
                            startingDayOfWeek: StartingDayOfWeek.monday,
                            eventLoader: (day) {
                              if (day.weekday == DateTime.monday) {
                                return [];
                              }
                              return [];
                            },
                          ),
                        ),
                         upcommingclasses(size)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }

  void _validaction(var id) async {
    pr.style(
        padding: EdgeInsets.all(20),
        message: '       Please Wait! \n       Connecting....',
        borderRadius: 5.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(
          color: AppColors.addedColor,
          strokeWidth: 3,
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 8.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            letterSpacing: 1,
            color: Colors.black,
            fontSize: 16.0,
            fontWeight: FontWeight.w600));
    await pr.show();
    Helper.checkConnectivity().then((value) => {
          PreferenceConnector.getJsonToSharedPreferencetoken(
                  StringConstant.Userdata)
              .then((value) => {
                    if (value != null)
                      {
                        userdata = jsonDecode(value.toString()),
                        localdata = PrefranceData.fromJson(userdata),
                        print("Hello ${localdata.authToken} id $id"),
                        ApiRepository()
                            .livedata(localdata.authToken, id)
                            .then((value) {
                          //EasyLoading.show();
                          if (value != null) {
                            if (value.status == "successfull") {
                              setState(() {
                                var livedataData = value.body;
                                print("Hello $livedataData");
                                if (livedataData.liveClass.status !=
                                    "scheduled") {
                                  ApiRepository()
                                      .rtmtoken(localdata.authToken,
                                          livedataData.liveClass.id.toString())
                                      .then((value) {
                                    pr.hide().then((isHidden) {
                                      print(isHidden);
                                    });
                                    // EasyLoading.dismiss();
                                    if (value != null) {
                                      print("I am here ${value.status}");
                                      if (value.status == "successfull") {
                                        print("I am here now");
                                        print(
                                            "chaneele ${livedataData.liveClass}");
                                        _tokenController.clear();
                                        rtmtoken = value.body;
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LiveClass(
                                                      userName: localdata.id
                                                          .toString(),
                                                      channelName: livedataData
                                                          .liveClass
                                                          .streamChannel,
                                                      token: livedataData
                                                          .liveClass
                                                          .streamToken,
                                                      liveStreamStatus : livedataData.liveClass.status,
                                                      liveStreamDescription: livedataData.liveClass.description,
                                                      liveStreamId : livedataData.liveClass.streamId,
                                                      roomType: livedataData.liveClass.roomType,
                                                      roomStatus : livedataData.liveClass.roomStatus,
                                                      isBroadcaster: false,
                                                      classname: livedataData.liveClass.name,
                                                      appid: rtmtoken.appid,
                                                      rtmChannel:
                                                         rtmtoken.rtmChannel,
                                                      rtmToken:
                                                          rtmtoken.rtmToken,
                                                      rtmUser:
                                                          rtmtoken.rtmUser)),
                                        );
                                      }
                                    }
                                  });
                                } else {
                                  pr.hide().then((isHidden) {
                                    print(isHidden);
                                  });
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          backgroundColor: Colors.transparent,
                                          child: new Container(
                                            padding: EdgeInsets.symmetric(horizontal: 25,vertical: 20),
                                            width: 260.0,
                                            height: 300.0,
                                            decoration: new BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              color: Colors.transparent,
                                              borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                                              image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: AssetImage("assets/images/whitebackground.png")
                                              ),
                                            ),
                                            child: new Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Image.asset("assets/images/sad.png",height: 10.h,),
                                                SizedBox(height: 15,),
                                                Text("Oops!",style: TextStyle(
                                                    fontSize: 17.sp,
                                                    color: AppColors.buttonColor,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: .5
                                                ),),
                                                SizedBox(height: 5,),
                                                Text("Oops! Broadcast is not started yet! \nPlease wait for moment.",style: TextStyle(
                                                    fontSize: 10.sp,
                                                    letterSpacing: .5
                                                ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(height: 15,),
                                                GestureDetector(
                                                    onTap: (){
                                                      //isShow = false;
                                                      Navigator.pop(context);
                                                    },
                                                    child: Center(
                                                      child: Container(
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
                                                          borderRadius: BorderRadius.circular(30),
                                                        ),
                                                        child:  Center(
                                                          child: Padding(
                                                            padding: EdgeInsets.only(top: 10, bottom: 10),
                                                            child: Text(
                                                              "Okay",
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 10.sp,
                                                                  fontWeight: FontWeight.w500,
                                                                  letterSpacing: .5
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),)),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                  // EasyLoading.showToast(
                                  //     "Broadcast is not started yet",
                                  //     duration: Duration(seconds: 3),
                                  //     toastPosition:
                                  //         EasyLoadingToastPosition.bottom);
                                }
                              });
                            } else {
                              pr.hide().then((isHidden) {
                                print(isHidden);
                              });
                              EasyLoading.showToast(
                                "Something went wrong, Please check your Broadcast ID.",
                                duration: Duration(seconds: 3),
                              );
                            }
                          }
                        })
                      }
                  })
        });
  }

  Future<void> onJoin(context, String token, String app_id, String channal,
      String htoken) async {
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
              token: token, app_id: app_id, channelName: channal, id: htoken),
        ));
  }


  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
  upcommingclasses(Size size) {
    filterData.clear();
    if(liveClasses != null) {
      for (int j = 0; j < liveClasses.length; j++) {
        print("all Date ${liveClasses[j].startsAt}");
        if ((_selectedDay.toString().split(" ")[0]).
        compareTo(liveClasses[j].startsAt.split(" ")[0]) == 0) {
          filterData.add(liveClasses[j]);
          print("Hello I am here $filterData");
        }
        else {
          //print("List of data ${state.posts}");
        }
      }
    } else{

    }
      return liveClasses != null
          ? Expanded(child: SingleChildScrollView(
        //physics: ScrollPhysics(),
           child:  filterData.length == 0
               ? Container(
                 height: 30.h,
               child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('You currently have no broadcasts\n scheduled on the selected date.\n Select a different date.' ,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),)
                ],
              )
          ))
            : filter == true
                ? Padding(
                 padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.h,),
                  child: ListView.separated(
                   shrinkWrap: true,
                   physics: NeverScrollableScrollPhysics(),
                   scrollDirection: Axis.vertical,
                   itemBuilder: (context, position) {
                    return Wrap(
                      children: [
                        GestureDetector(
                          onTap: () {
                            EasyLoading.showInfo("Live Broadcasting is not starting "
                                "from Mobile.Please go on the bvidya Dashboard.",duration: Duration(seconds: 5),
                            );
                          },
                          child: Container(
                              padding: const EdgeInsets.only(top: 10,
                                  bottom: 10,
                                  left: 20,
                                  right: 10),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 10,
                                        offset: Offset(-1, 1),
                                        color: Colors.grey.shade400
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white
                              ),
                              child: Row(
                                children: [
                                  CachedNetworkImage(
                                    fit: BoxFit.fill,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                          width: 10.w,
                                          height: 5.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                    imageUrl: StringConstant.IMAGE_URL +
                                        filterData[position].image,
                                    placeholder: (context, url) =>
                                        Container(
                                          width: 10.w,
                                          height: 5.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/profile_demo.png'),
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                  SizedBox(width: 10,),
                                  Expanded(child:
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        filterData[position].name,
                                        style: TextStyle(
                                            fontSize: 2.1.h,
                                            color: Colors.black,
                                            letterSpacing: .5,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(DateFormat.yMMMd().format(DateTime.parse(
                                          filterData[position].startsAt.split(
                                              " ")[0]))
                                          + ", " +
                                          DateFormat.jm().format(DateTime.parse(
                                              filterData[position].startsAt
                                                  .toString())),
                                          //+" - " + DateFormat.jm().format(DateTime.parse(post.endsAt.toString())),
                                          style: TextStyle(fontSize: 1.6.h,
                                              color: Colors.grey,
                                              letterSpacing: .5,
                                              fontWeight: FontWeight.w500)
                                      )
                                    ],
                                  ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        imageurl =
                                            filterData[position].id.toString();
                                        mainindex = position;
                                      });
                                      _onShareWithEmptyFields(
                                          context,
                                          filterData[position].streamId.toString(),'Broadcast');
                                    },
                                    icon: Icon(
                                      Icons.share,
                                      size: 3.h,
                                      color: AppColors.addedColor,
                                    ),
                                  ),
                                  SizedBox(width: 1.h,),
                                  InkWell(
                                    child: Icon(Icons.delete,
                                      size: 3.h,
                                      color: AppColors.buttonColor,),
                                    onTap: (){
                                      logoutAlertBox(context,filterData[position].id.toString());
                                    },
                                  )
                                ],
                              )),
                        ),
                   ],
                 );
               },
               itemCount: filterData.length,
               separatorBuilder: (BuildContext context, int index) =>
                   SizedBox(
                     height: 2.h,
                   ),
             ),
           )
                : Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.h,),
                 child: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, position) {
                   return Wrap(
                   children: [
                     GestureDetector(
                       onTap: () {
                         EasyLoading.showInfo("Live Broadcasting is not starting "
                             "from Mobile.Please go on the bvidya Dashboard.",duration: Duration(seconds: 5),
                         );
                       },
                       child: Container(
                           padding: const EdgeInsets.only(top: 10,
                               bottom: 10,
                               left: 20,
                               right: 10),
                           decoration: BoxDecoration(
                               boxShadow: [
                                 BoxShadow(
                                     blurRadius: 10,
                                     offset: Offset(-1, 1),
                                     color: Colors.grey.shade400
                                 ),
                               ],
                               borderRadius: BorderRadius.circular(15),
                               color: Colors.white
                           ),
                           child: Row(
                             children: [
                               CachedNetworkImage(
                                 fit: BoxFit.fill,
                                 imageBuilder: (context, imageProvider) =>
                                     Container(
                                       width: 10.w,
                                       height: 5.h,
                                       decoration: BoxDecoration(
                                         shape: BoxShape.circle,
                                         image: DecorationImage(
                                             image: imageProvider,
                                             fit: BoxFit.cover),
                                       ),
                                     ),
                                 imageUrl: StringConstant.IMAGE_URL +
                                     filterData[position].image,
                                 placeholder: (context, url) =>
                                     Container(
                                       width: 10.w,
                                       height: 5.h,
                                       decoration: BoxDecoration(
                                         shape: BoxShape.circle,
                                         image: DecorationImage(
                                             image: AssetImage(
                                                 'assets/images/profile_demo.png'),
                                             fit: BoxFit.cover),
                                       ),
                                     ),
                                 errorWidget: (context, url, error) =>
                                     Icon(Icons.error),
                               ),
                               SizedBox(width: 10,),
                               Expanded(child:
                               Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text(
                                     filterData[position].name,
                                     style: TextStyle(
                                         fontSize: 2.1.h,
                                         color: Colors.black,
                                         letterSpacing: .5,
                                         fontWeight: FontWeight.bold),
                                   ),
                                   Text(DateFormat.yMMMd().format(DateTime.parse(
                                       filterData[position].startsAt.split(
                                           " ")[0]))
                                       + ", " +
                                       DateFormat.jm().format(DateTime.parse(
                                           filterData[position].startsAt
                                               .toString())),
                                       //+" - " + DateFormat.jm().format(DateTime.parse(post.endsAt.toString())),
                                       style: TextStyle(fontSize: 1.6.h,
                                           color: Colors.grey,
                                           letterSpacing: .5,
                                           fontWeight: FontWeight.w500)
                                   )
                                 ],
                               ),
                               ),
                               IconButton(
                                 onPressed: () {
                                   setState(() {
                                     imageurl =
                                         filterData[position].id.toString();
                                     mainindex = position;
                                   });
                                   _onShareWithEmptyFields(
                                       context,
                                       filterData[position].streamId.toString(),'Broadcast');
                                 },
                                 icon: Icon(
                                   Icons.share,
                                   size: 3.h,
                                   color: AppColors.addedColor,
                                 ),
                               ),
                               SizedBox(width: 1.h,),
                               InkWell(
                                 child: Icon(Icons.delete,
                                   size: 3.h,
                                   color: AppColors.buttonColor,),
                                 onTap: (){
                                   logoutAlertBox(context,filterData[position].id.toString());
                                 },
                               )
                             ],
                           )),
                     ),
                     ],
                     );
                   },
                   itemCount: filterData.length,
                   separatorBuilder: (BuildContext context, int index) =>
                   SizedBox(
                     height: 2.h,
                   ),
             ),
           )
        ))
          : Expanded(child: Center(child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                      ),
                    ),
                    SizedBox(width: 10,),
                    Text("Fetching Data...", style: TextStyle(fontSize: 2.1.h,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),)
                   ],
            ),),
      );
  }

   _onShareWithEmptyFields(BuildContext context, String id,String type) async {
    Helper.checkConnectivity().then((value) =>
    {
      if (value)
        {
          PreferenceConnector.getJsonToSharedPreference(
              StringConstant.Userdata)
              .then((value) =>
          {
            if (value != null)
              {
                userdata = jsonDecode(value.toString()),
                localdata = PrefranceData.fromJson(userdata),

                FlutterShare.share(
                    title: 'Meeting Id',
                    text: '${localdata.name} just invited you to a bvidya $type.\n'
                        '$type code -$id\n'
                        'To join, copy the code and enter it on the bvidya app or website.'
                ),
              }
            else
              {
                Helper.showMessage(
                    "Something went wrong please logout and login again.")
              }
          })
        }

    });
  }
  logoutAlertBox(BuildContext buildContext, var broadcastId){
    return showDialog(
        context: context,
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
                  Text("Are you sure wants to delete this broadcast ?",style: TextStyle(
                      fontSize: 2.1.h,
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
                            deleteBroadCast(broadcastId);
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

  void deleteBroadCast(var liveId) {
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
                ApiRepository().deleteBroadcast(value, liveId).then((value) {
                  if (value['status']== 'successfull') {
                    setState(() {
                      EasyLoading.showToast('Broadcast Deleted',
                          toastPosition: EasyLoadingToastPosition.bottom);
                    });
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => BottomNavbar(index: 1,),
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
        {Helper.showNoConnectivityDialog(context)}
    });
  }

  void _fetchClasseslistData() async {
    Helper.checkConnectivity().then((value) => {
          if (value)
            {
              PreferenceConnector.getJsonToSharedPreference(
                      StringConstant.Userdata)
                  .then((value) => {
                        if (value != null)
                          {
                            userdata = jsonDecode(value.toString()),
                            localdata = PrefranceData.fromJson(userdata),
                            ApiRepository()
                                .upcommingclasses(localdata.authToken)
                                .then((value) {
                              if (value != null) {
                                if (value.status == "successfull") {
                                  setState(() {
                                    liveClasses = value.body.liveClasses;
                                    fullname = localdata.name;
                                  });
                                  print("selectedDate $_selectedDay");
                                  for(int j = 0; j< liveClasses.length; j++)
                                  {
                                    print("all Date ${liveClasses[j].startsAt}");
                                    if((_selectedDay.toString().split(" ")[0]).
                                    compareTo(liveClasses[j].startsAt.split(" ")[0])==0){
                                      filterData.add(liveClasses[j]);
                                      print("Hello I am here $filterData");
                                    }
                                    else{
                                      //print("List of data ${state.posts}");
                                    }
                                  }
                                } else {
                                  EasyLoading.showToast(
                                      "Something went wrong please logout and login again.");
                                }
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
