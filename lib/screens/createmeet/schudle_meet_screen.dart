import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:evidya/constants/color_constant.dart';
import 'package:evidya/constants/font_constants.dart';
import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/model/login/PrefranceData.dart';
import 'package:evidya/model/registrationUserDetails.dart';
import 'package:evidya/network/repository/api_repository.dart';
import 'package:evidya/resources/app_colors.dart';
import 'package:evidya/resources/text_styles.dart';
import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:evidya/utils/helper.dart';
import 'package:evidya/utils/size_config.dart';
import 'package:evidya/widget/back_toolbar_with_center_title.dart';
import 'package:evidya/widget/login_gradiant_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../bottom_navigation/bottom_navigaction_bar.dart';
import 'bloc/SchudleMeet_Bloc.dart';
import 'bloc/schudlemeet_event.dart';
import 'bloc/schudlemeet_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:custom_progress_dialog/custom_progress_dialog.dart';

class Schudle_Meet_Screen extends StatefulWidget {
  const Schudle_Meet_Screen({Key key}) : super(key: key);

  @override
  _Schudle_Meet_ScreenState createState() => _Schudle_Meet_ScreenState();
}

class _Schudle_Meet_ScreenState extends State<Schudle_Meet_Screen> {
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();
  DateTime selectedEndTime = DateTime.now().add(Duration(hours: 1));
  var StartTime='';
  var EndTime='';
  bool video = true;
  bool repeat = true;
  bool audio = true;
  Schudlemeet_Bloc _schudlemeetbloc;
  ProgressDialog _progressDialog = ProgressDialog();
  dynamic profileJson;

  TextEditingController dateinput = TextEditingController();
  TextEditingController _timecontroller = new TextEditingController();
  TextEditingController _subjectcontroller = new TextEditingController();
  TextEditingController _fromtimecontroller = new TextEditingController();
  TextEditingController _endtimeController = new TextEditingController();
  final _titleController = TextEditingController();
  final _titleFocus = FocusNode();
  final _subject = FocusNode();
  final _dates = FocusNode();
  final _fromtime = FocusNode();
  final _endtime = FocusNode();
  var Logindata;
  final _formKey = GlobalKey<FormState>();
  String meetDate;
 var image;
  final registrationUserDetails = RegistrationUserDetails();

  @override
  void initState() {
    dateinput.text = "";
    super.initState();
    sharedPreferenceData();
  }
  void sharedPreferenceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      image = prefs.getString('profileImage');
    });
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
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            // appBar: AppBar(
            //   backgroundColor: Colors.transparent,
            //   leading: IconButton(
            //     icon: const Icon(Icons.keyboard_backspace),
            //     onPressed: () {
            //       Navigator.pop(context);
            //     },
            //   ),
            //   title: const Text("Schedule Meeting"),
            //   centerTitle: true,
            // ),
            body: Stack(
              children: [
                IconButton(
                  icon:  Icon(Icons.keyboard_backspace,
                    size: 3.h,
                    color: Colors.white,),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Container(
                    margin: EdgeInsets.only(top: 7.h,right: 1.h,left: 1.h,bottom: 1.h),
                    padding: EdgeInsets.only(left: 3.h,right: 3.h),
                    height: 100.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/grey_background.jpg",),
                          fit: BoxFit.cover
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 7.h,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding:  EdgeInsets.symmetric(horizontal: 1.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:  [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text("Schedule a Meeting",
                                          style: TextStyle(fontSize: 2.5.h,color: Colors.black,
                                              fontWeight: FontWeight.bold),),

                                      ],
                                    ),
                                    SizedBox(height: 3.h,),
                                    Text("Meeting title",
                                      style: TextStyle(fontSize: 2.1.h,color: Colors.black,
                                        fontWeight: FontWeight.bold),),

                                    TextFormField(
                                      style: const TextStyle(color: Colors.black),
                                      autofocus: false,
                                      cursorColor: Colors.black,
                                      controller: _titleController,
                                      decoration:  InputDecoration(
                                        isDense: true,
                                        border: InputBorder.none,
                                        hintText: 'Enter the meeting title',
                                        hintStyle: TextStyle(color: Colors.grey,fontSize: 2.h),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Enter Meeting title !';
                                        }
                                        else if (value.length < 5) {
                                          return 'Meeting title contains at least 5 characters long!';
                                        }else {
                                          return null;
                                        }
                                      },
                                    ),
                                    const Divider(color: Colors.black,thickness: 1,height: 1,),
                                    SizedBox(height: 2.h,),
                                    Text("Set meeting date",style: TextStyle(fontSize: 2.1.h,color: Colors.black,
                                        fontWeight: FontWeight.bold),),
                                    //SizedBox(height: 1.h,),
                                    TextFormField(
                                      style: const TextStyle(color: Colors.black),
                                      autofocus: false,
                                      showCursor: false,
                                      cursorColor: Colors.black,
                                      controller: dateinput,
                                      focusNode: _dates,
                                      decoration:  InputDecoration(
                                        isDense: true,
                                        border: InputBorder.none,
                                        hintText: '${DateFormat('dd-MM-yyyy').format(selectedDate)}',
                                        hintStyle: TextStyle(color: Colors.grey,fontSize: 2.h),
                                      ),
                                      onTap: (){
                                        _dates.unfocus();
                                        _selectDate(context);
                                      },
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Enter Meeting Date !';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    const Divider(color: Colors.black,thickness: 1,height: 1,),
                                    SizedBox(height: 2.h,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(child:
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Start from",
                                              style: TextStyle(fontSize: 2.1.h,color: Colors.black,
                                                letterSpacing: .5,
                                                fontWeight: FontWeight.bold),),
                                            // SizedBox(height: .5.h,),
                                            TextFormField(
                                              style:  TextStyle(color: Colors.black,fontSize: 2.1.h),
                                              focusNode: _fromtime,
                                              autofocus: false,
                                              showCursor: false,
                                              //cursorColor: Colors.black,
                                              controller: _timecontroller,
                                              decoration:  InputDecoration(
                                                border: InputBorder.none,
                                                suffixIcon: Icon(Icons.keyboard_arrow_down_rounded,size: 25,),
                                                hintText: '${DateFormat.jm().format(DateTime.parse(selectedDate.toString()))}',
                                                hintStyle: TextStyle(color: Colors.grey,fontSize: 2.h),
                                              ),
                                              onTap: (){
                                                _fromtime.unfocus();
                                                _selectTime(context, "start time");
                                              },
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'Enter start time !';
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                            const Divider(color: Colors.black,
                                              thickness: 1,height: 1,),
                                          ],
                                         ),
                                        ),
                                        SizedBox(width: 5.h,),
                                        Expanded(child:
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("End at",style: TextStyle(fontSize: 2.1.h,color: Colors.black,
                                                letterSpacing: .5,
                                                fontWeight: FontWeight.bold),),
                                            //   SizedBox(height: .5.h,),
                                            TextFormField(
                                              style:  TextStyle(color: Colors.black,fontSize: 2.1.h),
                                              autofocus: false,
                                              showCursor: false,
                                              //cursorColor: Colors.black,
                                              focusNode: _endtime,
                                              controller: _endtimeController,
                                              decoration:  InputDecoration(
                                                suffixIcon: Icon(Icons.keyboard_arrow_down_rounded,size: 25,),
                                                border: InputBorder.none,
                                                hintText: '${DateFormat.jm().format(DateTime.parse(selectedEndTime.toString()))}',
                                                hintStyle: TextStyle(color: Colors.grey,fontSize: 2.h),
                                              ),
                                              onTap: () {
                                                _endtime.unfocus();
                                                _selectTime(context,
                                                    "end time"); // Call Function that has showDatePicker()
                                              },
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'Enter end time !';
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                            const Divider(
                                              endIndent: 0,
                                              color: Colors.black,thickness: 1,height: 1,),
                                          ],
                                        ))
                                      ],
                                    ),
                                    SizedBox(height: 2.h,),
                                    SizedBox(height: 1.h,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Always mute my microphone on start",
                                              style: TextStyle(fontSize: 1.8.h,color: Colors.black,
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.bold),),
                                            Text("Grant or restrict audio access",
                                              style: TextStyle(fontSize: 1.6.h,color: Colors.grey,
                                                  fontWeight: FontWeight.bold),),
                                          ],),
                                        CupertinoSwitch(
                                          value: audio,
                                          activeColor: AppColors.appNewDarkThemeColor,
                                          dragStartBehavior: DragStartBehavior.down,
                                          onChanged: (value) {
                                            setState(() {
                                              audio = value;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 1.h,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Always turn off my video on start",
                                              style: TextStyle(fontSize: 1.8.h,color: Colors.black,
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.bold),),
                                            Text("Grant or restrict video access",
                                              style: TextStyle(fontSize: 1.6.h,color: Colors.grey,
                                                  fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                        CupertinoSwitch(
                                          value: video,
                                          activeColor: AppColors.appNewDarkThemeColor,
                                          dragStartBehavior: DragStartBehavior.down,
                                          onChanged: (value) {
                                            setState(() {
                                              video = value;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          GestureDetector(
                              onTap: (){
                                if(_formKey.currentState.validate()) {
                                  EasyLoading.show();
                                  _schudlemeet(_titleController.text,
                                      _subjectcontroller.text,
                                      meetDate,
                                      _timecontroller.text);
                                }
                                else{}
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
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 2.h,),
                                      child: Text(
                                        "Schedule",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 2.1.h,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: .5
                                        ),
                                      ),
                                    ),
                                  ),
                                ),)),
                          SizedBox(height: 2.h,),

                        ],
                      ),
                    ),
                ),
                Align(
                  alignment: Alignment.topCenter,
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
          ),
        )
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year +1 , DateTime.now().month,DateTime.now().day));
    if (pickedDate != null) {
      print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      print(formattedDate);

      setState(() {
        dateinput.text = formattedDate;
        meetDate = DateFormat('yyyy-MM-dd').format(pickedDate);
        print("Dgsfbudjfhi ${dateinput.value}  sadgbdfjngk $meetDate");//set output date to TextField value.
      });
    } else {
      print("Date is not selected");
    }
  }

  void _selectTime(ctx, timetype) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
          height: 40.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20)
            ),
            color: Colors.white
          ),

          child: Column(
            children: [
              Container(
                height: 40.h,
                child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: DateTime.now(),
                    onDateTimeChanged: (val) {
                      setState(() {
                        if (timetype == "start time") {
                          StartTime = val.toString().substring(11, 16);
                          print("Start Time $StartTime");
                          _timecontroller.value = TextEditingValue(text: DateFormat.jm().format(DateTime.parse(val.toString())));
                        } else if (timetype == "end time") {
                          EndTime = val.toString().substring(11, 16);
                          _endtimeController.value = TextEditingValue(text: DateFormat.jm().format(DateTime.parse(val.toString())));

                        }
                      });
                    }),
              ),

            ],
          ),
        ));
  }

  void _schudlemeet(String title, String subject, String date, String time) {
    var repeatable = (repeat) ? 1:0;
    var disable_video = (video == true) ? '0':'1';
    var disable_audio = (audio == true) ? '0':'1';


    Helper.checkConnectivity().then((value) => {
          if (value)
            {

              PreferenceConnector.getJsonToSharedPreference(
                      StringConstant.loginData)
                  .then((value) => {
                        if (value != null)
                          {
                            ApiRepository()
                                .createmeeting(
                                    title, subject, date, StartTime,EndTime,repeatable,
                                disable_video,
                                disable_audio,
                                value)
                                .then((value) {
                             EasyLoading.dismiss();
                              if (value != null) {
                                if (value.status == "successfull") {
                                  Helper.successAlertDialog(context, true,"Meeting",value.body.meetingId);

                                } else {
                                  EasyLoading.dismiss();
                                  EasyLoading.showToast(
                                      "Something went wrong please logout and login again.",
                                  toastPosition: EasyLoadingToastPosition.bottom);
                                }
                              }
                            })
                          }
                        else
                          {
                         EasyLoading.dismiss(),
                            Helper.showMessage(
                                "Something went wrong please logout and login again.")
                          }
                      })
            }
          else
          {
              Helper.showNoConnectivityDialog(context)
            }
        });
  }
}
