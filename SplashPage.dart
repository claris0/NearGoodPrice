import 'package:flutter/material.dart';
import 'package:jejugoodprice/WebViewPage.dart';
import 'package:splash_screen_view/SplashScreenView.dart';


class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateRoute: WebViewPage(),
      duration: 1500,
      imageSize: 320,
      imageSrc: 'assets/images/splash.png',
      text: ("            우주착""\n""우리 주위의 착한 업소"),
      textType: TextType.NormalText,
      textStyle: TextStyle(
        fontSize: 25.0,
      ),
      backgroundColor: Color(0xff9acd32),
    );
  }
}
