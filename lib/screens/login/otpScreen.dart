import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/localization/app_translations.dart';
import 'package:evidya/localization/application.dart';
import 'package:evidya/network/repository/api_repository.dart';
import 'package:evidya/resources/app_colors.dart';
import 'package:evidya/resources/text_styles.dart';
import 'package:evidya/screens/login/forget_password.dart';
import 'package:evidya/screens/login/registration_screen.dart';
import 'package:evidya/sharedpref/constants/preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:evidya/utils/helper.dart';
import 'package:evidya/utils/size_config.dart';
import 'package:evidya/utils/validator.dart';
import 'package:evidya/widget/gradient_button.dart';
import 'package:evidya/widget/login_app_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sizer/sizer.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../bottom_navigation/bottom_navigaction_bar.dart';
import 'auth.dart';
import 'otpScreen.dart';

class OtpScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();

}

class _LoginScreenState extends State<OtpScreen> {

  final _mobileController =  TextEditingController();
  final _otpController =  TextEditingController();
  final loginUserDetails = LoginUserDetails();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final progressKey = GlobalKey();
  String deviceTokenToSendPushNotification = "";
  bool _obscureText = false;
  final _formKey = GlobalKey<FormState>();
  final _stopWatchTimer = StopWatchTimer(
    onChange: (value) {
      final displayTime = StopWatchTimer.getDisplayTime(value);
      // print('displayTime $displayTime');
    },
    onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
    onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
  );
  bool _obsure_resend_otp=false;




  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Container(
        height: MediaQuery
            .of(context)
            .size
            .height,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.fill),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            // resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
                child: Center(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Login With OTP",
                          style: TextStyle(
                              fontSize: 23.sp, fontWeight: FontWeight.bold),
                        ),

                        SizedBox(
                          height: 10.h,
                        ),
                        Form(
                            key: _formKey,
                            child: Padding(
                                padding: const EdgeInsets.all(30),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                    BorderRadius.circular(5),
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.grey)),
                                                child: TextFormField(
                                                  controller: _mobileController,
                                                  keyboardType: TextInputType.number,
                                                  onChanged: (content) {
                                                    if(content.length>=10){
                                                      _stopWatchTimer.rawTime.listen((value) =>
                                                          print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}'));
                                                      SendOTP();
                                                      _obsure_resend_otp=true;
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    focusColor: Colors.white.withOpacity(0.5),
                                                    hintText: "Enter your Phone.No",
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey.shade700,
                                                        fontSize: 15),
                                                    border: InputBorder.none,
                                                    focusedBorder: InputBorder.none,
                                                    enabledBorder: InputBorder.none,
                                                    errorBorder: InputBorder.none,
                                                    disabledBorder: InputBorder.none,
                                                  ),
                                                  validator: (value) {
                                                    if (value.isEmpty ||value.length==10)
                                                       {
                                                      return 'Enter your 10 digit Phone.No!';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              Visibility(
                                                  visible: _obsure_resend_otp,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      // Text(displayTime),
                                                      GestureDetector(
                                                        onTap: (){
                                                          SendOTP();
                                                        },
                                                        child: const Text("Resend OTP",style: TextStyle(color: Colors.red,fontSize: 14)),
                                                      ),
                                                    ],
                                                  )
                                              )
                                            ],
                                          ),
                                          // _email(size),
                                          SizedBox(height: 5.h),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(width: 1, color: Colors.grey),
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: TextFormField(
                                                  controller: _otpController,
                                                  keyboardType: TextInputType.number,
                                                  //obscureText: !_obscureText,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    focusColor: Colors.white.withOpacity(0.5),
                                                    hintText: "Enter your OTP",
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey.shade700,
                                                        fontSize: 15),
                                                    border: InputBorder.none,
                                                    focusedBorder: InputBorder.none,
                                                    enabledBorder: InputBorder.none,
                                                    errorBorder: InputBorder.none,
                                                    disabledBorder: InputBorder
                                                        .none,

                                                  ),
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Enter a OTP!';
                                                    } else if (value.length == 6) {
                                                      return 'OTP must be at least 6 characters.';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),


                                          SizedBox(height: 8.h),
                                          _submitButton(size),

                                        ],
                                      ),
                                      SizedBox(height: 22.h),
                                      _dontHaveAccount(),
                                      //SizedBox(height: 20),
                                      //_buildBody()
                                    ])))
                      ]),
                ))));
  }

  _onEmailChanged() {
    loginUserDetails.userEmail = _mobileController.text;
  }

  _onPasswordChanged() {
    loginUserDetails.password = _otpController.text;
  }

  void SendOTP() {
    FocusScope.of(context).requestFocus(FocusNode());
    Helper.checkConnectivity().then((value) =>
    {
      if (value)
        {
        EasyLoading.show(),
          ApiRepository().loginOtp( _mobileController.text).then((value) {
            if (value != null) {
              if (value.status == "successfull") {
                EasyLoading.showToast(value.message,toastPosition: EasyLoadingToastPosition.bottom,duration: const Duration(milliseconds: 10000));
              }
              else {
                EasyLoading.dismiss();
                EasyLoading.showToast("${value.message}",toastPosition: EasyLoadingToastPosition.bottom,duration: const Duration(milliseconds: 500));
                //showInSnackBar(value.message);
              }
            } else {
              EasyLoading.dismiss();
              EasyLoading.showToast("Something went wrong! ",toastPosition: EasyLoadingToastPosition.bottom);
              //showInSnackBar(value.message);
            }
          }
          )
        }
      else
        {
          EasyLoading.dismiss(),
          Helper.showNoConnectivityDialog(context)
        }
    }

    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
      backgroundColor: Colors.pink,
    ));
  }

  final Validator validator = Validator();

  Widget _submitButton(Size size) {
    return GradiantButton(
        buttonName: "Login",
        onPressed: () {
          //if (_formKey.currentState.validate()) {
            EasyLoading.show();
            getDeviceTokenToSendNotification();
          //}
        });
  }

  Future<void> getDeviceTokenToSendNotification() async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    final token = await _fcm.getToken();
    deviceTokenToSendPushNotification = token.toString();
    print("Token Value $deviceTokenToSendPushNotification");
    PreferenceConnector.setJsonToSharedPreferenceefcmtoken(StringConstant.fcmtoken,deviceTokenToSendPushNotification);
    _loginUser();
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _mobileController.addListener(_onEmailChanged);
    _otpController.addListener(_onPasswordChanged);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    application.onLocaleChanged = onLocaleChange;

    super.initState();
  }


  void onLocaleChange(Locale locale) async {
    setState(() {
      AppTranslations.load(locale);
    });
  }



  void _loginUser() {
    FocusScope.of(context).requestFocus(FocusNode());
    Helper.checkConnectivity().then((value) =>
    {
      if (value)
        {
          ApiRepository().otpLogin(_mobileController.text, _otpController.text, deviceTokenToSendPushNotification).then((value) async {
            EasyLoading.dismiss();
            print("logindata123 " + value.body.toString());
            if (value != null) {
              if (value.status == "successfull") {
                var loginData = value.body;
                String Data = jsonEncode(value.body);
                PreferenceConnector().setRole(loginData.role);
                PreferenceConnector().setProfileData(loginData.name, loginData.email);
                PreferenceConnector().setProfileImage(loginData.image);
                PreferenceConnector.setJsonToSharedPreference(StringConstant.loginData, loginData.authToken);

                PreferenceConnector.setJsonToSharedPreferencename(StringConstant.Username, loginData.name);
                PreferenceConnector.setJsonToSharedPreferenceemail(StringConstant.email, loginData.email);
                PreferenceConnector.setJsonToSharedPreferencephone(StringConstant.phoneno, loginData.phone);
                PreferenceConnector.setJsonToSharedPreferencetoken(StringConstant.Userdata, Data);
                PreferenceConnector().setLoginData(true);
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute( builder: (context) => BottomNavbar(index: 2)),
                        (Route<dynamic> route) => false);
              } else {
                EasyLoading.showToast(value.message,
                    toastPosition: EasyLoadingToastPosition.bottom);
                //showInSnackBar(value.message);
              }
            } else {
              showInSnackBar(
                  AppTranslations.of(context).text("Something went wrong"));
            }
          })
        }
      else
        {EasyLoading.dismiss(), Helper.showNoConnectivityDialog(context)}
    });
  }

  Widget _dontHaveAccount() {
    return GestureDetector(
        onTap: () {
          print("Container clicked");
          /*Navigator.of(context).pushNamedAndRemoveUntil(
              PageRouteConstants.registration_screen,
              (Route<dynamic> route) => false);*/
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => RegistrationScreen()));
        },
        child: Container(
          width: double.infinity,
          child: Center(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Don't have an account?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        )),
                    Text("Create",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.redColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        )),
                  ])),
        ));
  }

}
class LoginUserDetails {
  String userEmail;
  String password;
}
