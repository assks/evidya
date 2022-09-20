import 'dart:convert';

import 'package:evidya/constants/color_constant.dart';
import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/model/course_modal.dart';
import 'package:evidya/model/login/PrefranceData.dart';
import 'package:evidya/network/repository/api_repository.dart';
import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:evidya/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:custom_progress_dialog/custom_progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../widget/back_toolbar_with_center_title.dart';
import '../courses_details.dart';
import 'courses_bloc.dart';
import 'courses_event.dart';
import 'courses_list.dart';
import 'courses_state.dart';

class Courses_Screen extends StatefulWidget {
  final String id;
  const Courses_Screen({Key key, this.id,}) : super(key: key);

  @override
  _Courses_ScreenState createState() => _Courses_ScreenState();
}

class _Courses_ScreenState extends State<Courses_Screen> {
  ProgressDialog _progressDialog = ProgressDialog();
  List<Courses> courses;
  dynamic profileJson;
  var Logindata;
  bool network = true;


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: BackPressAppBarWithTitle(
          isBackButtonShow: true,
          centerTitle: "Courses",
          backButtonColor: ColorConstant.black,
          titleColor: ColorConstant.black),
      body: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: networkcheck(),
                ),
                Container(
                    child: Helper.checkConnectivity() != true
                        ? BlocProvider(
                      create: (_) => Courses_Bloc(httpClient: http.Client()/*,id: widget.id*/)
                        ..add(courselistFetched()),
                      child: CoursesList(),
                    )
                        : const Text("Please check your internet "))
              ],
            ),
          )),
    );


  }

  networkcheck() {
    Helper.checkConnectivity().then((value) => {
      if (value)
        {network = true}
      else
        {Helper.showNoConnectivityDialog(context), network = false}
    });
  }

   courseslist(Size size) {
     BlocBuilder<Courses_Bloc, Courses_State>(
        builder: (context, state) {
          switch (state.status) {
            case CoursesStatus.failure:
              return  Center(child: Text('failed to fetch posts'));
            case CoursesStatus.success:
              if (state.posts.isEmpty) {
                return  Center(child: Text('no posts'));
              }

            return null;/*_courses_list(state);*/
            default:
              return const Center(child: CircularProgressIndicator());
          }
        }

    );
  }

  void getCourses(var id) {
    Helper.checkConnectivity().then((value) =>
    {
      if (value)
        {
          _progressDialog.showProgressDialog(context),
          PreferenceConnector.getJsonToSharedPreference(
              StringConstant.Userdata)
              .then((value) =>
          {
            if (value != null)
              {
                profileJson = jsonDecode(value.toString()),
                setState(() {
                  Logindata = PrefranceData.fromJson(profileJson);
                }),
                ApiRepository()
                    .getcourses(Logindata.authToken, id)
                    .then((value) {
                  _progressDialog.dismissProgressDialog(context);
                  if (value != null) {
                    if (value.status == "successfull") {
                      setState(() {
                        courses = value.body.courses;
                      });
                    } else {
                      Helper.showMessage(
                          "Something went wrong please logout and login again.");
                    }
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

  Widget _courses_list(Courses_State state) {
    return state.posts.length != null
        ? Container(
        child: GridView.count(
            crossAxisCount: 1,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: List.generate(courses.length, (index) {
              return GridTile(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    color: Colors.white,/*_randomColor
                              .randomColor(
                                colorBrightness: ColorBrightness.veryLight,
                              ).withOpacity(0.3),*/

                    child: GestureDetector(

                      onTap: () {

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Course_Detail_Screen(course: courses[index])));
                      },
                      child: Padding(
                        padding:
                        const EdgeInsets.only(left: 8, right: 8, top: 5),
                        /*child: Container(
                          height: MediaQuery.of(context).size.height * 0.19,
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20.0, bottom: 20),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(80),
                                    child: CachedNetworkImage(
                                      height:
                                      MediaQuery.of(context).size.height * 0.07,
                                      width:
                                      MediaQuery.of(context).size.width * 0.2,
                                      fit: BoxFit.fill,
                                      imageUrl:
                                      "https://bvidya.websites4demo.com/" +
                                          *//*courses[index].image.toString(),*//*
                                          state.posts[index].image.toString(),
                                      placeholder: (context, url) =>
                                          Helper.onScreenProgress(),
                                      errorWidget: (context, url, error) =>
                                      new Icon(Icons.error),
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.4,
                                    child: Text(
                                      *//*courses[index].name,*//*
                                        state.posts[index].name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    )),
                              ),

                            ],
                          ),
                        ),*/
                      ),
                    ),
                  ),
                ),
              );
            })))
        : Container(
      child: const Text("No Data found"),    );
  }
}
