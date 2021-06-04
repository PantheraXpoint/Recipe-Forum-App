import 'package:flutter/cupertino.dart';

class Creator {
  int id;
  String username;
  String name;
  String avatarUrl;
  int totalFollower;
  int totalRecipe;

  Creator(
      {@required this.id,
      @required this.username,
      @required this.name,
      @required this.avatarUrl,
      @required this.totalFollower,
      @required this.totalRecipe});

  factory Creator.fromJson(Map json) {
    print("Creator fromJson");
    return Creator(
        id: json['id'],
        username: json['username'],
        name: json['name'],
        avatarUrl: json['photos'][0]['url'],
        totalFollower: json['totalFollower'],
        totalRecipe: json['totalRecipe']);
  }
}
