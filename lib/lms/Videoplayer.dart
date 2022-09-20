import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../../constants/string_constant.dart';
import '../../network/repository/api_repository.dart';
import '../../sharedpref/preference_connector.dart';
import '../../utils/helper.dart';

class Video_Player extends StatefulWidget {
  final String videourl;
  final String vidoeid;
  final String userid;

  const Video_Player({Key key, this.videourl, this.vidoeid, this.userid}) : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Video_Player> {
  FlickManager flickManager;
 // var videourl="http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4";
  var bvidyademourl="https://bvidyalarge.s3.amazonaws.com/My_Movie_31.mp4";
  var newdemourl="https://bharatarpanet.in/video-slider/1.mp4";

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(videoPlayerController: VideoPlayerController.network(widget.videourl));
    flickManager.flickVideoManager.addListener(_videoPlayingListener);
    const FlickTotalDuration(color: Colors.lightBlueAccent);
    var a=  flickManager.flickVideoManager.videoPlayerValue.position;
    var b= flickManager.flickVideoManager.videoPlayerValue.duration;
    print(a+b);
  }

  @override
  void dispose() {
    flickManager.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlickVideoPlayer(
          flickManager: flickManager,
        preferredDeviceOrientation: [
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft
        ]
      ),
    );
  }

  var oldtime="0:00:00",Secondstimer=0,minTimeer=0;

  _videoPlayingListener() async {
    if (flickManager.flickVideoManager.isVideoInitialized) {
      var a=flickManager.flickVideoManager.videoPlayerValue.position;
      print(a.toString().substring(0,7));
      var  trimtime = a.toString().substring(0,7);
      if(trimtime == oldtime){
        //  print("0");
      }else {
        Secondstimer += 1;
        print(Secondstimer);
      }
      oldtime=trimtime;
      if(Secondstimer>60){
        Secondstimer = 0;
        _recordapi();
        minTimeer++;
      }
    }
  }

  void checkVideo() {
    if (flickManager.flickControlManager.play() != null) {
      // print("play");
    } else if (flickManager.flickControlManager.pause() != null) {
      print("pause");
    }
  }

  void _recordapi() {
    Helper.checkConnectivity().then((value) => {
      if (value)
        {
          PreferenceConnector.getJsonToSharedPreference(
              StringConstant.loginData)
              .then((value) => {
            if (value != null)
              {
                ApiRepository().watch_time(value,widget.userid,widget.vidoeid).then((value) {
                  if (value != null) {
                   // if (value['response'] == "OK") { }
                  }
                })
              }

          })
        }
      else
        {Helper.showNoConnectivityDialog(context)}
    });
  }
}
