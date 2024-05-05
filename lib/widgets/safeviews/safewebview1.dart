import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SafeWebView1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WebViewController webViewController = WebViewController();
    return SafeArea(
      child: Scaffold(
          body: WebViewWidget(
              controller: webViewController
                ..loadRequest(Uri.parse(
                    'https://www.opengrowth.com/resources/laxmi-agarwal-acid-attack-survivor-and-iconic-symbol-of-women-empowerment')))),
    );
  }
}
