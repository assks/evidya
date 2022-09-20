import 'package:cached_network_image/cached_network_image.dart';
import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/resources/app_colors.dart';
import 'package:evidya/screens/messenger/logs.dart';
import 'package:evidya/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sizer/sizer.dart';

import '../../localdb/databasehelper.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../model/GroupListModal.dart';
import '../../model/recentchatconnectionslist_modal.dart';
import '../../network/repository/api_repository.dart';
import '../../sharedpref/preference_connector.dart';
import '../bottom_navigation/bottom_navigaction_bar.dart';
import 'fullscreenimage.dart';

class SenderProfilePage extends StatefulWidget {

  final String senderName;
  final String peerid;
  final String senderpeerid;
  final Members groupmemberdetails;
  final LogController logcontroller;
  final Connections senderdetails;
  final String status;

  const SenderProfilePage({this.status,this.groupmemberdetails,this.senderdetails,this.senderName,this.peerid,this.senderpeerid,this.logcontroller,Key key}) : super(key: key);

  @override
  State<SenderProfilePage> createState() => _SenderProfilePageState();
}

class _SenderProfilePageState extends State<SenderProfilePage> {
  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/back_ground.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Stack(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.keyboard_backspace,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 7.h, left: 1.h, right: 1.h),
                          padding: EdgeInsets.only(left: 3.h, right: 3.h,bottom: 2.h),
                          height:widget.senderdetails!=null? 85.h:80.h,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                                image: AssetImage(
                                  "assets/images/grey_background.jpg",
                                ),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 8.h,
                              ),
                              Text(
                                widget.senderName,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: .5,
                                    fontSize: 17.sp),
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                                Text(
                                  widget.senderdetails!=null? widget.senderdetails.phone:widget.groupmemberdetails.phone,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: .5,
                                      fontSize: 17.sp),
                                ),
                              SizedBox(
                                height: 1.h,
                              ),

                              Text(
                                widget.senderdetails!=null?widget.senderdetails.email:widget.groupmemberdetails.email,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: .5,
                                    fontSize: 17.sp),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Text(
                                widget.senderdetails!=null?"":"Bio: "+widget.groupmemberdetails.bio,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: .5,
                                    fontSize: 12.sp),
                              ),
                              Spacer(),
                               Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 4.h,),
                                  GestureDetector(
                                    onTap:(){blockUser();}  ,
                                    child: Container(
                                      color: Colors.white,
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.block,color: Colors.black,),
                                          const SizedBox(width: 10,),
                                          blocktext(),

                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 2.h,),
                                  GestureDetector(
                                    onTap:(){clearchat();}  ,
                                    child: Container(
                                      color: Colors.white,
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Icon(Icons.chat_bubble_outline_sharp,color: Colors.black,),
                                          SizedBox(width: 10,),
                                          Text("Clear Chat",style: TextStyle(fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,color: Colors.black))
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 2.h,),
                                  Container(
                                    color: Colors.white,
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Icon(Icons.thumb_down,color: Colors.black,),
                                        SizedBox(width: 10,),
                                        Text("Report Contact",style: TextStyle(fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,color: Colors.black))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 2.h,
                              ),

                            ],
                          ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          //alignment: Alignment.center,
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
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
                                  margin: const EdgeInsets.only(
                                      bottom: 5, right: 5, left: 5, top: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 1, color: Colors.transparent),
                                      color: Colors.transparent),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap:(){
                                          var imagelink= widget.senderdetails!=null?
                                          StringConstant.IMAGE_URL + widget.senderdetails.profile_image:
                                          StringConstant.IMAGE_URL + widget.groupmemberdetails.profileImage;
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FullScreenImage(
                                                          image:
                                                          imagelink)));
                                        } ,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child:CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            width: 25.w,
                                            height: 9.7.h,
                                            imageUrl: widget.senderdetails!=null?
                                            StringConstant.IMAGE_URL + widget.senderdetails.profile_image:
                                            StringConstant.IMAGE_URL + widget.groupmemberdetails.profileImage,
                                            placeholder: (context, url) =>
                                                Helper.onScreenProgress(),
                                            errorWidget: (context, url, error) =>
                                            const Icon(Icons.person),
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
                    ],
                  ),
                ),

              ],
            ),
          )
        ),
      ),
    );
  }

  void clearchat() {
    dbHelper.clearchat(widget.peerid,widget.senderpeerid);
    widget.logcontroller.clear();
    EasyLoading.showToast("Clean Chat", toastPosition: EasyLoadingToastPosition.bottom);
  }

  void blockUser() {
      Helper.checkConnectivity().then((value) => {
        if (value)
          {
            PreferenceConnector.getJsonToSharedPreference(
                StringConstant.loginData)
                .then((value) => {
              if (value != null)
                {
                  ApiRepository().blockuser(token: value,userid:widget.senderdetails.id)
                      .then((value) {
                    if (value['status'] == "successfull") {

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BottomNavbar(
                                index: 2,
                              )));
                      EasyLoading.dismiss();
                      print("Success $value");
                      setState(() {
                        EasyLoading.showToast(value['message'],
                            toastPosition:
                            EasyLoadingToastPosition.bottom,
                            duration: const Duration(seconds: 2));
                      });
                    } else {
                      EasyLoading.dismiss();
                      EasyLoading.showToast(value['message'],
                          toastPosition:
                          EasyLoadingToastPosition.bottom,
                          duration: const Duration(seconds: 5));
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

  blocktext() {
    return Text(widget.senderdetails.status=="active"?"Block":"Unblock",style: TextStyle(fontSize: 14.sp,
        fontWeight: FontWeight.w600,color: Colors.black));
  }
}
