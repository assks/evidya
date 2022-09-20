import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/string_constant.dart';
import '../../model/lesson_modal.dart';

class Curriculum extends StatefulWidget {
  final lessonlist;
  const Curriculum({Key key, this.lessonlist}) : super(key: key);
  @override
  State<Curriculum> createState() => _CurriculumState();
}

class _CurriculumState extends State<Curriculum> {
  List<Lessons>  lessonlist;

  @override
  void initState() {
   lessonlist=widget.lessonlist;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.transparent,
    body: SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: lessonlist.length,
        itemBuilder: (context, position) {
          return Wrap(children: [
            GestureDetector(
              child: Card(
                elevation: 2,
                margin: EdgeInsets.all(.5.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal:1.h,vertical: .5.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              height: 7.h,
                              width: 15.w,
                              fit: BoxFit.fill,
                              imageUrl: StringConstant.IMAGE_URL+lessonlist[position].image.toString(),
                              /*placeholder: (context, url) =>
                                      Helper.onScreenProgress(),
                                  errorWidget: (context, url, error) =>
                                  new Icon(Icons.error),*/
                            ),
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.3,
                                  child: Text(lessonlist[position].name.toString(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.3,
                                  child: const Text("3hrs 20min",
                                      style: TextStyle(fontSize: 10)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Icon(Icons.play_circle_filled_outlined,color: Colors.red,size: 40,),

                    ],
                  ),
                )
              ),
            )
          ]);
        },
      ),
    ),
  );


}
