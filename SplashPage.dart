import 'package:flutter/material.dart';
import 'package:jejugoodprice/WebViewPage.dart';
import 'package:splash_screen_view/SplashScreenView.dart';


class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int logoSize = (MediaQuery.of(context).size.width).round();
    return SplashScreenView(
      navigateRoute: WebViewPage(),
      duration: 1500,
      imageSize: logoSize,
      imageSrc: 'assets/images/logo.png',
      textStyle: TextStyle(
        fontSize: 25.0,
      ),
      textType: TextType.NormalText,
      backgroundColor: Color(0xff9acd32),
    );
  }
}
