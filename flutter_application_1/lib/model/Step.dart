import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/constaints.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

class Step {
  String content;
  List<String> listImageUrl;
  List<File> listImageFile;

  Step({@required this.content, this.listImageUrl, this.listImageFile});

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

  Future<Map<String, dynamic>> toJson() async {
    for (File image in listImageFile) {
      var request = http.MultipartRequest(
          "POST", Uri.parse("http://" + BASE_URL + "/image"));
      Map<String, String> headers = {"Content-type": "multipart/form-data"};
      request.files.add(http.MultipartFile(
          'image', image.readAsBytes().asStream(), image.lengthSync(),
          filename: "ok", contentType: MediaType('image', 'jpeg')));
      request.headers.addAll(headers);
      final response = await request.send();
      final String body = await response.stream.bytesToString();
      try {
        if (listImageUrl == null) listImageUrl = [];
        listImageUrl.add(
            "http://" + BASE_URL + "/image/" + json.decode(body)['filename']);
      } catch (e) {
        print("first add\n");
        print(e);
      }
    }
    List<List<Map>> list = [];
    try {
      listImageUrl.forEach((element) {
        list.add([
          {'url': element, 'height': '0', 'width': '0'}
        ]);
      });
    } catch (e) {
      print("second add");
      print(e);
    }

    return {"content": content, "photo": list};
  }
}
