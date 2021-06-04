import 'package:flutter/material.dart';

class Step {
  String content;
  List<String> listImageUrl;

  Step({@required this.content, @required this.listImageUrl});

  factory Step.fromJson(Map json) {
    print("Step fromJson");
    Iterable p = json['photos'];
    if (p != null) {
      return Step(
          content: json['content'],
          listImageUrl: List<String>.from(p.map((e) {
            print((e[0]['url']));
            return e[0]['url'];
          })));
    } else {
      return Step(content: json['content'], listImageUrl: []);
    }
  }
}
