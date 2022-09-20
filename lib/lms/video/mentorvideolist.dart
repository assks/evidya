import 'package:evidya/utils/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MentorVideoList_Screen extends StatefulWidget {
  const MentorVideoList_Screen({Key key}) : super(key: key);

  @override
  _MentorVideoList_ScreenState createState() => _MentorVideoList_ScreenState();
}

class _MentorVideoList_ScreenState extends State<MentorVideoList_Screen> {
  final List<Map> bestvideos = [
    {
      "image":
      "https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80",
      "time": "10:00am to 12:00am ",
      "class": "class 12th",
      "topic": "Physics || Solar",
    },
    {
      "image":
      "https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80",
      "time": "4:00pm to 5:00pm",
      "class": "class 12th",
      "topic": "Physics || motion",
    },
    {
      "image":
      "https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80",
      "time": "10:00am to 12:00am",
      "class": "class 12th",
      "topic": "Physics || gravity",
    },
    {
      "image":
      "https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80",
      "time": "03:00pm to 04:00pm",
      "class": "class 12th",
      "topic": "chemistry || chemical",
    },
    {
      "image":
      "https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80",
      "time": "03:00pm to 04:00pm",
      "class": "class 12th",
      "topic": "chemistry || chemical",
    },
    {
      "image":
      "https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80",
      "time": "10:00am to 12:00am",
      "class": "class 12th",
      "topic": "Physics || gravity",
    },
    {
      "image":
      "https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80",
      "time": "10:00am to 12:00am",
      "class": "class 12th",
      "topic": "Physics || gravity",
    },
    {
      "image":
      "https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80",
      "time": "4:00pm to 5:00pm",
      "class": "class 12th",
      "topic": "Physics || motion",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: Padding(
                    child: Image.asset(
                      'assets/icons/back_icon.png',
                    ),
                    padding: EdgeInsets.all(8),
                  ),
                  onPressed: () =>
                      Navigator.of(context).pop(),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text("Videos",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                )
              ],
            ),
            getvideos()
          ],
        ),
      ),
    );
  }

  Widget getvideos() {
    return bestvideos != null
        ? Container(
      child: Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          // Optional
          scrollDirection: Axis.vertical,
          itemBuilder: (context, position) {
            return Wrap(children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    /*imageurl = bestvideos[position].image.toString();
                    mainindex = position;*/
                  });

                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 5),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              height: MediaQuery.of(context).size.height * 0.14,
                              width: MediaQuery.of(context).size.width * 0.3,
                              fit: BoxFit.fill,
                              imageUrl:
                              bestvideos[position]['image'].toString(),
                              placeholder: (context, url) =>
                                  Helper.onScreenProgress(),
                              errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  child: Text(
                                    "competitive course on electromagnetic Waves",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  )),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  child: Text(
                                    "In this cource manisha will cover a topic on electromagnetic Waves",
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black54),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  child: Text(
                                    "Manisha Tejwani",
                                    style: TextStyle(fontSize: 15),
                                  )),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.star, color: Colors.yellow),
                                  Text(
                                    "4.5",
                                    style: TextStyle(fontSize: 15),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]);
          },
          itemCount: bestvideos.length,
        ),
      ),
    )
        : Container();
  }
}
