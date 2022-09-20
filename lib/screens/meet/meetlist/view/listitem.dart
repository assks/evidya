import 'package:evidya/constants/color_constant.dart';
import 'package:evidya/model/meet_list__modal.dart';
import 'package:evidya/resources/app_colors.dart';
import 'package:evidya/utils/helper.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class MeetListItem extends StatelessWidget {
  final String userName;
  const MeetListItem({Key key, this.post, this.userName}) : super(key: key);

  final Meetings post;

  @override
  Widget build(BuildContext context) {
    double widthSize = MediaQuery.of(context).size.width;
    return Material(
      color: Colors.transparent,
      child: Wrap(
        children: [
          GestureDetector(
            onTap: () {
              // Helper.showAlert(context, post.name, post.description, post.meetingId, post.startsAt, post.id.toString(),
              //     post.disable_video,
              //     post.disable_audio
              // );
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
                        height: 3.h,width: 3,
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
                            Text(post.name.toString(),
                              style: TextStyle(fontSize: 10.sp,
                                  color: Colors.black,
                                  letterSpacing: .5,
                                  fontWeight: FontWeight.w600),),
                            Text(DateFormat.yMMMd().format(DateTime.parse(post.startsAt.split(" ")[0]))
                                +", "+
                                DateFormat.jm().format(DateTime.parse(post.startsAt.toString())),
                                //+" - " + DateFormat.jm().format(DateTime.parse(post.endsAt.toString())),
                                style: TextStyle(fontSize: 8.sp,
                                    color: Colors.grey,
                                    letterSpacing: .5,
                                    fontWeight: FontWeight.w500)
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: .6.h,horizontal: 2.h),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFF901133),
                                  Color(0xFF5c0e35),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Text("View",style: TextStyle(fontSize: 8.sp,
                              color: Colors.white,
                              letterSpacing: .5,
                              fontWeight: FontWeight.w800),),
                        ),
                        onTap: (){
                          // Helper.showAlert(context, post.name, post.description, post.meetingId, post.startsAt, post.id.toString(),
                          //     post.disable_video,
                          //     post.disable_audio);
                        },
                      )
                    ],
                  )
              ),
          ),
        ],
      ),
    );
  }
}
