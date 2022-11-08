import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController _wvcontroller;

  void _onWebViewCreated(WebViewController controller) async {
    _wvcontroller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _wvcontroller.canGoBack();
        _wvcontroller.goBack();
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: WebView(
              initialUrl: widget.url,
              onWebViewCreated: _onWebViewCreated,
              javascriptMode: JavascriptMode.unrestricted,
            ),
          ),
        ),
      ),
    );
  }
}
