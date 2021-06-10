import 'dart:io';

import 'package:flutter_application_2/screens/drive_integration/secureStorage.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';

const clientID =
    "707137842507-2oitkp4ad34egs0ulkcmpnn2ka7ieqsu.apps.googleusercontent.com";
const clientSecret = "URug-zGFEwtwQY9CenMRD1TO";
//API key: AIzaSyDG510qUhadmq6AZItWgEgLyYll_5cvDoM
const _scopes = [ga.DriveApi.driveFileScope];

class GoogleDrive {
  final storage = SecureStorage();
//Get Authenticated HTTP Client
  Future<http.Client> getHttpClient() async {
    await storage.clear();
    var credentials = await storage.getCredentials();
    if (credentials == null) {
      var authClient = await clientViaUserConsent(
          ClientId(clientID, clientSecret), _scopes, (url) {
        launch(url);
      });
      return authClient;
    } else {
      return authenticatedClient(
          http.Client(),
          AccessCredentials(
              AccessToken(credentials["types"], credentials["data"],
                  DateTime.parse(credentials["expiry"])),
              credentials["refreshToken"],
              _scopes));
    }
  }

  //upload file
  Future upload(File file) async {
    var client = await getHttpClient();
    var drive = ga.DriveApi(client);
    var response = await drive.files.create(
        ga.File()..name = p.basename(file.absolute.path),
        uploadMedia: ga.Media(file.openRead(), file.lengthSync()));
    print(response.toJson());
  }
}
