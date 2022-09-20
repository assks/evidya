import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'dart:core';
import 'dart:io';
import 'package:custom_progress_dialog/custom_progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:evidya/constants/color_constant.dart';
import 'package:evidya/constants/font_constants.dart';
import 'package:evidya/constants/profile_constant.dart';
import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/model/login/PrefranceData.dart';
import 'package:evidya/network/repository/api_repository.dart';
import 'package:evidya/resources/app_colors.dart';
import 'package:evidya/screens/bottom_navigation/bottom_navigaction_bar.dart';
import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:evidya/utils/SizeConfigs.dart';
import 'package:evidya/utils/helper.dart';
import 'package:evidya/widget/gradient_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class EditProfile extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String age;
  final String bio;
  final String city;
  final String address;
  final String state;
  final String country;
  final String image;
  final String token;

  const EditProfile({this.name,
    this.country,this.state,
    this.address,this.city,
    this.image, this.token,
    this.phone,this.bio, this.age,
    Key key, this.email}) : super(key: key);
  @override
  State<EditProfile> createState() => _EditProfileState();
}


class _EditProfileState extends State<EditProfile> {
  final _nameController = new TextEditingController();
  final _emailController = new TextEditingController();
  final _phoneController = new TextEditingController();
  final _bioController = new TextEditingController();
  final _ageController = new TextEditingController();
  final _addressController = new TextEditingController();
  final _cityController = new TextEditingController();
  final _stateController = new TextEditingController();
  final _countryController = new TextEditingController();
  final picker = ImagePicker();
  File _selectedFile;
  var _image;
  var url,token,name,password,email,phoneno;
  bool isProfileAvailable = true;
  String profileUrl;
  dynamic profileJson;
  Map loginJson;
  String profileType = ProfileConstant.LETTER;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  ProgressDialog _progressDialog = ProgressDialog();

  String firstName;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _emailController.text = widget.email;
    _phoneController.text = widget.phone;
    _ageController.text = widget.age;
    _bioController.text= widget.bio;
    _cityController.text = widget.city;
    _addressController.text = widget.address;
    _stateController.text  = widget.state;
    _countryController.text = widget.country;
    sharePreferenceData();
  }
  void sharePreferenceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('userName');
    email = prefs.getString('userEmail');
    await PreferenceConnector.getJsonToSharedPreferencetoken(StringConstant.Userdata)
        .then((value) => {
      if (value != null)
        {
          userdata = jsonDecode(value.toString()),
          setState(() {
            localdata = PrefranceData.fromJson(userdata);
            token = userdata['auth_token'];
            print("UserToken $token");
          }),
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        height: size.height,
        decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage("assets/images/back_ground.jpg"),
          fit: BoxFit.cover
         ),
        ),
       child: SafeArea(
         child: Scaffold(
             key: _scaffoldKey,
             resizeToAvoidBottomInset: true,
             backgroundColor: Colors.transparent,
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
                     child:  Padding(
                       padding: EdgeInsets.symmetric(horizontal: 2.h),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: <Widget>[
                           SizedBox(height: 8.h,),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Text("Edit Profile",
                                 style: TextStyle(fontSize: 16.sp,color: Colors.black,
                                     fontWeight: FontWeight.bold),),
                             ],
                           ),
                           /// ====== First Name
                           SizedBox(height: 2.h,),
                          Expanded(child: SingleChildScrollView(
                            child:  Form(
                              key : _formKey,

                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 0.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    /// ====== First Name ==============
                                    SizedBox(height: 1.h,),
                                    Text("First Name",
                                      style: TextStyle(
                                          fontSize: 12.sp
                                      ),),
                                    SizedBox(height: .3.h,),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(width: 1,color:Colors.grey)
                                      ),
                                      child: TextFormField(
                                        controller: _nameController,
                                        decoration: InputDecoration(
                                          filled: true,
                                          focusColor: Colors.white.withOpacity(0.5),
                                          hintText: "First Name",
                                          hintStyle: TextStyle(color: Colors.grey.shade700, fontSize:12.sp),
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                        ),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Enter a name';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),


                                    /// ======= Email ===============
                                    SizedBox(height: 1.h,),
                                    Text("Email",style: TextStyle(
                                        fontSize: 12.sp
                                    ),),
                                    SizedBox(height: .3.h,),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(width: 1,color:Colors.grey)
                                      ),
                                      child: TextFormField(
                                        controller: _emailController,
                                        decoration: InputDecoration(
                                          filled: true,
                                          enabled: false,
                                          focusColor: Colors.white.withOpacity(0.5),
                                          hintText: "Email",
                                          hintStyle: TextStyle(color: Colors.grey.shade700, fontSize:12.sp),
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                        ),
                                        validator: (value) {
                                          if (value.isEmpty ||
                                              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                  .hasMatch(value)) {
                                            return 'Enter a valid email!';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    /// ==== Phone No ========
                                    SizedBox(height: 1.h,),
                                    Text("Phone No.",style: TextStyle(
                                        fontSize: 12.sp
                                    ),),
                                    SizedBox(height: .3.h,),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(width: 1,color:Colors.grey)
                                      ),
                                      child: TextFormField(
                                        controller: _phoneController,
                                        decoration: InputDecoration(
                                          filled: true,
                                          focusColor: Colors.white.withOpacity(0.5),
                                          hintText: "Phone No.",
                                          hintStyle: TextStyle(color: Colors.grey.shade700, fontSize:12.sp),
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                        ),
                                        validator: (value) {
                                          if (value.isEmpty ||
                                              value.length < 10) {
                                            return 'Enter a valid phone no.!';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    /// ======= AGE ==
                                    SizedBox(height: 1.h,),
                                    Text("Age",style: TextStyle(
                                        fontSize: 12.sp
                                    ),),
                                    SizedBox(height: .3.h,),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(width: 1,color:Colors.grey)
                                      ),
                                      child: TextFormField(
                                        controller: _ageController,
                                        decoration: InputDecoration(
                                          filled: true,
                                          focusColor: Colors.white.withOpacity(0.5),
                                          hintText: "Age",
                                          hintStyle: TextStyle(color: Colors.grey.shade700, fontSize:12.sp),
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                        ),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Enter an age!';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    /// ==========BIO==========

                                    /// ===== Address ===
                                    SizedBox(height: 1.h,),
                                    Text("Address",style: TextStyle(
                                        fontSize: 12.sp
                                    ),),
                                    SizedBox(height: .3.h,),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(width: 1,color:Colors.grey)
                                      ),
                                      child: TextFormField(
                                        controller: _addressController,
                                        decoration: InputDecoration(
                                          filled: true,
                                          focusColor: Colors.white.withOpacity(0.5),
                                          hintText: "Address",
                                          hintStyle: TextStyle(color: Colors.grey.shade700, fontSize:12.sp),
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                        ),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Enter a address!';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),

                                    /// ============== city=================

                                    SizedBox(height: 1.h,),
                                    Text("City",style: TextStyle(
                                        fontSize: 12.sp
                                    ),),
                                    SizedBox(height: .3.h,),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(width: 1,color:Colors.grey)
                                      ),
                                      child: TextFormField(
                                        controller: _cityController,
                                        decoration: InputDecoration(
                                          filled: true,
                                          focusColor: Colors.white.withOpacity(0.5),
                                          hintText: "City",
                                          hintStyle: TextStyle(color: Colors.grey.shade700, fontSize:12.sp),
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                        ),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Enter a City!';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    /// ====================== State ===================================
                                    SizedBox(height: 1.h,),
                                    Text("State",style: TextStyle(
                                        fontSize: 12.sp
                                    ),),
                                    SizedBox(height: .3.h,),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(width: 1,color:Colors.grey)
                                      ),
                                      child: TextFormField(
                                        controller: _stateController,
                                        decoration: InputDecoration(
                                          filled: true,
                                          focusColor: Colors.white.withOpacity(0.5),
                                          hintText: "State",
                                          hintStyle: TextStyle(color: Colors.grey.shade700, fontSize:12.sp),
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                        ),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Enter State!';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    /// ===== country=====
                                    SizedBox(height: 1.h,),
                                    Text("Country",style: TextStyle(
                                        fontSize: 12.sp
                                    ),),
                                    SizedBox(height: .3.h,),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(width: 1,color:Colors.grey)
                                      ),
                                      child: TextFormField(
                                        controller: _countryController,
                                        decoration: InputDecoration(
                                          filled: true,
                                          focusColor: Colors.white.withOpacity(0.5),
                                          hintText: "Country",
                                          hintStyle: TextStyle(color: Colors.grey.shade700, fontSize:12.sp),
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                        ),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Enter Country!';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 1.h,),
                                    Text("Bio",
                                      style: TextStyle(
                                          fontSize: 12.sp
                                      ),),
                                    SizedBox(height: .3.h,),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(width: 1,color:Colors.grey)
                                      ),
                                      child: TextFormField(
                                        controller: _bioController,
                                        maxLines: 5,
                                        decoration: InputDecoration(
                                          filled: true,
                                          focusColor: Colors.white.withOpacity(0.5),
                                          hintText: "Bio",
                                          hintStyle: TextStyle(color: Colors.grey.shade700, fontSize:12.sp),
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                        ),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Enter a bio!';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    /// ======= BUTTON ==
                                    SizedBox(height: 4.h,),
                                    GestureDetector(
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
                                                  "Save",
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
                                        onTap: () {
                                          if(_formKey.currentState.validate()){
                                            _updateUserDetails();
                                          }
                                        }
                                    ),
                                  ],
                                ),
                              ),

                            ),
                          ),),

                           /// ======= BUTTON ==
                           SizedBox(height: 2.h,),
                           // GradiantButton(
                           //     buttonName: "Save",
                           //     onPressed: () {
                           //     }
                           // ),
                         ],
                       ),
                     )
                 ),
                 Align(
                   alignment: Alignment.topCenter,
                   child: Container(
                     //alignment: Alignment.center,
                     padding: EdgeInsets.all(1),
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
                             margin: EdgeInsets.only(bottom: 5,right: 5,left:5,top:5),
                             decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(10),
                                 border: Border.all(width: 1,color: Colors.transparent),
                                 color:Colors.transparent
                             ),
                             child: _image != null
                                 ? ClipRRect(
                               borderRadius: BorderRadius.circular(10),
                               child: Image.file(
                                 _image,
                                 height: 7.h,
                                 width: 15.w,
                                 fit: BoxFit.fill,
                               ),
                             )
                                 : widget.image != null
                                 ? ClipRRect(
                               borderRadius: BorderRadius.circular(10),
                               child: Image.network(
                                 StringConstant.IMAGE_URL + widget.image,
                                 height: 7.h,
                                 width: 15.w,
                                 fit: BoxFit.fill,
                               ),
                             )
                                 : ClipRRect(
                               borderRadius: BorderRadius.circular(10),
                               child: Image.asset(
                                 'assets/images/teacher.PNG',
                                 height: 7.h,
                                 width: 15.w,
                                 fit: BoxFit.fill,
                               ),
                             )
                         ),
                         Positioned(
                             bottom: 0,
                             right: 0,
                             child: InkWell(
                               child:CircleAvatar(
                                   radius: 12,
                                   backgroundColor: Colors.white,
                                   child: Image.asset('assets/icons/edit.png',height: 1.4.h,
                                     color: Color(0xFF5c0e35),)
                               ),
                               onTap: (){
                                 _selectImage(context);
                               },
                             )
                         ),
                       ],
                     ),
                   ),
                 )
               ],
             )
         ),
       )
    );
  }
  _updateUserDetails(){
    EasyLoading.show();
    ApiRepository().updateUserProfile(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      bio: _bioController.text,
      age: _ageController.text,
      city: _cityController.text,
      address: _addressController.text,
      state: _stateController.text,
      country: _countryController.text,
      token: widget.token
    ).then((value) {
      if (value != null) {
        print("Value $value");
        if (value['status'] == "successfull") {
          EasyLoading.dismiss();
          PreferenceConnector().setProfileData(_nameController.text,_emailController.text);
          EasyLoading.showToast("Profile Updated.",
              toastPosition: EasyLoadingToastPosition.bottom,duration: Duration(seconds: 5));
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) => BottomNavbar(index: 4)),
                  (Route<dynamic> route) => false);
        } else {
          EasyLoading.dismiss();
          EasyLoading.showToast("Something went wrong!",
              toastPosition: EasyLoadingToastPosition.top);
        }
      }
    });
  }

  _imgFromGallery() async {
    XFile image = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = File(image.path);
    });
    //EasyLoading.show();
    ApiRepository().updateProfilePic(token, _image).then((value) {
      if (value != null) {
        print("Value $value");
        if (value['status'] == "successfull") {
          PreferenceConnector().setProfileImage(value['image']);
          EasyLoading.dismiss();
          EasyLoading.showToast("Profile Image Updated",
              toastPosition: EasyLoadingToastPosition.bottom);
        } else {
          EasyLoading.dismiss();
          EasyLoading.showToast("Something went wrong!",
              toastPosition: EasyLoadingToastPosition.bottom);
        }
      }
    });
  }

  _imgFromCamera() async {
    XFile image = await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = File(image.path);;
    });
    //EasyLoading.show();
    ApiRepository().updateProfilePic(token, _image).then((value) {

      if (value != null) {
        print("Value $value");
        if (value['status'] == "successfull") {
          PreferenceConnector().setProfileImage(value['image']);
          EasyLoading.dismiss();
          EasyLoading.showToast("Profile Image Updated",
              toastPosition: EasyLoadingToastPosition.bottom);
        } else {
          EasyLoading.dismiss();
          EasyLoading.showToast("Something went wrong!",
              toastPosition: EasyLoadingToastPosition.bottom);
        }
      }
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
}
