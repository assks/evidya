import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  final FlutterErrorDetails errorDetails;
  final bool isDev;

  const AppErrorWidget({
    Key key,
    @required this.errorDetails,
    this.isDev = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.red)),
          padding: const EdgeInsets.symmetric(horizontal: 30),

        ),
      ),
    );
  }
}