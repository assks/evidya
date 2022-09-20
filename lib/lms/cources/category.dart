import 'package:cached_network_image/cached_network_image.dart';
import 'package:evidya/constants/color_constant.dart';
import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/lms/cources/sub_category.dart';
import 'package:evidya/model/catogary.dart';
import 'package:evidya/network/repository/api_repository.dart';
import 'package:evidya/resources/app_colors.dart';
import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:evidya/utils/helper.dart';
import 'package:evidya/utils/size_config.dart';
import 'package:evidya/widget/back_toolbar_with_center_title.dart';
import 'package:flutter/material.dart';
import 'package:custom_progress_dialog/custom_progress_dialog.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sizer/sizer.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  ProgressDialog _progressDialog = ProgressDialog();

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
    final size = MediaQuery
        .of(context)
        .size;
    return Container(
      height: size.height,
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
          title: Text("Categories"),
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
                      : ListView.separated(itemBuilder: (context, i) {
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                offset: Offset(-1, 1),
                                color: Colors.grey.shade400
                            ),
                          ],
                          color: Colors.white
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 1.h, vertical: 1.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 7.h,
                                  width: 15.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        width: 1, color: Colors.white),
                                    color: Colors.white,),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      height: 7.h,
                                      width: 15.w,
                                      fit: BoxFit.cover,
                                      imageUrl: StringConstant.IMAGE_URL + catList[i].image,
                                      placeholder: (context, url) =>
                                          SizedBox(height: 20,width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 1,
                                            ),
                                          ),
                                      errorWidget: (context, url, error) =>
                                       Image.asset("assets/images/bvidhya.png"),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 2.h,),
                                Text("${catList[i].name}", style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                ),),
                              ],
                            ),
                            InkWell(
                              child: Container(
                                padding:EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      AppColors.addedColor,
                                      AppColors.addedColor,
                                    ],
                                  ),
                                ),
                                child:Icon(Icons.arrow_forward_ios_sharp,
                                    color: AppColors.appNewDarkThemeColor,
                                    size:15
                                ),
                              ),
                              onTap: (){
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context)=>SubCategory(
                                      catId: catList[i].id.toString(),
                                      title: catList[i].name,
                                    )));
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  },
                      separatorBuilder: (_, __) => SizedBox(height: 2.h,),
                      itemCount: catList.length),
                )
            )
        ),
      ),
    );
  }
  void fetchCategoryList() {
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
                ApiRepository().category(value).then((value) {
                  if (value != null) {
                    setState(() {
                      catList = value.body.categories;
                      loader = true;
                      print("Hello value $value");
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
