import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_application_2/model/Profile.dart';

import 'components/constaints.dart';
import 'model/Recipe.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class Session extends ChangeNotifier {
  static Profile profile;
  static List<Recipe> myRecipes;
}

class APIs {
  static Map<String, String> _headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8'
  };

  static Future<List<Recipe>> getListRecipes() async {
    final response =
        await http.get(Uri.http(BASE_URL, "/recipe-detail"), headers: _headers);
    updateCookie(response);
    if (response.statusCode == 200) {
      Iterable i = json.decode(response.body);
      List<Recipe> list =
          List<Recipe>.from(i.map((e) => Recipe.fromJson(e)).toList());
      return list;
    }
    return null;
  }

  static Future<Recipe> getRecipe(int id) async {
    final response = await http.get(Uri.http(BASE_URL, "/recipe-detail/$id"),
        headers: _headers);
    updateCookie(response);
    if (response.statusCode == 200)
      return Recipe.fromJson(json.decode(response.body)[0]);
    return null;
  }

  static Future<int> saveRecipe(int id) async {
    final response = await http
        .put(Uri.http(BASE_URL, "/recipe-detail/$id/save"), headers: _headers);
    updateCookie(response);
    return response.statusCode;
  }

  static Future<int> unsaveRecipe(int id) async {
    final response = await http.put(
        Uri.http(BASE_URL, "/recipe-detail/$id/unsave"),
        headers: _headers);
    updateCookie(response);
    return response.statusCode;
  }

  static Future<bool> login(String email, String password) async {
    Map<String, String> body = {"UserName": email, "PassWord": password};
    final response = await http.post(Uri.http(BASE_URL, "/login"),
        headers: _headers, body: json.encode(body));
    updateCookie(response);
    return response.statusCode == 200;
  }

  static Future<bool> signup(
      String username, String password, String display) async {
    Map<String, String> body = {
      "UserName": username,
      "PassWord": password,
      "DisplayName": display
    };
    final response = await http.post(Uri.http(BASE_URL, "/register"),
        headers: _headers, body: json.encode(body));
    updateCookie(response);
    return response.statusCode == 200;
  }

  static Future<Profile> getMyProfile() async {
    final response =
        await http.get(Uri.http(BASE_URL, "/myprofile"), headers: _headers);
    updateCookie(response);
    if (response.statusCode == 200)
      return Profile.fromJsonProfile(json.decode(response.body));
    return null;
  }

  static Future<Profile> getProfile(String username) async {
    final response = await http.get(Uri.http(BASE_URL, "/account/$username"),
        headers: _headers);
    updateCookie(response);
    if (response.statusCode == 200)
      return Profile.fromJsonProfile(json.decode(response.body)[0]);
    return null;
  }

  static Future<int> editProfile(
      String display, String newPwd, String url, String confirm) async {
    Map<String, String> body = {"PassWord": confirm};
    if (display.length != 0) body.addAll({"DisplayName": display});
    if (newPwd.length != 0) body.addAll({"NewPassWord": newPwd});
    if (url.length != 0) body.addAll({"AvatarUrl": url});

    if (body.length > 1) {
      final response = await http.put(Uri.http(BASE_URL, "/myprofile/edit"),
          headers: _headers, body: json.encode(body));
      updateCookie(response);
      return response.statusCode;
    }
    return -1;
  }

  static Future<List<Recipe>> getProfileRecipe(String username) async {
    final response = await http.get(
        Uri.http(BASE_URL, "/account/$username/recipe"),
        headers: _headers);
    updateCookie(response);
    if (response.statusCode == 200) {
      Iterable i = json.decode(response.body);
      List<Recipe> list =
          List<Recipe>.from(i.map((e) => Recipe.fromJson(e)).toList());
      return list;
    }
    return null;
  }

  static Future<String> getImageUrl(File image) async {
    var request = http.MultipartRequest(
        "POST", Uri.parse("http://" + BASE_URL + "/image"));
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    request.files.add(http.MultipartFile(
        'image', image.readAsBytes().asStream(), image.lengthSync(),
        filename: "ok", contentType: MediaType('image', 'jpeg')));
    request.headers.addAll(headers);
    final response = await request.send();
    final String body = await response.stream.bytesToString();
    return "http://" + BASE_URL + "/image/" + json.decode(body)['filename'];
  }

  static Future<String> postRecipeDetail(Recipe recipe) async {
    final body = json.encode(await recipe.toJson());
    final response = await http.post(Uri.http(BASE_URL, "/recipe-detail"),
        body: body, headers: _headers);
    updateCookie(response);
    return response.body;
  }

  static Future<List<Recipe>> searchRecipe(String query) async {
    final response = await http.get(
        Uri.http(BASE_URL, "/recipe/search", {'name': query}),
        headers: _headers);
    if (response.statusCode == 200) {
      Iterable i = json.decode(response.body);
      List<Recipe> list =
          List<Recipe>.from(i.map((e) => Recipe.fromJson(e)).toList());
      return list;
    }
    return null;
  }

  static Future<int> deleteRecipe(int id) async {
    final response = await http.delete(Uri.http(BASE_URL, "/recipe-detail/$id"),
        headers: _headers);
    updateCookie(response);
    return response.statusCode;
  }

  static Future<int> deleteAccount(String confirm) async {
    final response = await http.delete(Uri.http(BASE_URL, "/myprofile/delete"),
        headers: _headers, body: json.encode({'PassWord': confirm}));
    updateCookie(response);
    return response.statusCode;
  }

  static Future<int> logout() async {
    final response =
        await http.get(Uri.http(BASE_URL, "/logout"), headers: _headers);
    updateCookie(response);
    print(response.body);
    return response.statusCode;
  }

  static void updateCookie(http.Response response) {
    String rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      _headers['cookie'] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }
}
