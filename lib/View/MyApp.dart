import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/View/NoteListPage.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: NoteListPage(),
    );
  }
}
