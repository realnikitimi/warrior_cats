import 'package:flutter/material.dart';
import 'package:warrior_cats/routes/content.dart';
import 'package:warrior_cats/file_storage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Generate Avatar Frame.',
      home: Scaffold(
        body: Center(child: Content(fileStorage: FileStorage())),
      ),
    );
  }
}
