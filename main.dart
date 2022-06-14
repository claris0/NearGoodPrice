import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'Good Price Jeju',
        home: Scaffold(
            body: WebView(
              initialUrl: "https://claris0.github.io/good-price-jeju/",
              javascriptMode: JavascriptMode.unrestricted,
            )));
  }
}
