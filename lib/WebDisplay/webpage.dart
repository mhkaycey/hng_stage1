import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {
  const WebPage({super.key});

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  late final WebViewController controller;
  var loadingPrecentage = 0;
  // final controller = WebViewController()
  //   ..setJavaScriptMode(JavaScriptMode.disabled)
  //   ..loadRequest(Uri.parse('https://github.com/mhkaycey'));

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse('https://github.com/mhkaycey'),
      );
    controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPrecentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPrecentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPrecentage = 100;
          });
        },
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("GitHub Page"),
        leading: IconButton(
          onPressed: () async {
            if (await controller.canGoBack()) {
              await controller.goBack();
            }
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (await controller.canGoForward()) {
                await controller.goForward();
              }
            },
            icon: const Icon(
              Icons.arrow_forward_ios,
            ),
          ),
          IconButton(
            onPressed: () => controller.reload(),
            icon: const Icon(
              Icons.refresh,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.close,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (loadingPrecentage < 100)
            LinearProgressIndicator(
              value: loadingPrecentage / 100.0,
              color: Colors.amber,
            )
        ],
      ),
    );
  }
}
