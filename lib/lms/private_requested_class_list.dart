import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/network/repository/api_repository.dart';
import 'package:evidya/resources/app_colors.dart';
import 'package:evidya/screens/bottom_navigation/bottom_navigaction_bar.dart';
import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:evidya/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
class PrivateRequestedClassList extends StatefulWidget {
  const PrivateRequestedClassList({Key key}) : super(key: key);
  @override
  State<PrivateRequestedClassList> createState() => _PrivateRequestedClassListState();
}

class _PrivateRequestedClassListState extends State<PrivateRequestedClassList> {
  bool loader = false;
  List requestClassList = [];
  TextEditingController commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    classList();
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
            appBar: AppBar(
              backgroundColor: AppColors.appNewDarkThemeColor,
              leading: IconButton(
                icon: const Icon(Icons.keyboard_backspace,color: Colors.white,),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title:  Text("Requested Private Class List",
                style: TextStyle(fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),),
            ),
            body: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 1.h,right: 1.h,left: 1.h,bottom: 1.h),
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
                  child: loader == false
                      ? Center(
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
                  : requestClassList.length == 0
                      ? Center(
                    child: Text("No Any Request Found! ",
                      style: TextStyle(fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 20.sp),),
                  )
                      : ListView.separated(
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context,i){
                        return GestureDetector(
                          child: Container(
                              margin: EdgeInsets.only(top: 1.h,bottom: 1.h),
                              padding: EdgeInsets.all(1.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  border: Border.all(width: .5,color: Colors.black54)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("${requestClassList[i].topic}",
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(fontSize: 14.sp),),
                                                  Text("${DateFormat.yMMMd().format(DateTime.parse(requestClassList[i].updatedAt))}",
                                                    style: TextStyle(fontSize: 8.sp,
                                                        color: Colors.grey,fontWeight: FontWeight.w500),),
                                                ],
                                              ),
                                              Text("${requestClassList[i].description}",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(fontSize: 10.sp,color: Colors.grey),),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("${requestClassList[i].studentName}",style: TextStyle(fontSize: 10.sp,
                                                      color: Colors.grey,fontWeight: FontWeight.bold),),
                                                  Text("${DateFormat.yMMMd().format(DateTime.parse(requestClassList[i].date))},"
                                                      " ${requestClassList[i].time}",
                                                    style: TextStyle(fontSize: 10.sp,
                                                        color: Colors.grey,fontWeight: FontWeight.bold),),
                                                  Text("${requestClassList[i].type}",style: TextStyle(fontSize: 10.sp,
                                                      color: Colors.grey,fontWeight: FontWeight.bold),),
                                                ],
                                              )
                                              // loader == false ? Text("Loading...")
                                              //     :

                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                          ),
                          onTap: (){
                            showDetails(context,requestClassList[i]);
                          },
                        );
                      },
                      separatorBuilder: (_,__)=>SizedBox(width: 1.h,),
                      itemCount: requestClassList.length),
                ),
              ],
            ),
          ),
        )
    );
  }
  void classList() {
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
                ApiRepository().getRequestClassList(value).then((value) {
                  if (value.status == "successfully") {
                    print("Success $value");
                    setState(() {
                      loader = true;
                      requestClassList = value.body;
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

  showDetails(BuildContext cnx, data) {
    print("Daata $data");
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
          return SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.only(top: 10,bottom: 20,left: 20,right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft:Radius.circular(20),
                    topRight: Radius.circular(20),),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 1.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Details of the Class",style: TextStyle(fontSize: 18.sp,),),
                        InkWell(
                          child: Icon(Icons.cancel_outlined,size: 25,),
                          onTap: (){
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                    SizedBox(height: 1.h,),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(text: 'Course Name: ', style: TextStyle(fontSize: 10.sp,
                              color: Colors.black)),
                          TextSpan(text: '${data.topic}',
                            style: TextStyle(color: Colors.black,
                                fontSize: 12.sp,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                    SizedBox(height: 1.h,),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(text: 'Description: ', style: TextStyle(fontSize: 10.sp,
                              color: Colors.black)),
                          TextSpan(text: '${data.description}',
                            style: TextStyle(color: Colors.black,
                                fontSize: 12.sp,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                    SizedBox(height: 1.h,),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(text: 'Date and Time: ', style: TextStyle(fontSize: 10.sp,
                              color: Colors.black)),
                          TextSpan(text: '${DateFormat.yMMMd().format(DateTime.parse(data.date))}, ${data.time}',
                            style: TextStyle(color: Colors.black,
                                fontSize: 12.sp,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                    SizedBox(height: 1.h,),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(text: 'Class Type: ', style: TextStyle(fontSize: 10.sp,
                              color: Colors.black)),
                          TextSpan(text: '${data.type}',
                            style: TextStyle(color: Colors.black,
                                fontSize: 12.sp,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                    SizedBox(height: 1.h,),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(text: 'Sender Name: ', style: TextStyle(fontSize: 10.sp,
                              color: Colors.black)),
                          TextSpan(text: '${data.studentName}',
                            style: TextStyle(color: Colors.black,
                                fontSize: 12.sp,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h,),
                    Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       GestureDetector(
                         child: Card(
                           elevation: 0,
                           color: AppColors.appNewDarkThemeColor,
                           shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(20)
                           ),
                           child: Center(
                               child: Padding(
                                 padding: EdgeInsets.symmetric(vertical: 1.5.h,horizontal: 6.h),
                                 child:
                                 Text("Accept",style:TextStyle(fontSize: 12.sp,
                                     letterSpacing: .5,
                                     color: Colors.white
                                 )),

                               )
                           ),
                         ),
                         onTap: (){
                           //Navigator.pop(context);
                           EasyLoading.showToast("Class Request Accepted.",
                               duration: Duration(seconds: 2),
                               toastPosition: EasyLoadingToastPosition.bottom);

                           scheduleMeet(data.topic, data.description, data.date, data.time);
                           Navigator.pushAndRemoveUntil(context,
                               MaterialPageRoute(builder: (context) => BottomNavbar(index: 4,),),
                                   (route) => false);

                         },
                       ),
                       GestureDetector(
                         child: Card(
                           elevation: 0,
                           color: AppColors.redDarkColor,
                           shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(20)
                           ),
                           child: Center(
                               child: Padding(
                                 padding: EdgeInsets.symmetric(vertical: 1.5.h,horizontal: 6.h),
                                 child:
                                 Text("Reject",style:TextStyle(fontSize: 12.sp,
                                     letterSpacing: .5,
                                     color: Colors.white
                                 )),

                               )
                           ),
                         ),
                         onTap: (){
                           Navigator.pop(context);
                           rejectClass(cnx,data.id);
                         },
                       ),
                     ],
                   ),
                    SizedBox(height: 2.h,),
                  ],
                )
            ),
          );
        });

      },
    );
  }
  rejectClass(BuildContext cnx,var id) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
          return SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.only(top: 10,bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                    left: 20,right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft:Radius.circular(20),
                    topRight: Radius.circular(20),),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 1.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Reason why you Reject ?",style: TextStyle(fontSize: 18.sp,),),
                        InkWell(
                          child: Icon(Icons.cancel_outlined,size: 25,),
                          onTap: (){
                            Navigator.pop(context);
                            commentController.clear();
                          },
                        )
                      ],
                    ),
                    SizedBox(height: 2.h,),
                    Form(
                      key: _formKey,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: .5,color:Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          style:  TextStyle(color: Colors.black,fontSize: 10.sp),
                          autofocus: false,
                          cursorColor: Colors.black,
                          controller: commentController,
                          maxLines: 5,
                          decoration:  InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 2.h,vertical: 1.h),
                            border: InputBorder.none,
                            hintText: 'Reason',
                            hintStyle: TextStyle(color: Colors.grey,fontSize: 10.sp),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter reason here why you are reject this private class!';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h,),
                    GestureDetector(
                      child: Card(
                        elevation: 0,
                        color: AppColors.appNewDarkThemeColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child:
                              Text("Submit",style:TextStyle(fontSize: 12.sp,
                                  letterSpacing: .5,
                                  color: Colors.white
                              )),

                            )
                        ),
                      ),
                      onTap: (){
                        if(_formKey.currentState.validate()){
                          Navigator.pop(context);
                          EasyLoading.showToast("Reject Reason Submitted.",
                              duration: Duration(seconds: 2),
                              toastPosition: EasyLoadingToastPosition.bottom);
                          rejectClassWithReason(id, commentController.text);
                        }
                        else{

                        }

                      },
                    ),
                    SizedBox(height: 2.h,),
                  ],
                )
            ),
          );
        });

      },
    );
  }

  void rejectClassWithReason(var id, String reason) {
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
                ApiRepository().requestClassStatus(
                  token: value,
                  id: id,
                  reason: reason
                ).then((value) {
                  if (value['status'] == "successfully") {
                    print("Success $value");
                    // EasyLoading.showToast("Reject Reason Submitted.",
                    //     duration: Duration(seconds: 2),
                    //     toastPosition: EasyLoadingToastPosition.bottom);
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
  void scheduleMeet(String title, String subject, String date, String time) {
    var repeatable = 0;
    var disable_video = 0;
    var disable_audio = 0;
    print("Data All ${title}, $subject, $date,$time");
    DateTime timer = DateFormat.jm().parse(time);
    DateTime endTimer = DateFormat.jm().parse(time).add(Duration(hours: 1));
    var startTime =  DateFormat("HH:mm").format(timer);
    var endTime =  DateFormat("HH:mm").format(endTimer);
    print("Data $startTime  $endTime");

    Helper.checkConnectivity().then((value) => {
      if (value)
        {
         // EasyLoading.show(),
          PreferenceConnector.getJsonToSharedPreference(
              StringConstant.loginData)
              .then((value) => {
            if (value != null)
              {
                ApiRepository()
                    .createmeeting(
                    title, subject, date, startTime,
                    endTime,repeatable,disable_video,disable_audio, value)
                    .then((value) {
                  EasyLoading.dismiss();
                  if (value != null) {
                    if (value.status == "successfull") {
                      EasyLoading.showToast("Scheduled Your Class On Date and Time.",
                          duration: Duration(seconds: 2),
                          toastPosition: EasyLoadingToastPosition.bottom);

                    } else {
                      EasyLoading.showToast("Something went wrong please logout and login again.",
                          duration: Duration(seconds: 2),
                          toastPosition: EasyLoadingToastPosition.bottom);

                }
                  }
                })
              }
            else
              {
              EasyLoading.showToast("Something went wrong please logout and login again.",
              duration: Duration(seconds: 2),
              toastPosition: EasyLoadingToastPosition.bottom)
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
