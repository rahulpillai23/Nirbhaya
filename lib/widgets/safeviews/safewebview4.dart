import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SafeWebView4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WebViewController webViewController = WebViewController();
    return SafeArea(
      child: Scaffold(
          body: WebViewWidget(
              controller: webViewController
                ..loadRequest(Uri.parse(
                    'https://herviewfromhome.com/to-the-moms-at-home-on-international-womens-day/')))),
    );
  }
}
