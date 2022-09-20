import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/resources/app_colors.dart';
import 'package:evidya/screens/bottom_navigation/bottom_navigaction_bar.dart';
import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:evidya/utils/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../network/repository/api_repository.dart';
class RequestPrivateClass extends StatefulWidget {
  final String instructorId;
  const RequestPrivateClass({this.instructorId,
    Key key}) : super(key: key);

  @override
  State<RequestPrivateClass> createState() => _RequestPrivateClassState();
}

class _RequestPrivateClassState extends State<RequestPrivateClass> {
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();
  String radioButton = 'Group';
  final _formKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = new TextEditingController();
  TextEditingController subjectController = new TextEditingController();
  TextEditingController titleController = TextEditingController();
  FocusNode dates = FocusNode();
  FocusNode time = FocusNode();
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
                  icon: const Icon(Icons.keyboard_backspace,color: Colors.white,),
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
                            SizedBox(height: 3.h,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Schedule A Private Class",
                                  style: TextStyle(fontSize: 16.sp,color: Colors.black,
                                      fontWeight: FontWeight.bold),),
                              ],
                            ),
                            SizedBox(height: 3.h,),
                            Text("Title",style: TextStyle(fontSize: 12.sp,color: Colors.black,
                                fontWeight: FontWeight.bold),),

                            TextFormField(
                              style: const TextStyle(color: Colors.black),
                              autofocus: false,
                              cursorColor: Colors.black,
                              controller: titleController,
                              decoration:  InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                hintText: 'Enter Class title',
                                hintStyle: TextStyle(color: Colors.grey,fontSize: 10.sp),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Enter Class title !';
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
                                    Text("Date",style: TextStyle(fontSize: 12.sp,color: Colors.black,
                                        letterSpacing: .5,
                                        fontWeight: FontWeight.bold),),

                                    TextFormField(
                                      style: const TextStyle(color: Colors.black),
                                      focusNode: dates,
                                      autofocus: false,
                                      showCursor: false,
                                      //cursorColor: Colors.black,
                                      controller: dateController,
                                      decoration:  InputDecoration(
                                        border: InputBorder.none,
                                        //suffixIcon: Icon(Icons.keyboard_arrow_down_rounded,size: 25,),
                                        hintText: "${DateFormat.yMMMd().format(DateTime.parse(selectedDate.toString()))}",
                                        hintStyle: TextStyle(color: Colors.black,fontSize: 12.sp),
                                      ),
                                      onTap: (){
                                        dates.unfocus();
                                        _selectDate(context);
                                      },
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Enter Date !';
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
                                    Text("Time",style: TextStyle(fontSize: 12.sp,color: Colors.black,
                                        letterSpacing: .5,
                                        fontWeight: FontWeight.bold),),
                                    //   SizedBox(height: .5.h,),
                                    TextFormField(
                                      style: const TextStyle(color: Colors.black),
                                      autofocus: false,
                                      showCursor: false,
                                      //cursorColor: Colors.black,
                                      focusNode: time,
                                      controller: timeController,
                                      decoration:  InputDecoration(

                                        suffixIcon: Icon(Icons.keyboard_arrow_down_rounded,size: 25,),
                                        border: InputBorder.none,
                                        hintText: '${DateFormat.jm().format(DateTime.parse(selectedDate.toString()))}',
                                        hintStyle: TextStyle(color: Colors.black,fontSize: 12.sp),
                                      ),
                                      onTap: () {
                                        time.unfocus();
                                         _selectTime(context);
                                      },
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Enter time !';
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
                            Text("Description",style: TextStyle(fontSize: 12.sp,color: Colors.black,
                                fontWeight: FontWeight.bold),),
                            SizedBox(height: 1.h,),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(width: .5,color:Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                              style:  TextStyle(color: Colors.black,fontSize: 10.sp),
                              autofocus: false,
                              cursorColor: Colors.black,
                              controller: subjectController,
                              maxLines: 5,
                              decoration:  InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 2.h,vertical: 1.h),
                                border: InputBorder.none,
                                hintText: 'Enter class description',
                                hintStyle: TextStyle(color: Colors.grey,fontSize: 10.sp),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Enter class description !';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            ),
                            SizedBox(height: 1.h,),
                            Align(
                              alignment: Alignment.centerLeft,
                              child:  Text("Set the class title & description about which you want to learn.",
                                style: TextStyle(fontSize: 9.sp,color: Colors.black,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 2.h,),
                            Text("Choose Option for class",style: TextStyle(fontSize: 12.sp,color: Colors.black,
                                fontWeight: FontWeight.bold),),
                            SizedBox(height: 1.h,),
                            Row(
                              children: [
                                InkWell(
                                  child: Row(
                                    children: [
                                      Radio(value: "Group",
                                        groupValue: 'Group',
                                        onChanged: (String value){
                                          setState(() {
                                            radioButton = "Individual";
                                          });
                                        },
                                        activeColor: radioButton == "Group"?
                                        AppColors.appNewDarkThemeColor
                                            : Colors.grey,
                                      ),
                                      Text("Group",style: TextStyle(fontSize: 13.sp),)
                                    ],
                                  ),
                                    onTap: (){
                                      setState(() {
                                        radioButton = "Group";
                                      });
                                    },
                                ),
                                SizedBox(width: 3.w,),
                                InkWell(
                                  child: Row(
                                    children: [
                                      Radio(value: "Individual",
                                        groupValue: 'Individual',
                                        onChanged: (String value){
                                        setState(() {
                                            radioButton = "Individual";
                                          });
                                        },
                                        activeColor: radioButton != "Group"?
                                        AppColors.appNewDarkThemeColor
                                            : Colors.grey,
                                      ),
                                      Text("Individual",style: TextStyle(fontSize: 13.sp),)
                                    ],
                                  ),
                                  onTap: (){
                                    setState(() {
                                      radioButton = "Individual";
                                    });
                                  },
                                )
                              ],
                            ),
                            SizedBox(height: 1.h,),

                            // RichText(
                            //   text: TextSpan(
                            //     children: <TextSpan>[
                            //       TextSpan(text: 'Note: ', style: TextStyle(fontSize: 12.sp,
                            //           color: Colors.black,fontWeight: FontWeight.bold)),
                            //      radioButton =="Group" ? TextSpan(text: 'Group Class charges divided into per person of the group.',
                            //         style: TextStyle(color: Colors.black,
                            //             fontSize: 10.sp,fontWeight: FontWeight.w500),)
                            //       : TextSpan(text: 'Individual Class charges is 300 Rs per person.',
                            //        style: TextStyle(color: Colors.black,
                            //            fontSize: 10.sp,fontWeight: FontWeight.w500),),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: (){
                            if(_formKey.currentState.validate()) {
                              requestingClass(widget.instructorId);
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
                                    "Submit",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11.sp,
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
        dateController.value =
            TextEditingValue(text: picked.toString().substring(0, 10));
        print("DataInput ${dateController.text}");
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
                        //timeController.value = TextEditingValue(text: val.toString().substring(11, 16));
                        timeController.value = TextEditingValue(text: DateFormat.jm().format(DateTime.parse(val.toString())));
                      });
                    }),
              ),
            ],
          ),
        ));
  }
  void requestingClass(var instructorID) {
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
                ApiRepository()
                    .requestPrivateClasses(
                  token: value,
                  instructorId: instructorID.toString(),
                  topic: titleController.text,
                  description: subjectController.text,
                  date: dateController.text,
                  time: timeController.text,
                  classType: "$radioButton"
                ).then((value) {
                  print("Status ${value['status']}");
                  if (value['status'] == "successfully") {
                    print("Success $value");
                    setState(() {
                      EasyLoading.dismiss();
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
                                    Image.asset("assets/images/Smile.png",height: 10.h,),
                                    SizedBox(height: 15,),
                                    Text("Congratulations!",style: TextStyle(
                                        fontSize: 17.sp,
                                        color: Color(0xFF1da1f2),
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: .5
                                    ),),
                                    SizedBox(height: 5,),
                                    Text("You have successfully \nrequested your private class.",style: TextStyle(
                                        fontSize: 10.sp,
                                        letterSpacing: .5
                                    ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 15,),
                                    GestureDetector(
                                        onTap: (){
                                          //isShow = false;
                                          Navigator.pushAndRemoveUntil(context,
                                              MaterialPageRoute(builder: (context) => BottomNavbar(index: 4)),
                                                  (Route<dynamic> route) => false);
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
                      // EasyLoading.showToast("Private Class Requested.",
                      //     toastPosition: EasyLoadingToastPosition.bottom,
                      //     duration: Duration(seconds: 2));


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
}
