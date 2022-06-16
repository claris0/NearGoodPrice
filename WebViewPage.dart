import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'ShowSnackBar.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

Future<bool> locPermission = false as Future<bool>;

void requestPermission() async {
  Map<Permission, PermissionStatus> statuses =
  await [Permission.location].request();
  if(Permission.location.request().isGranted == false as Future<bool>){
    locPermission = true as Future<bool>;
  } else{
    locPermission = false as Future<bool>;
  }
}
class _WebViewPageState extends State<WebViewPage> {
  late InAppWebViewController webView;
  HeadlessInAppWebView? headlessWebView;
  String url = "";
  double progress = 0;


  InAppWebViewGroupOptions option = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        javaScriptEnabled: true,
        javaScriptCanOpenWindowsAutomatically: true,
        allowUniversalAccessFromFileURLs: true,
        useShouldOverrideUrlLoading: true,
        useShouldInterceptFetchRequest: true,
      ),
      android: AndroidInAppWebViewOptions(
          useHybridComposition: true,
          mixedContentMode: AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
          supportMultipleWindows: true,
          useShouldInterceptRequest: true));


  @override
  void initState() {
    super.initState();
    requestPermission();
    headlessWebView = HeadlessInAppWebView(
      initialUrlRequest:
      URLRequest(url: Uri.parse(url)),
      onWebViewCreated: (controller) {
        final snackBar = SnackBar(
          content: Text('HeadlessInAppWebView created!'),
          duration: Duration(seconds: 1),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      onConsoleMessage: (controller, consoleMessage) {
        final snackBar = SnackBar(
          content: Text('Console Message: ${consoleMessage.message}'),
          duration: Duration(seconds: 1),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      onLoadStart: (controller, url) async {
        final snackBar = SnackBar(
          content: Text('onLoadStart $url'),
          duration: Duration(seconds: 1),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        setState(() {
          this.url = url?.toString() ?? '';
        });
      },
      onLoadStop: (controller, url) async {
        final snackBar = SnackBar(
          content: Text('onLoadStop $url'),
          duration: Duration(seconds: 1),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        setState(() {
          this.url = url?.toString() ?? '';
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    headlessWebView?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: InAppWebView(
              androidOnGeolocationPermissionsShowPrompt:
                  (InAppWebViewController controller, String origin) async {
                bool? result =  locPermission as bool?;

                if (result == true) {
                  Future.value(GeolocationPermissionShowPromptResponse(
                      origin: origin, allow: true, retain: true));
                } else {
                  return Future.value(GeolocationPermissionShowPromptResponse(
                      origin: origin, allow: false, retain: false));
                }
              },
              initialUrlRequest: URLRequest(
                  url: Uri.parse("https://claris0.github.io/good-price-jeju/")),
              initialOptions: option,

              onWebViewCreated: (InAppWebViewController controller) {
                webView = controller;
                print("onWebViewCreated");
              },
              onLoadStart: (InAppWebViewController controller, uri) {
                print("onLoadStart $url");
                setState(() {
                  this.url = url;
                });
              },
              onLoadStop:
                  (InAppWebViewController controller, uri) async {
                print("onLoadStop $url");
                setState(() {
                  this.url = url;
                });
              },
              onProgressChanged:
                  (InAppWebViewController controller, int progress) {
                setState(() {
                  this.progress = progress / 100;
                });
              },
              onUpdateVisitedHistory:
                  (InAppWebViewController controller,
                  Uri, bool? androidIsReload) {
                print("onUpdateVisitedHistory $url");
                setState(() {
                  this.url = url;
                });
              },
              onConsoleMessage: (controller, consoleMessage) {
                print(consoleMessage);
              },
            )
        )
    );
  }
}

/*
  late InAppWebViewController webView;
  HeadlessInAppWebView? headlessWebView;
  String url = "";
  double progress = 0;

  Future<bool> GetPermission() async {
    //권한 요청을 위해 요청할 권한 종류를 [디바이스 스토리지,디바이스 위치] 형식으로 담는다.
    Map<Permission, PermissionStatus>statuses = await [
      Permission.locationWhenInUse
    ].request();
    //권한이 없으면 isGranted는 false
    if (statuses[Permission.locationWhenInUse]!.isGranted) {
      return Future.value(true);
    }
    else {
      //Permission은 최초 거부를 누르게되면 Permission 요청을 보내지 않는다.
      //따라서 openAppSettings(); 함수를 이용해 별도 사용자가 직접 권한을 켜줘야 한다.
      openAppSettings();
      return Future.value(false);
    }
  }
  */

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse("https://claris0.github.io/good-price-jeju/")),
        initialOptions: option,

        androidOnGeolocationPermissionsShowPrompt:
            (InAppWebViewController controller, String origin) async {
          bool? result = await showDialog<bool>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("위치 권한"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('$origin\n'
                          "이 사이트에서 위치 권한을 사용하려고 합니다. 허용하시겠습니까?"),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('거부'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  TextButton(
                    child: Text('허용'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            },
          );
          if (result==true) {
            return Future.value(GeolocationPermissionShowPromptResponse(
                origin: origin, allow: true, retain: true));
          } else {
            return Future.value(GeolocationPermissionShowPromptResponse(
                origin: origin, allow: false, retain: false));
          }
        },
        onWebViewCreated: (InAppWebViewController controller) {
          webView = controller;
          print("onWebViewCreated");
        },
        onLoadStart: (InAppWebViewController controller, Uri) {
          print("onLoadStart $url");
          setState(() {
            this.url = url;
          });
        },
        onLoadStop:
            (InAppWebViewController controller, Uri) async {
          print("onLoadStop $url");
          setState(() {
            this.url = url;
          });
        },
        onProgressChanged:
            (InAppWebViewController controller, int progress) {
          setState(() {
            this.progress = progress / 100;
          });
        },
        onUpdateVisitedHistory:
        (InAppWebViewController controller,
            Uri, bool? androidIsReload) {
          print("onUpdateVisitedHistory $url");
          setState(() {
            this.url = url;
          });
        },
        onConsoleMessage: (controller, consoleMessage) {
          print(consoleMessage);
        },
      ),

    ));
  }
}

*/

/*
var LocationPermission;
class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);


  Future CheckLocation() async {
    if (await Permission.locationWhenInUse
        .request()
        .isGranted) {
      LocationPermission = "granted";
    }
  }

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  @override
  Widget build(BuildContext context) {
    if (LocationPermission == "granted"){
      return Scaffold(
        body:
        SafeArea(
          child:
          WebView(
            initialUrl: "https://claris0.github.io/good-price-jeju/",
            javascriptMode: JavascriptMode.unrestricted,
          ),
        )
      );
    }
    else {
      showSnackBar(context,"위치 권한을 사용 설정해주세요!");
      return Container();
    }
  }
}

 */