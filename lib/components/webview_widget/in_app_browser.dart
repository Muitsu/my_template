// import 'dart:collection';

// import 'package:eperumahan/core/widgets/inapp_new_tab.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'dart:developer' as dev;

// class InappBrowser extends StatefulWidget {
//   final String title;
//   final String url;
//   const InappBrowser({super.key, required this.title, required this.url});

//   @override
//   State<InappBrowser> createState() => _InappBrowserState();
// }

// class _InappBrowserState extends State<InappBrowser> {
//   final GlobalKey webViewKey = GlobalKey();
//   late PlatformInAppWebViewWidgetCreationParams params;
//   late ContextMenu contextMenu;
//   InAppWebViewController? webController;
//   double _progress = 0;
//   bool stopProgress = false;
//   Color primaryColor = const Color(0xFF314ED2);
//   PullToRefreshController? pullToRefreshController;
//   String prevUrl = "";
//   InAppWebViewSettings settings = InAppWebViewSettings(
//     isInspectable: kDebugMode,
//     mediaPlaybackRequiresUserGesture: false,
//     allowsInlineMediaPlayback: true,
//     iframeAllow: "camera; microphone",
//     iframeAllowFullscreen: true,
//   );

//   @override
//   void initState() {
//     super.initState();
//     settingContextMenu();
//     setRefreshIndicator();
//   }

//   settingContextMenu() {
//     contextMenu = ContextMenu(
//         menuItems: [
//           ContextMenuItem(
//               id: 1,
//               title: "Special",
//               action: () async {
//                 dev.log("Menu item Special clicked!");
//                 dev.log(await webController?.getSelectedText() ?? "none",
//                     name: "URL_CM");
//                 await webController?.clearFocus();
//               })
//         ],
//         settings: ContextMenuSettings(hideDefaultSystemContextMenuItems: false),
//         onCreateContextMenu: (hitTestResult) async {
//           dev.log(hitTestResult.extra ?? "none", name: "URL_OCCM");
//           dev.log(await webController?.getSelectedText() ?? "none",
//               name: "URL_OCCM");
//         },
//         onHideContextMenu: () {
//           dev.log("onHideContextMenu", name: "URL_HCM");
//         },
//         onContextMenuActionItemClicked: (contextMenuItemClicked) async {
//           var id = contextMenuItemClicked.id;
//           dev.log(
//               "onContextMenuActionItemClicked: $id ${contextMenuItemClicked.title}");
//         });
//   }

//   setRefreshIndicator() {
//     pullToRefreshController = kIsWeb ||
//             ![TargetPlatform.iOS, TargetPlatform.android]
//                 .contains(defaultTargetPlatform)
//         ? null
//         : PullToRefreshController(
//             settings: PullToRefreshSettings(
//               color: Colors.blue,
//             ),
//             onRefresh: () async {
//               if (defaultTargetPlatform == TargetPlatform.android) {
//                 webController?.reload();
//               } else if (defaultTargetPlatform == TargetPlatform.iOS ||
//                   defaultTargetPlatform == TargetPlatform.macOS) {
//                 webController?.loadUrl(
//                     urlRequest: URLRequest(url: await webController?.getUrl()));
//               }
//             },
//           );
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.sizeOf(context);
//     return PopScope(
//       canPop: false,
//       onPopInvoked: (didPop) async {
//         if (didPop) return;
//         if (await webController!.canGoBack()) {
//           webController!.goBack();
//         } else {
//           showExitAlert(size);
//         }
//       },
//       child: Scaffold(
//         appBar: PreferredSize(
//             preferredSize:
//                 const Size.fromHeight(60.0), // here the desired height
//             child: Column(
//               children: [
//                 const Spacer(),
//                 AppBar(
//                   automaticallyImplyLeading: false,
//                   backgroundColor: Colors.white,
//                   title: Text(
//                     widget.title,
//                     style: const TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 18),
//                   ),
//                   actions: [
//                     IconButton(
//                       onPressed: () {
//                         // SystemChannels.textInput.invokeMethod('TextInput.hide');
//                         showExitAlert(size);
//                       },
//                       icon: Icon(
//                         Icons.close,
//                         color: primaryColor,
//                       ),
//                     ),
//                   ],
//                   elevation: 1,
//                   shadowColor: Colors.black.withValues(alpha:0.3),
//                 ),
//                 Visibility(
//                   visible: _progress.toInt() < 1,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(6),
//                     child: linearProgressBar(value: _progress, 4),
//                   ),
//                 ),
//               ],
//             )),
//         body: Column(
//           children: [
//             Expanded(
//               child: InAppWebView(
//                 key: webViewKey,
//                 onWebViewCreated: (controller) => webController = controller,
//                 onProgressChanged: (controller, progress) {
//                   if (stopProgress) return;
//                   if (!mounted) return;
//                   setState(() => _progress = progress / 100);
//                 },
//                 onPermissionRequest: (controller, request) async {
//                   return PermissionResponse(
//                       resources: request.resources,
//                       action: PermissionResponseAction.GRANT);
//                 },
//                 initialUserScripts: UnmodifiableListView<UserScript>([]),
//                 initialSettings: settings,
//                 contextMenu: contextMenu,
//                 onLoadStart: (controller, url) {
//                   dev.log(url.toString(), name: "URL_LS");
//                 },
//                 onLoadStop: (controller, url) {},
//                 onReceivedError: (controller, request, error) {},
//                 // pullToRefreshController: pullToRefreshController,
//                 shouldOverrideUrlLoading: (controller, navigationAction) async {
//                   var uri = navigationAction.request.url!;
//                   var url = uri.toString();
//                   if (prevUrl != url) dev.log(url, name: "URL_SOUL");
//                   if (url.contains("publicUser/qrEkyc")) {
//                     if (prevUrl == url) return NavigationActionPolicy.CANCEL;
//                     setState(() => prevUrl = url);
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => InAppNewTab(
//                                   title: "IDVET: eKyc",
//                                   url: url,
//                                 )));
//                     return NavigationActionPolicy.CANCEL;
//                   }
//                   setState(() => prevUrl = url);
//                   return NavigationActionPolicy.ALLOW;
//                 },
//                 onNavigationResponse: (controller, navigationResponse) async {
//                   var uri = navigationResponse.response!.url!;
//                   dev.log(uri.scheme, name: "URL_NR");
//                   return NavigationResponseAction.ALLOW;
//                 },
//                 onConsoleMessage: (controller, consoleMessage) {
//                   dev.log(consoleMessage.message);
//                 },
//                 initialUrlRequest: URLRequest(url: WebUri(widget.url)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   linearProgressBar(double height, {required double value}) {
//     return PreferredSize(
//       preferredSize: const Size.fromHeight(0),
//       child: SizedBox(
//         width: double.infinity,
//         height: height,
//         child: LinearProgressIndicator(
//           value: value,
//           color: primaryColor,
//           backgroundColor: Colors.grey.shade400,
//         ),
//       ),
//     );
//   }

//   showExitAlert(Size size) {
//     showModalBottomSheet(
//         context: context,
//         isScrollControlled: true,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         builder: (context) {
//           return Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               const SizedBox(height: 6),
//               Center(
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: Container(
//                       width: 80,
//                       height: 6,
//                       color: Theme.of(context).secondaryHeaderColor),
//                 ),
//               ),
//               const SizedBox(height: 15),
//               const Padding(
//                 padding: EdgeInsets.only(bottom: 12, left: 12),
//                 child: Text(
//                   'Leaving Site ?',
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               const Padding(
//                 padding: EdgeInsets.only(bottom: 18, left: 12),
//                 child: Text(
//                   'Are you sure you want to stop browsing this site ?',
//                   style: TextStyle(fontSize: 18),
//                 ),
//               ),
//               Row(
//                 children: [
//                   SizedBox(
//                       width: size.width * 0.48,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 12),
//                         child: ClipRRect(
//                           // borderRadius: BorderRadius.circular(8),
//                           child: SizedBox(
//                             height: 55,
//                             width: double.infinity,
//                             child: OutlinedButton(
//                               onPressed: () {
//                                 InAppWebViewController.clearAllCache;
//                                 webController?.clearHistory();
//                                 Navigator.pop(context);
//                                 Navigator.pop(context);
//                               },
//                               style: ButtonStyle(
//                                 side: WidgetStateProperty.all(const BorderSide(
//                                     color: Color(0xffDBDBF0),
//                                     width: 1.0,
//                                     style: BorderStyle.solid)),
//                                 overlayColor: WidgetStateProperty.resolveWith(
//                                   (states) {
//                                     return states.contains(WidgetState.pressed)
//                                         ? Theme.of(context)
//                                             .primaryColor
//                                             .withValues(alpha:0.08)
//                                         : null;
//                                   },
//                                 ),
//                                 shape: WidgetStateProperty.all(
//                                     RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(8))),
//                               ),
//                               child: Text(
//                                 'Keluar',
//                                 style: TextStyle(
//                                     color: primaryColor,
//                                     fontWeight: FontWeight.w900,
//                                     fontSize: 16),
//                               ),
//                             ),
//                           ),
//                         ),
//                       )),
//                   SizedBox(
//                       width: size.width * 0.48,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 12),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: SizedBox(
//                             height: 55,
//                             width: double.infinity,
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               style: ElevatedButton.styleFrom(
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(12)),
//                                   backgroundColor: primaryColor,
//                                   foregroundColor: Colors.white,
//                                   disabledBackgroundColor:
//                                       const Color(0xFFC5C5C5),
//                                   disabledForegroundColor:
//                                       const Color(0xFF9A9A9A),
//                                   shadowColor: Colors.transparent),
//                               child: const Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Expanded(
//                                     child: Center(
//                                       child: Text(
//                                         'Teruskan',
//                                         overflow: TextOverflow.visible,
//                                         maxLines: 1,
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.w900,
//                                           fontSize: 16,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       )),
//                 ],
//               ),
//               const SizedBox(height: 12),
//             ],
//           );
//         });
//   }
// }
