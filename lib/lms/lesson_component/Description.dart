import 'package:evidya/model/courses_modal.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Description extends StatefulWidget {
  final Courses;

  const Description({Key key, this.Courses}) : super(key: key);

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  Courses course;

  @override
  void initState() {
    course = widget.Courses;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 3.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                      Text("Duration: "+course.duration),
                      SizedBox(width:2.w,),
                      Icon(Icons.access_time_rounded),
                    ],
                  ),
                  Divider(color: Colors.green),
                 /* Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Duration: 8 hours"),
                      Icon(Icons.access_time_rounded),
                    ],
                  ),
                  Divider(color: Colors.green),*/
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Text("Level: "+course.level),
                      SizedBox(width:2.w,),
                      Icon(Icons.auto_graph_rounded),
                    ],
                  ),
                  Divider(color: Colors.redAccent),
                 /* Row(
                    children: [
                      Text("Level: Intermediate"),
                      Icon(Icons.auto_graph_rounded),
                    ],
                  ),
                  Divider(color: Colors.redAccent),*/
                ],
              )
            ],
          ),
          SizedBox(
            height: 3.h,
          ),
          Text("Description",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 3.h,
          ),
          Text(course.description),
        ],
      ),
    );
  }
}
