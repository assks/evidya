import 'package:cached_network_image/cached_network_image.dart';
import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/lms/cources/student_course_page.dart';
import 'package:evidya/network/repository/api_repository.dart';
import 'package:evidya/resources/app_colors.dart';
import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:evidya/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SubCategory extends StatefulWidget {
  final String catId;
  final String title;
  const SubCategory({this.catId,this.title, Key key}) : super(key: key);

  @override
  State<SubCategory> createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> {

  List catList = [];
 bool loader = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCategoryList();
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
          title: Text("${widget.title}"),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.keyboard_backspace, color: Colors.white,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.only(top: 1.h,left: 1.h,right: 1.h,bottom: 1.h),
                child: Container(
                  height: 100.h,
                  padding: EdgeInsets.only(top: 2.h,left: 2.h,right: 2.h),
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
                      : catList.isEmpty
                      ? Center(
                    child: Text("No Course Found!",style: TextStyle(fontSize: 25.sp,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),),
                  )
                      : GridView.builder(
                      gridDelegate:  SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 20.h,
                          childAspectRatio: 0.6,
                          crossAxisSpacing: 2.h,
                          mainAxisSpacing: 2.h),
                      itemCount: catList.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return InkWell(
                          child: Column(
                            children: [
                              Container(
                                height: 15.h,
                                alignment: Alignment.center,
                                child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(15),
                                          topLeft: Radius.circular(15)
                                      ),
                                      child: CachedNetworkImage(
                                        height: 15.h,
                                        fit: BoxFit.cover,
                                        imageUrl: StringConstant.IMAGE_URL + catList[index].image,
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
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        topLeft: Radius.circular(15)
                                    )),
                              ),
                              Container(
                                height: 8.h,
                                padding: EdgeInsets.only(right: 10,left: 10),
                                alignment: Alignment.center,
                                child: Text(catList[index].name,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 2.1.h,
                                      fontWeight: FontWeight.w700,
                                      color:AppColors.appNewLightThemeColor),),
                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15)
                                    )),
                              )
                            ],
                          ),
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context)=>StudentCoursePage(
                                  subCatId: catList[index].id.toString(),
                                  title: catList[index].name,
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
  void fetchCategoryList() {
    loader = false;
    print("sadfgtegf ${widget.catId}");
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
                ApiRepository().subCategory(value,widget.catId).then((value) {
                  if (value != null) {
                    setState(() {
                      catList = value.body.subcategories;
                      loader = true;
                      print("hello $catList");
                    });
                  } else {
                    Helper.showMessage("null");
                  }
                })
              }
            else
              {
                Helper.showMessage(
                    "Something went wrong please logout and login again.")
              }
          })
        }
      else
        {Helper.showNoConnectivityDialog(context)}
    });
  }
}
