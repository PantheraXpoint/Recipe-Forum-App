import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'ggDrive.dart';

class FlutterDriveScreen extends StatefulWidget {
  @override
  _FlutterDriveScreenState createState() => _FlutterDriveScreenState();
}

class _FlutterDriveScreenState extends State<FlutterDriveScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Drive',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final drive = GoogleDrive();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Drive Demo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              child: Text("UPLOAD"),
              onPressed: () async {
                FilePickerResult result = await FilePicker.platform.pickFiles();
                var file = File(result.files.single.path);
                drive.upload(file);
              },
            )
          ],
        ),
      ),
    );
  }
}
