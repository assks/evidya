
import 'package:evidya/constants/color_constant.dart';
import 'package:evidya/model/home.dart';
import 'package:evidya/utils/helper.dart';
import 'package:evidya/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:flick_video_player/flick_video_player.dart';

class VideoDetail extends StatefulWidget {

  //RecordedClasses model;
  VideoDetail({Key key}) : super(key: key);



  @override
  _VideoDetailState createState() => _VideoDetailState();
}

class _VideoDetailState extends State<VideoDetail> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> imageList = [
    "https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80",
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];

  FlickManager flickManager;
  VideoPlayerController _videoController;




  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(videoPlayerController: VideoPlayerController.network("https://bvidyalarge.s3.amazonaws.com/My_Movie_31.mp4"),);
    flickManager.flickVideoManager.addListener(_videoPlayingListener);
   // flickManager.flickVideoManager.addListener(checkVideo);

  }

  @override
  void dispose() {
    flickManager.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            /*BackPressAppBarWithTitle(
                isBackButtonShow: true,
                centerTitle: "Heading",
                backButtonColor: ColorConstant.black,
                titleColor: ColorConstant.black),*/
            FlickVideoPlayer(
                flickManager: flickManager

            ),

            Center(
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: const <Widget>[
                                    Text(
                                      "Dynamic System and differential equations(Class 11th)",
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text("Preeti-Maths Teacher(11th-12th)"),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: IconButton(
                                  icon: const Icon(Icons.share),
                                  color: Colors.black,
                                  onPressed: () {
                                    print("You Pressed the icon!");
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height: getProportionateScreenHeight(20)),
                          const Divider(color: Colors.black),
                          Column(
                            children: <Widget>[
                              const Align(alignment: Alignment.centerLeft),
                              SizedBox(
                                  height:
                                      getProportionateScreenHeight(20)),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: const [
                                Text(
                                  "RECOMMENDED VIDEOS :",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      /*fontWeight: FontWeight. bold*/),
                                ),
                                Text(
                                  "View ALL",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    decoration:
                                        TextDecoration.underline,
                                  ),
                                ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.25,
                                child: Recordedvideo(size),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: const [
                                Text(
                                  "RECOMMENDED MENTOR's :",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      /*fontWeight: FontWeight. bold*/),
                                ),
                                Text(
                                  "View ALL",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    decoration:
                                        TextDecoration.underline,
                                  ),
                                )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.25,
                                child: Bestmentor(),
                              ),
                            ],
                          ),
                          SizedBox(height: getProportionateScreenWidth(10)),
                          // _dontHaveAccount()
                        ])))
          ]),
        )));
  }

  Recordedvideo(Size size) {
    return imageList != null
        ? ListView.builder(
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
                          Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            ]);
          },
          itemCount: imageList.length,
        )
        : Container();
  }

  Widget Bestmentor() {
    return imageList != null
        ? Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            //x`physics: NeverScrollableScrollPhysics(),
            //Optional
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, position) {
              return Wrap(children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      /*imageurl = bestmentor[position].thumbnail.toString();
                mainindex = position;*/
                    });
                    /*Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TeacherProfile(bestmentor[position])));*/
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 8, right: 8, top: 5),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Column(
                          children: [
                            CachedNetworkImage(
                              height:
                                  MediaQuery.of(context).size.height * 0.13,
                              width:
                                  MediaQuery.of(context).size.width * 0.3,
                              fit: BoxFit.fill,
                              imageUrl: imageList[position],
                              placeholder: (context, url) =>
                                  Helper.onScreenProgress(),
                              errorWidget: (context, url, error) =>
                                  new Icon(Icons.error),
                            ),
                            Text("SWETA SHARMA"),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Center(child: Text("MATHS")),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Colors.deepOrangeAccent,
                                ),
                                child: const Center(child: Text('follow')),
                                height: MediaQuery.of(context).size.height *
                                    0.03,
                                width: MediaQuery.of(context).size.width *
                                    0.25,
                              ),
                            )
                          ],
                        )),
                  ),
                ),
              ]);
            },
            itemCount: imageList.length,
          ),
        )
        : Container();
  }

  _videoPlayingListener() async {
    if (flickManager.flickVideoManager.isVideoInitialized) {
      flickManager.flickControlManager.seekTo( const Duration(seconds: 30));
    }
  }

}


