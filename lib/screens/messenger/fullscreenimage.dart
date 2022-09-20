import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';
import '../../resources/app_colors.dart';

class FullScreenImage extends StatefulWidget {
  final dynamic image;
  const FullScreenImage({this.image,Key key}) : super(key: key);

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
var isfile=false;
  @override
  void initState() {
    String httpsstring = widget.image.substring(0,4);
    if(httpsstring=="http") {
      isfile = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold (
       appBar: AppBar(
           backgroundColor: AppColors.appNewDarkThemeColor,
           leading: Align(
             alignment: Alignment.centerLeft,
             child: IconButton(
               icon: const Icon(Icons.keyboard_backspace,color: Colors.white,),
               onPressed: (){
                 Navigator.pop(context);
               },
             ),
           ),
           centerTitle: true,title: const Text("Image")),
       body:
       PhotoView(
     imageProvider:isfile? CachedNetworkImageProvider(widget.image):FileImage(File(widget.image)),
     ));


  }
}
