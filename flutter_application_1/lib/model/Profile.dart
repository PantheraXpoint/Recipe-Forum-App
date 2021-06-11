import 'package:flutter/cupertino.dart';

class Profile {
  int id;
  String username;
  String displayName;
  String avatarUrl;
  int totalFollower = 0;
  int totalRecipe;
  List<int> savedIDs;

  Profile(
      {@required this.id,
      @required this.username,
      @required this.displayName,
      @required this.avatarUrl,
      this.totalFollower,
      @required this.totalRecipe,
      this.savedIDs});

  factory Profile.fromJsonCreator(Map json) {
    return Profile(
        id: json['id'],
        username: json['username'],
        displayName: json['name'],
        avatarUrl: json['photos'][0]['url'],
        totalFollower: json['totalFollower'],
        totalRecipe: json['totalRecipe']);
  }

  factory Profile.fromJsonProfile(Map json) {
    return Profile(
        id: json['Id'],
        username: json['UserName'],
        displayName: json['DisplayName'],
        avatarUrl: json['AvatarUrl'],
        totalRecipe: json['TotalRecipes'],
        savedIDs:
            json['Collection'] == null ? [] : json['Collection'].cast<int>());
  }
}
