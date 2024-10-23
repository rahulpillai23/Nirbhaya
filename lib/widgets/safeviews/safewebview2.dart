import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SafeWebView2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WebViewController webViewController = WebViewController();
    return SafeArea(
      child: Scaffold(
          body: WebViewWidget(
              controller: webViewController
                ..loadRequest(Uri.parse(
                    'https://zeenews.india.com/companies/business-success-story-meet-the-original-slumdog-millionaire-who-came-from-living-in-a-slum-to-setting-up-an-empire-worth-112-million-2703219.html')))),
    );
  }
}
