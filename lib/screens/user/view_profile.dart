import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/model/user_profile_modal.dart';
import 'package:evidya/network/repository/api_repository.dart';
import 'package:evidya/resources/app_colors.dart';
import 'package:evidya/screens/user/edit_profile.dart';
import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:evidya/widget/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/SizeConfigs.dart';
class ViewProfile extends StatefulWidget {
  final String token;
  const ViewProfile({this.token, Key key}) : super(key: key);

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {


  var url,token,name,password,email,phoneno;
  bool isProfileAvailable = true;
  String profileUrl;
  dynamic profileJson;
  Map loginJson;
  Future<UserProfileModal> userProfileData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userProfileData = ApiRepository().getUserProfile(widget.token);

  }

  String firstName;
  @override
  Widget build(BuildContext context) {
    return Container(
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
            body: FutureBuilder(
              future: userProfileData,
              builder: (BuildContext context,
                  AsyncSnapshot<UserProfileModal> snapshot) {
                print("Snapshot ${snapshot.hasData}");
                if (snapshot.hasData) {
                  var x = snapshot.data.body;
                  print("X Value $x");
                  PreferenceConnector().setProfileImage(x.image);
                  return Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.keyboard_backspace,color: Colors.white,),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Positioned(child:
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
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(height: 8.h,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("View Profile",
                                          style: TextStyle(fontSize: 16.sp,color: Colors.black,
                                              fontWeight: FontWeight.bold),),
                                        GestureDetector(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 2.h,vertical: 1.h),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  AppColors.appNewDarkThemeColor,
                                                  AppColors.appNewLightThemeColor,
                                                ],
                                              ),
                                              borderRadius: BorderRadius.circular(7),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text("Edit",style: TextStyle(fontSize: 10.sp,color: Colors.white),),
                                                SizedBox(width: 10,),
                                                Image.asset("assets/icons/edit.png",height: 12,width: 12,color: Colors.white),
                                              ],
                                            ),
                                          ),
                                          onTap: (){
                                            Navigator.push(context,
                                              MaterialPageRoute(builder: (context)=>EditProfile(
                                                  name: x.name,
                                                  email: x.email,
                                                  phone: x.phone,
                                                  age:x.age,
                                                  bio: x.bio,
                                                  city: x.city,
                                                  address:x.address,
                                                  state: x.state,
                                                  country: x.country,
                                                  image: x.image,
                                                  token: widget.token
                                              ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        /// ====== First Name
                                        SizedBox(height: 2.h,),
                                        Text("Name",
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              color: AppColors.appNewDarkThemeColor,
                                              letterSpacing: .5,
                                              fontWeight: FontWeight.bold
                                          ),),
                                        SizedBox(height: .5.h,),
                                        Text(x.name,
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              letterSpacing: .5,
                                              color: Colors.black
                                          ),),
                                        Divider(height: 1,thickness: 1,),
                                        /// ======= Email
                                        SizedBox(height: 2.h,),
                                        Text("Email",
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              color: AppColors.appNewDarkThemeColor,
                                              letterSpacing: .5,
                                              fontWeight: FontWeight.bold
                                          ),),
                                        SizedBox(height: .5.h,),
                                        Text(x.email,
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              letterSpacing: .5,
                                              color: Colors.black
                                          ),),
                                        Divider(height: 1,thickness: 1,),
                                        /// ==== Phone No
                                        SizedBox(height: 2.h,),
                                        Text("Phone No.",
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              color: AppColors.appNewDarkThemeColor,
                                              letterSpacing: .5,
                                              fontWeight: FontWeight.bold
                                          ),),
                                        SizedBox(height: .5.h,),
                                        Text(x.phone,
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              letterSpacing: .5,
                                              color: Colors.black
                                          ),),
                                        Divider(height: 1,thickness: 1,),
                                        /// ======= Designation ==
                                        SizedBox(height: 2.h,),
                                        Text("Age",
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              color: AppColors.appNewDarkThemeColor,
                                              letterSpacing: .5,
                                              fontWeight: FontWeight.bold
                                          ),),
                                        SizedBox(height: .5.h,),
                                        Text(x.age??"",
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              letterSpacing: .5,
                                              color: Colors.black
                                          ),),
                                        Divider(height: 1,thickness: 1,),
                                        SizedBox(height: 2.h,),
                                        Text("Bio",
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              color: AppColors.appNewDarkThemeColor,
                                              letterSpacing: .5,
                                              fontWeight: FontWeight.bold
                                          ),),
                                        SizedBox(height: .5.h,),
                                        Text(x.bio??"",
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              letterSpacing: .5,
                                              color: Colors.black
                                          ),),
                                        Divider(height: 1,thickness: 1,),
                                        /// ===== Address ===
                                        SizedBox(height: 2.h,),
                                        Text("Address",
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              color: AppColors.appNewDarkThemeColor,
                                              letterSpacing: .5,
                                              fontWeight: FontWeight.bold
                                          ),),
                                        SizedBox(height: .5.h,),
                                        Text("${x.address},\n${x.city},\n${x.state},\n${x.country}",
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              letterSpacing: .5,
                                              color: Colors.black
                                          ),),
                                        Divider(height: 1,thickness: 1,),

                                        /// ======= BUTTON ==
                                        SizedBox(height: 2.h,),
                                        // GradiantButton(
                                        //     buttonName: "Save",
                                        //     onPressed: () {
                                        //     }
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                          )
                      ),),
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
                            height: 10.h,
                            width: 21.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:Border.all(width: 1,color: Colors.transparent),
                              color:  Colors.transparent,),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                StringConstant.IMAGE_URL + x.image,
                                height: 9.h,
                                width: 20.w,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return  Stack(
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
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 30,width: 30,
                                  child: CircularProgressIndicator(strokeWidth: 2,),),
                                SizedBox(width:10),
                                Text("Fetching Data...",style: TextStyle(fontSize: 12.sp,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),)
                              ],
                            ),
                          )
                        )
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        //alignment: Alignment.center,
                        padding: EdgeInsets.all(15),
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
                          height: 9.h,
                          width: 20.w,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border:Border.all(width: 1,color: Colors.white),
                            color:  Colors.white,),
                          child: SizedBox(height: 20,width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2,),)
                        ),
                      ),
                    )
                  ],
                );
              },
            )
        ),
      )
    );
  }
}
