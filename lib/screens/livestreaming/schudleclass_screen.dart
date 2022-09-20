import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:evidya/constants/color_constant.dart';
import 'package:evidya/constants/font_constants.dart';
import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/model/registrationUserDetails.dart';
import 'package:evidya/network/repository/api_repository.dart';
import 'package:evidya/resources/app_colors.dart';
import 'package:evidya/resources/text_styles.dart';
import 'package:evidya/screens/bottom_navigation/bottom_navigaction_bar.dart';
import 'package:evidya/screens/createmeet/bloc/SchudleMeet_Bloc.dart';
import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:evidya/utils/helper.dart';
import 'package:evidya/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:custom_progress_dialog/custom_progress_dialog.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class SchudleClass_screen extends StatefulWidget {
  const SchudleClass_screen({Key key}) : super(key: key);

  @override
  _SchudleClass_screenState createState() => _SchudleClass_screenState();
}

class _SchudleClass_screenState extends State<SchudleClass_screen> {
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();
  var _image;



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
  XFile image;
  var image1;
  final registrationUserDetails = RegistrationUserDetails();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sharedPreferenceData();
  }
  void sharedPreferenceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      image1 = prefs.getString('profileImage');
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/back_ground.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              IconButton(
                icon: Icon(Icons.keyboard_backspace,
                  size: 4.h,
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          SizedBox(height: 7.h,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Schedule a Broadcast",
                                style: TextStyle(fontSize: 2.55.h,color: Colors.black,
                                    fontWeight: FontWeight.bold),),

                            ],
                          ),
                          SizedBox(height: 3.h,),
                          Text("Title",style: TextStyle(fontSize: 2.1.h,color: Colors.black,
                              fontWeight: FontWeight.bold),),

                          TextFormField(
                            style: const TextStyle(color: Colors.black),
                            autofocus: false,
                            cursorColor: Colors.black,
                            controller: _titleController,
                            decoration:  InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: 'Enter broadcast title',
                              hintStyle: TextStyle(color: Colors.grey,fontSize: 2.h),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter Broadcast title !';
                              } else if (value.length < 5) {
                                return 'Meeting title contains at least 5 characters long!';
                              }else {
                                return null;
                              }
                            },
                          ),
                          const Divider(color: Colors.black,thickness: 1,height: 1,),
                          SizedBox(height: 2.h,),
                          Text("Description",style: TextStyle(fontSize: 2.1.h,color: Colors.black,
                              fontWeight: FontWeight.bold),),
                          //SizedBox(height: 1.h,),
                          TextFormField(
                            style: const TextStyle(color: Colors.black),
                            autofocus: false,
                            cursorColor: Colors.black,
                            controller: _subjectcontroller,
                            decoration:  InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: 'Enter broadcast description',
                              hintStyle: TextStyle(color: Colors.grey,fontSize: 2.h),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter broadcast description !';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const Divider(color: Colors.black,thickness: 1,height:1,),
                          SizedBox(height: 2.h,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child:
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Set broadcast date",style: TextStyle(fontSize: 2.1.h,color: Colors.black,
                                      letterSpacing: .5,
                                      fontWeight: FontWeight.bold),),
                                  // SizedBox(height: .5.h,),
                                  TextFormField(
                                    style: const TextStyle(color: Colors.black),
                                    focusNode: _dates,
                                    autofocus: false,
                                    showCursor: false,
                                    //cursorColor: Colors.black,
                                    controller: dateinput,
                                    decoration:  InputDecoration(
                                      border: InputBorder.none,
                                      //suffixIcon: Icon(Icons.keyboard_arrow_down_rounded,size: 25,),
                                      hintText: '${selectedDate.toString().split(" ")[0]}',
                                      hintStyle: TextStyle(color: Colors.black,fontSize: 2.1.h),
                                    ),
                                    onTap: (){
                                      _dates.unfocus();
                                      _selectDate(context);
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Enter Date!';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  const Divider(color: Colors.black, thickness: 1,height: 1,),
                                ],
                              )),
                              SizedBox(width: 5.h,),
                              Expanded(child:
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Set time",style: TextStyle(fontSize: 2.1.h,color: Colors.black,
                                      letterSpacing: .5,
                                      fontWeight: FontWeight.bold),),
                                  //   SizedBox(height: .5.h,),
                                  TextFormField(
                                    style: const TextStyle(color: Colors.black),
                                    autofocus: false,
                                    showCursor: false,
                                    //cursorColor: Colors.black,
                                    focusNode: _fromtime,
                                    controller: _timecontroller,
                                    decoration:  InputDecoration(

                                      suffixIcon: Icon(Icons.keyboard_arrow_down_rounded,size: 3.h,),
                                      border: InputBorder.none,
                                      hintText: '${DateFormat.jm().format(DateTime.parse(selectedDate.toString()))}',
                                      hintStyle: TextStyle(color: Colors.black,fontSize: 2.1.h),
                                    ),
                                    onTap: () {
                                      _fromtime.unfocus();
                                      _selectTime(context);
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Enter Time';
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
                          Text("Set an Image",style: TextStyle(fontSize: 2.1.h,
                              color: Colors.black,
                              letterSpacing: .5,
                              fontWeight: FontWeight.bold),),
                          SizedBox(height: 1.h,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  _selectImage(context); // Call Function that has showDatePicker()
                                },
                                child: SizedBox(
                                  height: 15.h,
                                  width: double.infinity,
                                  child: GestureDetector(
                                    onTap: () {
                                      _selectImage(context);
                                    },
                                    child: Container(
                                      child: _image != null
                                          ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(
                                          _image,
                                          height: 15.h,
                                          fit: BoxFit.fill,
                                        ),
                                      )
                                          : Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white70,
                                            borderRadius: BorderRadius.circular(10)),
                                        width: 50,
                                        height: 20,
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 2.h,),
                          // Align(
                          //   alignment: Alignment.center,
                          //   child:  Text("Set the broadcast title & subject for easy communication",
                          //     style: TextStyle(fontSize: 9.sp,color: Colors.black,
                          //         fontWeight: FontWeight.w500),
                          //     textAlign: TextAlign.center,
                          //   ),
                          // )
                        ],
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: (){
                          if(_formKey.currentState.validate()) {
                            if(_image != null){
                              submitapi();
                            } else{
                              EasyLoading.showToast("Oops! Image is not set.",
                                  toastPosition: EasyLoadingToastPosition.center);
                            }

                          }
                          else{
                            EasyLoading.showToast("Oops ! Something Missing. Please Check.");
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
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.h),
                                child: Text(
                                  "Schedule",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: .5
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h,)
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
                    child: image1 != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        width: 21.w,
                        height:10.h,
                        imageUrl: StringConstant.IMAGE_URL + image1,
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
    final DateTime picked = await showDatePicker(
        context: context,
        locale: const Locale('en', 'IN'),
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dateinput.value =
            TextEditingValue(text: picked.toString().substring(0, 10));
        print("DataInput ${dateinput.text}");
      });
  }

  _selectImage(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void submitapi() {
    EasyLoading.show();
    PreferenceConnector.getJsonToSharedPreferencetoken(StringConstant.loginData)
        .then((value) => {
              if (value != null)
                {
                  ApiRepository()
                      .schudleclass_Api(
                          value,
                          _titleController.text,
                          _subjectcontroller.text,
                          dateinput.text,
                           StartTime,
                          _image)
                      .then((value) {
                    if (value != null) {
                      print("Values $value");
                      if (value.status == "successfulls") {
                        setState(() {
                          EasyLoading.dismiss();
                          Helper.successAlertDialog(context, true,"Broadcast",value.body.id.toString());
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(builder: (context) => BottomNavbar(index: 1)),
                                  (Route<dynamic> route) => false);
                        });
                      } else {
                        EasyLoading.dismiss();
                        EasyLoading.showToast(
                            "Something went wrong. Please contact to admin.",
                            toastPosition: EasyLoadingToastPosition.bottom);
                      }
                    }
                  })
                }
            });
  }

  ImagePicker picker = ImagePicker();

  _imgFromGallery() async {
    XFile image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(image.path);
    });
  }

  _imgFromCamera() async {
    XFile image = await picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = File(image.path);;
    });
  }

  void _selectTime(ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
          height: 40.h,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                height: 40.h,
                child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: DateTime.now(),
                    onDateTimeChanged: (val) {
                      setState(() {
                        StartTime = val.toString().substring(11, 16);
                        _timecontroller.value = TextEditingValue(text: DateFormat.jm().format(DateTime.parse(val.toString())));
                      });
                    }),
              ),
            ],
          ),
        ));
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      title: Text("Successfully Scheduled",style: TextStyle(color: Colors.red),),
      content: Text(
          "Your class is Scheduled on " + dateinput.text + " at" + _timecontroller.text + "."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
