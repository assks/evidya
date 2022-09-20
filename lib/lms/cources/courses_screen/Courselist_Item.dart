import 'package:evidya/model/course_modal.dart';
import 'package:flutter/material.dart';

import '../courses_details.dart';

class CourseList_Item extends StatefulWidget {
  const CourseList_Item({Key key,this.post}) : super(key: key);
  final Courses post;

  @override
  _CourseList_ItemState createState() => _CourseList_ItemState();
}

class _CourseList_ItemState extends State<CourseList_Item> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Wrap(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Course_Detail_Screen(
                    course: widget.post,
                  )));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              widget.post.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.more_vert_outlined,
                        size: 20.0,
                        color: Colors.grey,
                      ),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
