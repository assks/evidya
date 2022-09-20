import 'dart:convert';

import 'package:evidya/constants/color_constant.dart';
import 'package:evidya/constants/string_constant.dart';
import 'package:evidya/model/course_modal.dart';
import 'package:evidya/model/login/PrefranceData.dart';
import 'package:evidya/network/repository/api_repository.dart';
import 'package:evidya/sharedpref/preference_connector.dart';
import 'package:evidya/utils/helper.dart';
import 'package:evidya/utils/size_config.dart';
import 'package:evidya/widget/back_toolbar_with_center_title.dart';
import 'package:flutter/material.dart';
import 'package:custom_progress_dialog/custom_progress_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Course_Detail_Screen extends StatefulWidget {
  final Courses course;

  const Course_Detail_Screen({
    Key key,
    this.course,
  }) : super(key: key);

  @override
  _Course_Detail_ScreenState createState() => _Course_Detail_ScreenState();
}

class _Course_Detail_ScreenState extends State<Course_Detail_Screen> {
  ProgressDialog _progressDialog = ProgressDialog();
  dynamic profileJson;
  var Logindata;
  List<Courses> lessions;

  @override
  void initState() {
    super.initState();
    _getcoursedetail(widget.course.id);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          BackPressAppBarWithTitle(
              isBackButtonShow: true,
              centerTitle: widget.course.name,
              backButtonColor: ColorConstant.black,
              titleColor: ColorConstant.black),
          SizedBox(height: getProportionateScreenHeight(10)),

          lessionlist(size)
        ],
      ),
    );
  }

  _getcoursedetail(int id) {
    Helper.checkConnectivity().then((value) => {
          if (value)
            {
              _progressDialog.showProgressDialog(context),
              PreferenceConnector.getJsonToSharedPreference(
                      StringConstant.Userdata)
                  .then((value) => {
                        if (value != null)
                          {
                            profileJson = jsonDecode(value.toString()),
                            setState(() {
                              Logindata = PrefranceData.fromJson(profileJson);
                            }),
                            ApiRepository()
                                .getlession(Logindata.authToken, id.toString())
                                .then((value) {
                              _progressDialog.dismissProgressDialog(context);
                              if (value != null) {
                                if (value.status == "successfull") {
                                  setState(() {
                                    lessions = value.body.courses;
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

  lessionlist(Size size) {
    return lessions != null
        ? Container(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, position) {
                return Wrap(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {

                        });
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 8, right: 8, top: 5),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text((position+1).toString()),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                      height:
                                          MediaQuery.of(context).size.height * 0.1,
                                      width:
                                          MediaQuery.of(context).size.width * 0.2,
                                      fit: BoxFit.fill,
                                      imageUrl: StringConstant.IMAGE_URL +
                                          lessions[position].image,
                                      placeholder: (context, url) =>
                                          Helper.onScreenProgress(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.60,
                                        child: Text(lessions[position].name,textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold),)),
                                    SizedBox(height: MediaQuery.of(context).size.width * 0.03,),
                                    SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.60,
                                        child: Text(
                                          lessions[position].description,
                                          style: TextStyle(fontSize: 10),
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
              itemCount: lessions.length,
            ),
          )
        : Container();
  }
}
