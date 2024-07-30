// import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'dart:developer' as dev;

// class OnesignalForground {
//   //Handle on notification click
//   static void onForeground() {
//     OneSignal.Notifications.addForegroundWillDisplayListener((event) {
//       final noti = event.notification;
//       dev.log('Foregeound noti: ${noti.jsonRepresentation()}',
//           name: "Onesignal");

//       event.preventDefault();
//       event.notification.display();
//     });
//   }
// }
