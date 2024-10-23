import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SafeWebView3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WebViewController webViewController = WebViewController();
    return SafeArea(
      child: Scaffold(
          body: WebViewWidget(
              controller: webViewController
                ..loadRequest(Uri.parse(
                    'https://www.barandbench.com/columns/this-womens-day-make-it-your-day-by-knowing-your-rights')))),
    );
  }
}
