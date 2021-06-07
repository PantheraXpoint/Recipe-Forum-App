import 'package:flutter/cupertino.dart';

class Profile {
  int id;
  String username;
  String displayName;
  String avatarUrl;
  String password;
  int totalRecipes;

  Profile(
      {@required this.id,
      @required this.username,
      @required this.displayName,
      @required this.avatarUrl,
      @required this.password,
      @required this.totalRecipes});

  factory Profile.fromJson(Map json) {
    print("Profile fromJson");
    return Profile(
        id: json['Id'],
        username: json['UserName'],
        displayName: json['DisplayName'],
        avatarUrl: json['AvatarUrl'],
        password: json['PassWord'],
        totalRecipes: json['TotalRecipes']);
  }
}
