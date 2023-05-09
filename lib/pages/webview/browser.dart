import 'package:bili_you/pages/search_result/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    ..setUserAgent(
        'Mozilla/5.0 (iPhone13,3; U; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/602.1.50 (KHTML, like Gecko) Version/10.0 Mobile/15E148 Safari/602.1')
    ..setJavaScriptMode(JavaScriptMode.unrestricted);

  @override
  void initState() {
    webViewController.loadRequest(widget.url);
    webViewController.setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (request) {
          if (request.url.startsWith('bilibili://video/')) {
            //跳转av/bv视频
            String str = Uri.parse(request.url).pathSegments[0];
            String avOrbv = '';
            int? av = int.tryParse(str);
            if (av != null) {
              avOrbv = 'av$av';
            } else if (str.startsWith('BV')) {
              avOrbv = str;
            }
            if (avOrbv.isNotEmpty) {
              //视频跳转
              Navigator.of(context).pushReplacement(GetPageRoute(
                page: () => SearchResultPage(keyWord: avOrbv),
              ));
            }
          }
          if (request.url.startsWith('bilibili://')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
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
