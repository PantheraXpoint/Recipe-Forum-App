import 'dart:convert';

import 'components/constaints.dart';
import 'model/Recipe.dart';
import 'package:http/http.dart' as http;

class APIs {
  static Map<String, String> _headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8'
  };

  static Future<List<Recipe>> getListRecipes() async {
    final response =
        await http.get(Uri.http(BASE_URL, "/recipe"), headers: _headers);
    updateCookie(response);
    if (response.statusCode == 200) {
      Iterable i = json.decode(response.body);
      List<Recipe> list =
          List<Recipe>.from(i.map((e) => Recipe.fromJsonPreview(e)).toList());
      return list;
    }
    return null;
  }

  static Future<bool> login(String email, String password) async {
    Map<String, String> body = {"UserName": email, "PassWord": password};
    final response = await http.post(Uri.http("127.0.0.1:4996", "/login"),
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
    final response = await http.post(Uri.http("127.0.0.1:4996", "/register"),
        headers: _headers, body: json.encode(body));
    updateCookie(response);
    return response.statusCode == 200;
  }

  static Future<Recipe> getRecipeDetail(Recipe recipe) async {
    final response = await http.get(
        Uri.http(BASE_URL, "recipe-detail/${recipe.recipeId}"),
        headers: _headers);
    updateCookie(response);
    if (response.statusCode == 200)
      return Recipe.fromJsonDetail(json.decode(response.body)[0], recipe);
    return null;
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