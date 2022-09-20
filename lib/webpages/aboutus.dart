import 'dart:async';
import 'dart:io';
import 'package:evidya/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutUs extends StatefulWidget {
  final String title;
  const AboutUs({this.title, Key key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return  Container(
        height: size.height,
        decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage("assets/images/blackbackground.jpg"),
        fit: BoxFit.cover,
       ),
      ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
             backgroundColor: AppColors.appNewDarkThemeColor,
              title: Text('${widget.title}'),
              centerTitle: true,
            ),
            body: WebView(
        initialUrl: widget.title =="Privacy Policy"
            ? 'https://bvidyanew.websites4demo.com/privacy-policy-webview'
            : 'https://bvidyanew.websites4demo.com/terms-of-use-webview',
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    ),
    );
  }
}
