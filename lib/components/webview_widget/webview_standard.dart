import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewStandard extends StatefulWidget {
  final String url;
  final String title;
  const WebviewStandard({super.key, required this.url, required this.title});

  @override
  State<WebviewStandard> createState() => _WebviewStandardState();
}

class _WebviewStandardState extends State<WebviewStandard> {
  late WebViewController _controller;
  double _progress = 0;
  bool isError = false;
  bool showErrMsg = false;
  String errMsg = '';
  bool stopProgress = false;
  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (stopProgress) return;
            if (!mounted) return;
            setState(() => _progress = progress / 100);
          },
          onPageStarted: (String url) {
            debugPrint('----------Start Url----------');
          },
          onPageFinished: (String url) {
            debugPrint('----------Complete Url----------');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('----------Error Url----------');
          },
          onNavigationRequest: (NavigationRequest request) {
            debugPrint('----------Illegal Url----------');

            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            } else if (request.url.contains('redirect')) {
              setState(() => stopProgress = true);
              Navigator.pop(context);
              return NavigationDecision.navigate;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        if (await _controller.canGoBack()) {
          _controller.goBack();
        } else {
          showExitAlert(size);
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize:
                const Size.fromHeight(60.0), // here the desired height
            child: Column(
              children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  title: Text(
                    widget.title,
                    style: TextStyle(
                        color: Colors.black87.withOpacity(0.8),
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                  leading: IconButton(
                    onPressed: () {
                      _controller.reload();
                    },
                    icon: Icon(
                      Icons.refresh,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                          showExitAlert(size);
                        },
                        child: const Text(
                          'Done',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ))
                  ],
                  elevation: 1,
                  shadowColor: Colors.black.withOpacity(0.3),
                ),
                Visibility(
                  visible: _progress.toInt() < 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: linearProgressBar(value: _progress, 4),
                  ),
                ),
              ],
            )),
        body: !isError
            ? Column(
                children: [
                  Expanded(
                    child: WebViewWidget(controller: _controller),
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Oh no, we can't redirect to this website",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87.withOpacity(0.6)),
                    ),
                    TextButton(
                        onPressed: showErrMsg
                            ? null
                            : () {
                                setState(() => showErrMsg = true);
                              },
                        child: Text(
                          textAlign: TextAlign.center,
                          showErrMsg ? errMsg : 'See error message',
                          style: TextStyle(
                              color: showErrMsg ? Colors.black54 : Colors.blue),
                        ))
                  ],
                ),
              ),
      ),
    );
  }

  linearProgressBar(double height, {required double value}) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(0),
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: LinearProgressIndicator(
          value: value,
          color: Theme.of(context).primaryColor,
          backgroundColor: Colors.grey.shade400,
        ),
      ),
    );
  }

  showExitAlert(Size size) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                      width: 80,
                      height: 6,
                      color: Theme.of(context).secondaryHeaderColor),
                ),
              ),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.only(bottom: 12, left: 12),
                child: Text(
                  'Leaving Site ?',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 18, left: 12),
                child: Text(
                  'Are you sure you want to stop browsing this site ?',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                      width: size.width * 0.48,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: ClipRRect(
                          // borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            height: 55,
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                _controller.clearCache();
                                _controller.clearLocalStorage();
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              style: ButtonStyle(
                                side: WidgetStateProperty.all(const BorderSide(
                                    color: Color(0xffDBDBF0),
                                    width: 1.0,
                                    style: BorderStyle.solid)),
                                overlayColor: WidgetStateProperty.resolveWith(
                                  (states) {
                                    return states.contains(WidgetState.pressed)
                                        ? Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.08)
                                        : null;
                                  },
                                ),
                                shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8))),
                              ),
                              child: Text(
                                'Leave',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      )),
                  SizedBox(
                      width: size.width * 0.48,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            height: 55,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor:
                                      const Color(0xFFC5C5C5),
                                  disabledForegroundColor:
                                      const Color(0xFF9A9A9A),
                                  shadowColor: Colors.transparent),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'Stay',
                                        overflow: TextOverflow.visible,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
              const SizedBox(height: 12),
            ],
          );
        });
  }
}
