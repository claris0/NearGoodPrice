import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'SplashPage.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

if (Platform.isAndroid) {
  await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
}
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: LoadingPage(),
    );
  }
}
