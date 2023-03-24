import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BiliBrowser extends StatefulWidget {
  const BiliBrowser(
      {super.key, required this.url, required this.title, this.onPageFinished});
  final Uri url;
  final String title;
  final Function(String url)? onPageFinished;

  @override
  State<BiliBrowser> createState() => _BiliBrowserState();
}

class _BiliBrowserState extends State<BiliBrowser> {
  GlobalKey progressBarKey = GlobalKey();
  double progressBarValue = 0;
  final WebViewController webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted);

  @override
  void initState() {
    webViewController.loadRequest(widget.url);
    webViewController.setNavigationDelegate(NavigationDelegate(
        onProgress: (progress) {
          if (progressBarKey.currentState?.mounted ?? false) {
            progressBarKey.currentState?.setState(() {
              progressBarValue = progress / 100.toDouble();
            });
          }
        },
        onPageFinished: widget.onPageFinished));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(children: [
        StatefulBuilder(
            key: progressBarKey,
            builder: (context, setState) {
              return Visibility(
                visible: progressBarValue < 1,
                child: LinearProgressIndicator(
                  key: ValueKey(progressBarValue),
                  value: progressBarValue,
                ),
              );
            }),
        Expanded(
          child: WebViewWidget(controller: webViewController),
        )
      ]),
    );
  }
}
