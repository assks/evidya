import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/network/repository/api_repository.dart';
import 'package:evidya/resources/app_colors.dart';
import 'package:evidya/screens/bottom_navigation/bottom_navigaction_bar.dart';
import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:evidya/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sizer/sizer.dart';
class ReportPage extends StatefulWidget {
  const ReportPage({Key key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String _selectOption = 'meet';
  final _formKey = GlobalKey<FormState>();
  TextEditingController messageController = TextEditingController();
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
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.appNewDarkThemeColor,
          title: Text('Report'),
          centerTitle: true,
        ),
        body: SafeArea(
          child:Container(
            height: 100.h,
            margin: EdgeInsets.only(left: 1.h,right: 1.h,top: 1.h,bottom: 1.h),
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/grey_background.jpg",),
                  fit: BoxFit.cover
              ),
              borderRadius: BorderRadius.circular(20)
            ),
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 2.h,horizontal: 2.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Select the feature you're experiencing\na problem with.",
                            style: TextStyle(fontSize: 13.sp,
                                fontWeight: FontWeight.bold),),
                          SizedBox(height: 1.h,),
                          ListTile(
                            leading: Radio<String>(
                              value: 'meet',
                              groupValue: _selectOption,
                              onChanged: (value) {
                                setState(() {
                                  _selectOption = value;
                                });
                              },
                            ),
                            title: Text('bMeet',style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600
                            ),),
                          ),
                          ListTile(
                            leading: Radio<String>(
                              value: 'broadcast',
                              groupValue: _selectOption,
                              onChanged: (value) {
                                setState(() {
                                  _selectOption = value;
                                });
                              },
                            ),
                            title: Text('bLive',style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600
                            ),),
                          ),
                          ListTile(
                            leading: Radio<String>(
                              value: 'messenger',
                              groupValue: _selectOption,
                              onChanged: (value) {
                                setState(() {
                                  _selectOption = value;
                                });
                              },
                            ),
                            title: Text('bChat',style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600
                            ),),
                          ),
                          ListTile(
                            leading: Radio<String>(
                              value: 'lms',
                              groupValue: _selectOption,
                              onChanged: (value) {
                                setState(() {
                                  _selectOption = value;
                                });
                              },
                            ),
                            title: Text('bLearn',style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600
                            ),),
                          ),
                          SizedBox(height: 2.h,),
                          Text("Issues Description",style: TextStyle(fontSize: 12.sp,color: Colors.black,
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
                              controller: messageController,
                              maxLines: 5,
                              decoration:  InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 2.h,vertical: 1.h),
                                border: InputBorder.none,
                                hintText: 'Describe your issue in detail.',
                                hintStyle: TextStyle(color: Colors.grey,fontSize: 10.sp),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Enter Description !';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),


                        ],
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: (){
                          if(_formKey.currentState.validate()) {
                            reportProblem();
                          }
                          else{
                          EasyLoading.showToast("Oops ! Something Missing. Please Check.",
                              toastPosition: EasyLoadingToastPosition.bottom,
                          duration: Duration(seconds: 2));
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
                      )
                    ],
                  ),
                )
            )
         ),
        ),
      ),
    );
  }
  void reportProblem() {
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
                ApiRepository().sendReport(
                    token: value,
                  module: "for $_selectOption",
                  message: messageController.text,
                  
                ).then((value) {
                  if (value['status'] == "successfully") {
                    print("Success $value");
                    messageController.clear();
                    setState(() {
                      EasyLoading.showToast("Report Submitted Successfully",
                          toastPosition: EasyLoadingToastPosition.bottom,
                          duration: Duration(seconds: 2));
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) => BottomNavbar(index: 4)),
                              (Route<dynamic> route) => false);

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
