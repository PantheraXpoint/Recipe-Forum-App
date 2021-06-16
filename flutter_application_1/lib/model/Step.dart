import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/apis.dart';

class Step {
  String content;
  List<String> listImageUrl;
  List<File> listImageFile;

  Step({@required this.content, this.listImageUrl, this.listImageFile});

  factory Step.fromJson(Map json) {
    Iterable p = json['photos'];
    if (p != null) {
      return Step(
          content: json['content'],
          listImageUrl: List<String>.from(p.map((e) => e[0]['url'])));
    } else {
      return Step(content: json['content'], listImageUrl: []);
    }
  }

  Future<Map> toJson() async {
    listImageUrl = [];
    for (File image in listImageFile) {
      String url = await APIs.getImageUrl(image);
      listImageUrl.add(url);
    }
    List<List<Map>> list = [];
    listImageUrl.forEach((element) {
      list.add([
        {'url': element, 'height': '0', 'width': '0'},
      ]);
    });

    return {"content": content, "photos": list};
  }
}
