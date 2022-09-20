import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
class BannerDetails extends StatefulWidget {
  final String bannerImage;
  const BannerDetails({this.bannerImage,Key key}) : super(key: key);

  @override
  State<BannerDetails> createState() => _BannerDetailsState();
}

class _BannerDetailsState extends State<BannerDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/back_ground.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
               backgroundColor: AppColors.appNewDarkThemeColor,
               centerTitle: true,
               title:  Text("My Courses",
                 style: TextStyle(fontSize: 18.sp,
                color: Colors.white,
                ),
              ),
            ),
          body: Container(
            height: 100.h,
            margin: EdgeInsets.all(1.h),
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/grey_background.jpg",),
                  fit: BoxFit.cover
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal:2.h,vertical: 2.h),
                  height: 30.h,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(widget.bannerImage,
                      height: 30.h,
                      fit: BoxFit.cover,
                      width: double.infinity,),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 2.h,right: 2.h,bottom: 2.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text("Free Courses",
                           style: TextStyle(fontSize: 18.sp,
                               color: Colors.black,
                               fontWeight: FontWeight.bold),),
                         Row(
                           children: [
                             Icon(Icons.timer_outlined,size: 20,color: Colors.grey,),
                             SizedBox(width: 1.w,),
                             Text("03:22 Min",
                               style: TextStyle(fontSize: 12.sp,
                                 fontWeight: FontWeight.w500,
                                 color:AppColors.appNewDarkThemeColor,),)
                           ],
                         )
                       ],
                     ),
                      SizedBox(height: 1.h,),
                      Text("Description: ",
                        style: TextStyle(fontSize: 13.sp,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),),
                      Text("The reason for this error is because"
                          " I just upgrade my Xcode to version 10.3. "
                          "And after the upgrade, all the iOS simulators "
                          "which I used before have been lost. "
                          "So when I build my iOS app in Xcode, "
                          "it uses the real iOS device, but I do not"
                          " have such real iOS device connected to my Mac computer"
                        "The reason for this error is because"
                        " I just upgrade my Xcode to version 10.3. "
                        "And after the upgrade, all the iOS simulators "
                        "which I used before have been lost. "
                        "So when I build my iOS app in Xcode, "
                        "it uses the real iOS device, but I do not"
                        " have such real iOS device connected to my Mac computer.",
                        style: TextStyle(
                        fontSize: 12.sp,color: Colors.grey,
                      ),),
                      SizedBox(height: 1.h,),
                      Text("Related Videos",
                        style: TextStyle(fontSize: 13.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),),
                      
                    ],
                  ),
                )
              ],
            ),
          ),
         ),
      ),
    );
  }
}
