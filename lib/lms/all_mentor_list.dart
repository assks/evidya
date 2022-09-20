import 'package:cached_network_image/cached_network_image.dart';
import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/lms/mentor_detail_page.dart';
import 'package:evidya/network/repository/api_repository.dart';
import 'package:evidya/resources/app_colors.dart';
import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:evidya/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sizer/sizer.dart';
class AllMentorList extends StatefulWidget {
  const AllMentorList({Key key}) : super(key: key);

  @override
  State<AllMentorList> createState() => _AllMentorListState();
}

class _AllMentorListState extends State<AllMentorList> {
  bool loader = false;
  List allMentor;

  @override
  void initState() {
    // TODO: implement initState
    allMentorList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/back_ground.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.appNewDarkThemeColor,
          leading: Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(Icons.keyboard_backspace,color: Colors.white,),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
          centerTitle: true,
          title: Text("Best Mentor"),
        ),
        body: SafeArea(
          child: Padding(
              padding: EdgeInsets.only(top: 2.h,left: 1.h,right: 1.h),
              child: Container(
                height: 100.h,
                padding: EdgeInsets.only(top: 2.h,left: 2.h,right: 2.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/grey_background.jpg",),
                      fit: BoxFit.cover
                  ),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
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
                    : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 9/15,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20),
                       itemCount: allMentor.length,
                       itemBuilder: (BuildContext ctx, index) {
                      return InkWell(
                        child: Column(
                          children: [
                            Container(
                              height: 15.h,
                              alignment: Alignment.center,
                              child:
                              // Icon(Icons.person,size: 100,),
                              Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        topLeft: Radius.circular(15)
                                    ),
                                    child: CachedNetworkImage(
                                      height: 15.h,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      imageUrl: StringConstant.IMAGE_URL + '${allMentor[index].image}',
                                      placeholder: (context, url) =>
                                          SizedBox(height: 20,width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 1,
                                            ),
                                          ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset("assets/images/bvidhya.png"),
                                    ),
                                  )
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      topLeft: Radius.circular(15)
                                  )),
                            ),
                            Container(
                              height: 15.h,
                              padding: EdgeInsets.only(right: 10,left: 10,top: 5),
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${allMentor[index].name??""}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 13.sp,
                                        fontWeight: FontWeight.w700,
                                        color:AppColors.appNewLightThemeColor),),
                                  Text("${allMentor[index].specialization}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 11.sp,
                                      fontWeight: FontWeight.w600,
                                    ),),
                                  Text("Experience: ${allMentor[index].experience} years",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 10.sp,
                                      fontWeight: FontWeight.normal,
                                    ),),
                                  SizedBox(height: 1.h,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.star,size: 15,color: Colors.yellow,),
                                          SizedBox(width: 5,),
                                          Text("5",
                                            style: TextStyle(fontSize: 10.sp,
                                              fontWeight: FontWeight.normal,
                                            ),),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.reviews_rounded,size: 15,color: AppColors.appNewLightThemeColor,),
                                          SizedBox(width: 5,),
                                          Text("100",
                                            style: TextStyle(fontSize: 10.sp,
                                              fontWeight: FontWeight.normal,
                                            ),),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.thumb_up,size: 15,color: Colors.blue,),
                                          SizedBox(width: 5,),
                                          Text("1.5k",
                                            style: TextStyle(fontSize: 10.sp,
                                              fontWeight: FontWeight.normal,
                                            ),),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15)
                                  ),
                              ),
                            ),
                          ],
                        ),
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context)=>MentorDetailsPage(
                                id: allMentor[index].id.toString(),
                                followed: false,
                              )));
                        },
                      );
                    }),
              )
          )
        ),
      ),
    );
  }

  void allMentorList() {
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
                ApiRepository().getAllMentorList(value).then((value) {
                  if (value != null) {
                    setState(() {
                      allMentor = value.body.instructors;
                      loader = true;
                      print("hello $allMentor");
                    });
                  } else {
                    EasyLoading.showToast("Some went wrong!",
                        toastPosition: EasyLoadingToastPosition.bottom);
                  }
                })
              }
            else
              {
                EasyLoading.showToast(
                    "Something went wrong please logout and login again.",
                    toastPosition: EasyLoadingToastPosition.bottom)
              }
          })
        }
      else
        {Helper.showNoConnectivityDialog(context)}
    });
  }
}
