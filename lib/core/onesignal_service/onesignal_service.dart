// import 'package:capital_park/services/onesignal_service/onesignal_onforeground.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'package:permission_handler/permission_handler.dart';

// import 'onesignal_onclick.dart';

// class OnesignalService {
//   //Initialize
//   static Future<void> init({required bool isDebug}) async {
//     if (isDebug) {
//       OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
//     }
//     var myTestKey = "e659c4a8-e9a0-4f5b-aae1-623a1e0d877c";
//     OneSignal.initialize(myTestKey);
//     await _requestPermission();
//     OnesignalOnclick.onClickListener();
//     OnesignalForground.onForeground();
//     //Onesignal permission request
//     OneSignal.Notifications.requestPermission(true);
//     OneSignal.InAppMessages.paused(true);
//   }

//   //External permission request
//   static Future<void> _requestPermission() async {
//     var status = await Permission.notification.status;
//     if (status.isGranted) return;
//     Permission.notification.request();
//   }

//   login({String? externalID}) async {
//     if (externalID == null) return;
//     OneSignal.login(externalID);
//   }

//   subscribeTag({required String tagID}) {}
// }
