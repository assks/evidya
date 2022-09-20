import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sizer/sizer.dart';
import '../../constants/string_constant.dart';
import '../../model/blockuserlist.dart';
import '../../network/repository/api_repository.dart';
import '../../resources/app_colors.dart';
import '../../sharedpref/preference_connector.dart';
import '../../utils/helper.dart';

class Blockuserlist extends StatefulWidget {
  const Blockuserlist({Key key}) : super(key: key);

  @override
  State<Blockuserlist> createState() => _BlockuserlistState();
}

class _BlockuserlistState extends State<Blockuserlist> {
  List<BlockedConnections> blockuserlist = [];
  bool loader = false;
  @override
  void initState() {
    _fetchblockuserlist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.appNewDarkThemeColor,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
              color: Colors.white,
              size: 3.h,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Blocked User List",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 2.5.h)),
        ),
        body: Container(
          margin: EdgeInsets.only(top: 1.h, right: 1.h, left: 1.h, bottom: 1.h),
          padding: EdgeInsets.only(left: 1.h, right: 1.h, top: 1.h),
          height: 100.h,
          width: double.infinity,
          decoration: BoxDecoration(
              image: const DecorationImage(
                  image: AssetImage(
                    "assets/images/grey_background.jpg",
                  ),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(20)),
          child: loader == false
              ? Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Fetching Data...",
                        style: TextStyle(
                            fontSize: 2.1.h,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                )
              : blockuserlist.length == 0
                  ? Center(
                      child: Text(
                        "No Recent Group List!",
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp),
                      ),
                    )
                  :
                         ListView.separated(
                            itemBuilder: (BuildContext context, int i) {
                              print(StringConstant.BASE_URL +
                                  blockuserlist[i].profileImage);
                              return InkWell(
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: CircleAvatar(
                                                radius: 3.2.h,
                                                backgroundColor: AppColors
                                                    .appNewDarkThemeColor,
                                                child: Center(
                                                    child: blockuserlist[i]
                                                                .profileImage !=
                                                            null
                                                        ? CachedNetworkImage(
                                                            imageUrl: StringConstant
                                                                    .IMAGE_URL +
                                                                blockuserlist[i]
                                                                    .profileImage,
                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  /*colorFilter: const ColorFilter
                                                                            .mode(
                                                                        Colors
                                                                            .red,
                                                                        BlendMode
                                                                            .colorBurn)*/
                                                                ),
                                                              ),
                                                            ),
                                                            height: 30.h,
                                                            width: 40.w,
                                                            placeholder: (context,
                                                                    url) =>
                                                                const CircularProgressIndicator(),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    const Icon(
                                                              Icons.error,
                                                              size: 50,
                                                            ),
                                                          )
                                                        : Text(
                                                            "${blockuserlist[i].name[0]}",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    2.5.h))),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 15),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              blockuserlist[i].name,
                                              style: TextStyle(
                                                  fontSize: 2.1.h,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "${blockuserlist[i].email}",
                                              maxLines: 2,
                                              style: TextStyle(
                                                color: Colors.grey,
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 2.0.h,
                                              ),
                                            ),
                                          ],
                                        )),

                                      ],
                                    ),
                                  ),
                                  onTap: () async {

                                   // Helper.showblockAlert(context, blockuserlist[i].id,blockuserlist[i].name,);
                                  });
                            },
                            separatorBuilder: (_, __) => const Divider(
                                  indent: 10,
                                  endIndent: 10,
                                  height: 1,
                                  thickness: 1,
                                  color: Colors.grey,
                                ),
                            itemCount: blockuserlist.length)


          ///sd
        ));
  }

  void _fetchblockuserlist() {
    loader = false;
    PreferenceConnector.getJsonToSharedPreferencetoken(StringConstant.loginData)
        .then((value) => {
              if (value != null)
                {
                  ApiRepository().blockuserist(value).then((value) {
                    if (mounted) {
                      if (value != null) {
                        setState(() {
                          loader = true;
                        });

                        if (value.status == "successfull") {
                          blockuserlist = value.body.blockedConnections;
                        }
                      } else {
                        EasyLoading.showToast("Some went wrong!",
                            toastPosition:
                            EasyLoadingToastPosition.bottom);
                      }
                    }
                  })
                }
            });
  }
}
