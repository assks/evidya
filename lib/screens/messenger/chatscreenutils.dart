import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../model/chat_model.dart';

textdocview2(parts) {
  dynamic doclist = parts[2].split('#@#&');
  var value = "";
  if (parts[4] == "doc" || parts[4] == "video") {
    value = doclist[1];
  } else if (parts[4] == "text") {
    value = parts[2];
  }
  return Flexible(
    child: Text(
      value,
      style: TextStyle(
          color: parts[3] != 'send' ? Colors.black : Colors.white,
          fontSize: 16),
      textAlign: TextAlign.left,
    ),
  );
}

textdocview(ChatModel model) {
  // dynamic doclist = parts[2].split('#@#&');
  // var value = "";
  // if (model.type == 'doc' || model.type == 'video') {
  //   value = model.message;
  // } else if (model.type == "text") {
  //   value = model.message;
  // }
  print('Message: ${model.id} ${model.message}');
  return Flexible(
    child: Text(
      model.message,
      style: TextStyle(
          color: model.diraction != 'send' ? Colors.black : Colors.white,
          fontSize: 16),
      textAlign: TextAlign.left,
    ),
  );
}
