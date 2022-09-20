import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/network/repository/api_repository.dart';
import 'package:evidya/resources/app_colors.dart';
import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:evidya/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
class HistoryPage extends StatefulWidget {
  final String title;
  const HistoryPage({this.title, Key key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List historyData = [];
  bool loader = false;
  @override
  void initState() {
    // TODO: implement initState
    if(widget.title =="Meeting"){
      historyList();
    } else{
      broadCastHistory();
    }

    super.initState();
  }
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
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.appNewDarkThemeColor,
          title: Text("History"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Container(
            height: 100.h,
            margin: EdgeInsets.only(left: 1.h,right: 1.h,top: 1.h,bottom: 1.h),
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/grey_background.jpg",),
                  fit: BoxFit.cover
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding:  EdgeInsets.symmetric(vertical: 2.h,horizontal: 4.h,),
              child: loader == true
                  ? historyData.isEmpty
                  ? Center(
                  child:  Text("No History Found!",style: TextStyle(fontSize: 25.sp,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),)
              )
                  : ListView.separated(
                //physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Material(
                    color: Colors.transparent,
                    child: Wrap(
                      children: [
                        GestureDetector(
                          onTap: () {

                          },
                          child: Container(
                              padding: const EdgeInsets.only(top: 15,bottom: 15,left: 0,right: 20),
                              decoration:  BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 10,
                                        offset: Offset(-1,1),
                                        color: Colors.grey.shade400
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    height: 4.h,width: 3,
                                    decoration: BoxDecoration(
                                        color: const Color(0xFFf02b25),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                  ),
                                  SizedBox(width: 20,),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:  [
                                        Text(historyData[index].name.toString(),
                                          style: TextStyle(fontSize: 12.sp,
                                              color: Colors.black,
                                              letterSpacing: .5,
                                              fontWeight: FontWeight.w600),),
                                        Text(DateFormat.yMMMd().format(DateTime.parse(historyData[index].startTime.split(" ")[0]))
                                            +", "+
                                            DateFormat.jm().format(DateTime.parse(historyData[index].startTime.toString()))
                                            +" - " + DateFormat.jm().format(DateTime.parse(historyData[index].endTime.toString())),
                                            style: TextStyle(fontSize: 10.sp,
                                                color: Colors.grey,
                                                letterSpacing: .5,
                                                fontWeight: FontWeight.w500)
                                        )
                                      ],
                                    ),
                                  ),
                                  // GestureDetector(
                                  //   child: Container(
                                  //     padding: EdgeInsets.symmetric(vertical: .6.h,horizontal: 2.h),
                                  //     decoration: BoxDecoration(
                                  //         gradient: LinearGradient(
                                  //           begin: Alignment.topCenter,
                                  //           end: Alignment.bottomCenter,
                                  //           colors: [
                                  //             AppColors.appNewLightThemeColor,
                                  //             AppColors.appNewDarkThemeColor
                                  //           ],
                                  //         ),
                                  //         borderRadius: BorderRadius.circular(20)
                                  //     ),
                                  //     child: Text("View",style: TextStyle(fontSize: 8.sp,
                                  //         color: Colors.white,
                                  //         letterSpacing: .5,
                                  //         fontWeight: FontWeight.w800),),
                                  //   ),
                                  //   onTap: (){
                                  //
                                  //   },
                                  // )
                                ],
                              )
                          ),
                        ),
                      ],
                    ),
                  );
                },
                      itemCount: historyData.length,
                      separatorBuilder: (BuildContext context, int index)=>
                          SizedBox(height: 2.h,),
              )
                  : Center(
                    child:  Row(
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
              ),
            ),
          ),
        ),
      ),
    );
  }
  void historyList() {
    loader = false;
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
                ApiRepository().history(value).then((value) {
                  if (value != null) {
                    setState(() {
                      historyData = value.body.histories;
                      loader = true;
                      print("hello $historyData");
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
  void broadCastHistory() {
    loader = false;
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
                ApiRepository().historyBoardCast(value).then((value) {
                  if (value != null) {
                    setState(() {
                      historyData = value.body.histories;
                      loader = true;
                      print("hello $historyData");
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
