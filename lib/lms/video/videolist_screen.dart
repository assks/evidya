import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/lms/lession.dart';
import 'package:evidya/resources/app_colors.dart';
import 'package:evidya/utils/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sizer/sizer.dart';

import '../videodetail_screen.dart';

class VideoList extends StatefulWidget {
  final String title;
  final dynamic data;
  const VideoList({this.title,this.data,Key key}) : super(key: key);

  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
   List bestVideos = [];
  @override
  void initState() {
    // TODO: implement initState
    bestVideos = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
          title: Text("${widget.title}"),
        ),
        body: SafeArea(
          child: Container(
            height: 100.h,
            margin: EdgeInsets.only(top: 1.h,left: 1.h,right: 1.h),
            width: double.infinity,
            decoration: BoxDecoration(
            image: DecorationImage(
            image: AssetImage("assets/images/grey_background.jpg",),
            fit: BoxFit.cover
            ),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),
            topRight: Radius.circular(20)),
            ),
            child: getVideos()
          ),
        ),
      ),
    );
  }

  Widget getVideos() {
    return bestVideos != null
        ?  Container(
              height: 100.h,
              margin: EdgeInsets.only(top: 1.h,left: 1.h,right: 1.h),
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/grey_background.jpg",),
                    fit: BoxFit.cover
                ),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
           child: ListView.separated(
          separatorBuilder: (_,__)=>Divider(height: 10,thickness: 1.5,),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          // Optional
          scrollDirection: Axis.vertical,
          itemBuilder: (context, position) {
            return Wrap(children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => Lesson(
                      catList:widget.data[position].id,
                      catImage : widget.data[position].image,
                      catName :widget.data[position].name,
                      catDescription :widget.data[position].description,
                      duration: widget.data[position].duration,
                      instructorName: widget.data[position].instructorName,
                      instructorImage : widget.data[position].instructorImage,
                      language: widget.data[position].language,
                      level:widget.data[position].level)));
                },
                child: Row(
                  children: <Widget>[
                    Stack(
                        children: <Widget>[
                          ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                height: MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width * 0.4,
                                fit: BoxFit.cover,
                                imageUrl:
                                StringConstant.IMAGE_URL+ widget.data[position].image.toString(),
                                placeholder: (context, url) =>
                                    Helper.onScreenProgress(),
                                errorWidget: (context, url, error) =>
                                new Icon(Icons.error),
                              )),
                          Positioned(
                              right: 3,
                              bottom: 3,
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: AppColors.appNewLightThemeColor,
                                child: Icon(Icons.play_arrow,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ))
                        ]),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(1.h),
                       child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.data[position].name}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.sp),
                          ),
                          Text(
                            "Level : ${widget.data[position].level}",
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 12.sp, color: Colors.black54),
                          ),
                          Text(
                            "Language: ${widget.data[position].language}",

                            style: TextStyle(fontSize: 10.sp),
                          ),
                          SizedBox(height: 1.h,),
                          SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.timer_outlined, color: Colors.black,size: 15,),
                                Text(
                                  " ${widget.data[position].duration} hr",
                                  style: TextStyle(fontSize: 10.sp),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    )
                  ],
                ),
              ),
            ]);
          },
          itemCount: widget.data.length,
        ),
      )
        : Container();
  }
}
