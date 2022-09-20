import 'package:evidya/constants/color_constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/model/home.dart';


import 'package:evidya/utils/helper.dart';
import 'package:evidya/utils/size_config.dart';
import 'package:evidya/widget/back_toolbar_with_center_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TeacherProfile extends StatefulWidget {
  // BestInstructors model;

  TeacherProfile();

  @override
  _TeacherProfileState createState() => _TeacherProfileState();
}

class _TeacherProfileState extends State<TeacherProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool pressGeoON = false;
  bool cmbscritta = false;

  final List<String> imageList = [
    "https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80",
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];

  final List<Map> details = [
    {
      "date": "16th december 2021",
      "time": "10:00am to 12:00am ",
      "class": "class 12th",
      "topic": "Physics || Solar",
    },
    {
      "date": "16th december 2021",
      "time": "4:00pm to 5:00pm",
      "class": "class 12th",
      "topic": "Physics || motion",
    },
    {
      "date": "17th december 2021",
      "time": "10:00am to 12:00am",
      "class": "class 12th",
      "topic": "Physics || gravity",
    },
    {
      "date": "17th december 2021",
      "time": "03:00pm to 04:00pm",
      "class": "class 12th",
      "topic": "chemistry || chemical",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                BackPressAppBarWithTitle(
                    isBackButtonShow: true,
                    centerTitle: "",
                    backButtonColor: ColorConstant.black,
                    titleColor: ColorConstant.black),
                Container(
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        height: MediaQuery.of(context).size.height * 0.20,
                        width: MediaQuery.of(context).size.width * 0.4,
                        fit: BoxFit.fill,
                        imageUrl: StringConstant.IMAGE_URL +"users/default.png",
                        placeholder: (context, url) =>
                            Helper.onScreenProgress(),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                Center(
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text("Chemistry (11th - 12th) || CBSE "),
                              Container(
                                  child: Center(
                                    child: const Text(
                                        "7+ year of experiance chemistry NEET chemistry bouble solving",textAlign: TextAlign.center,),
                                  ),
                              ),
                              SizedBox(
                                  height:
                                  getProportionateScreenHeight(20)),
                             const Text(' ❤ 34 followers' ,style: TextStyle(fontWeight: FontWeight. bold)),
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    Align(alignment: Alignment.centerLeft),
                                    SizedBox(
                                        height:
                                            getProportionateScreenHeight(30)),
                                    heading(size),
                                    SizedBox(
                                        height:
                                            getProportionateScreenHeight(30)),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Container(
                                          child: Row(
                                            children: const [
                                              Text(
                                                "Upcoming Classes :",
                                                textAlign: TextAlign.start,style: TextStyle(fontWeight: FontWeight. bold),
                                              ),
                                            ],
                                          )),
                                    ),

                                    SizedBox(
                                      height: size.height * 0.12,
                                      child: upcommingclasses(size),
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(30),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Container(
                                          child: Row(
                                        children: const [
                                          Text(
                                            "Recorded Sessions :",
                                            textAlign: TextAlign.start,style: TextStyle(fontWeight: FontWeight. bold),
                                          ),
                                        ],
                                      )),
                                    ),
                                    SizedBox(
                                      height: size.height * 0.23,
                                      child: Recordedvideo(size),
                                    ),

                                    SizedBox(
                                        height:
                                            getProportionateScreenHeight(30)),
                                    SizedBox(
                                      height: size.height * 0.10,
                                      child: _SubscriptionButton(size),
                                    ),

                                  ],
                                ),
                              ),
                              SizedBox(height: getProportionateScreenWidth(20)),
                              // _dontHaveAccount()
                            ])))
              ])),
        )));
  }

  Widget heading(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[

           Container(

             child: FlatButton(
                 shape: new RoundedRectangleBorder(
                     borderRadius: new BorderRadius.circular(18.0)),
                 color: pressGeoON ? Colors.blue : Colors.red,
                 textColor: Colors.white,
                 child: cmbscritta ? Text("Follow") : Text("Unfollow"),
                 //    style: TextStyle(fontSize: 14)
                 onPressed: () {
                   setState(() {
                     pressGeoON = !pressGeoON;
                     cmbscritta = !cmbscritta;
                   });
                 }
             ),
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.80,
          ),

      ],
    );
  }

  upcommingclasses(Size size) {
    return details != null
        ? Container(
            /*child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),*/
              child: ListView.builder(
                shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(),
                // Optional
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, position) {
                  return Wrap(children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          /*imageurl = bestvideos[position].thumbnail.toString();
                    mainindex = position;*/
                        });
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.all(15),
                          child: Column(children: <Widget>[
                            Text(
                              details[position]['date'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, color: Colors.deepOrangeAccent),
                            ),
                            Text(
                              details[position]['time'],
                              /*style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),*/
                            ),
                            Text(
                              details[position]['topic'],
                              /*style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),*/
                            )
                          ]),
                        ),
                      ),
                    ),
                  ]);
                },
                itemCount: details.length,
              ),

          )
        : Container();
  }

  Recordedvideo(Size size) {
    return imageList != null
        ? Container(
            child: ListView.builder(
              shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              // Optional
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, position) {
                return Wrap(children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        /*imageurl = bestvideos[position].thumbnail.toString();
                  mainindex = position;*/
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width * 0.4,
                          fit: BoxFit.fill,
                          imageUrl: imageList[position],
                          placeholder: (context, url) =>
                              Helper.onScreenProgress(),
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                ]);
              },
              itemCount: imageList.length,
            ),
          )
        : Container();
  }

  _SubscriptionButton(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[

        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.green,
          ),
          child: const Center(child: Text('GET FREE Subscription',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),)),
          height: MediaQuery.of(context).size.height * 0.05,
          width: MediaQuery.of(context).size.width * 0.80,
        ),
        Text("SEE HOW SUBSCRIPTION WORK > ",style: TextStyle(fontSize: 10),)

      ],
    );


  }
}
