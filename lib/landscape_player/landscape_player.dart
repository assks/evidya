import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../../constants/string_constant.dart';
import '../../network/repository/api_repository.dart';
import '../../sharedpref/preference_connector.dart';
import '../../utils/helper.dart';
import 'landscape_player_controls.dart';

class LandscapePlayer extends StatefulWidget {
  final String lessonId;
  final String videourl;
  final String vidoeid;
  final String userid;
  LandscapePlayer({Key key, this. lessonId,
    this.videourl,
    this.vidoeid,
    this.userid}) : super(key: key);

  @override
  _LandscapePlayerState createState() => _LandscapePlayerState();
}

class _LandscapePlayerState extends State<LandscapePlayer> {
  FlickManager flickManager;
  var oldtime="0:00:00",Secondstimer=0,minTimeer=0;
  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(videoPlayerController: VideoPlayerController.network(widget.videourl));
    flickManager.flickVideoManager.addListener(_videoPlayingListener);
    const FlickTotalDuration(color: Colors.lightBlueAccent);
    var a=  flickManager.flickVideoManager.videoPlayerValue.position;
    var b= flickManager.flickVideoManager.videoPlayerValue.duration;
    print(a+b);
    lessonProgress(widget.lessonId);
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }
  void lessonProgress(var lessonId) {
    Helper.checkConnectivity().then((value) =>
    {
      if (value)
        {
          PreferenceConnector.getJsonToSharedPreference(
              StringConstant.loginData)
              .then((value) =>
          {
            if (value != null)
              {
                ApiRepository().progressLesson(value,lessonId.toString()).then((value) {
                  if (value.status == "successfully") {

                  } else {
                  }
                })
              }
            else
              {
              }
          })
        }
      else
        {Helper.showNoConnectivityDialog(context)}
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlickVideoPlayer(
        flickManager: flickManager,
        preferredDeviceOrientation: [
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft
        ],
        systemUIOverlay: [],
        flickVideoWithControls: FlickVideoWithControls(
          controls: LandscapePlayerControls(),
        ),
      ),
    );
  }
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