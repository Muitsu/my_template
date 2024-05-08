import 'dart:developer' as dev;

import 'noti_service.dart';

//Add your logic here
void fgNotiResponse(NotificationResponse details) {
  final payload = details.payload ?? 'error';
  dev.log('Payload Foreground Noti: $payload');
  if (payload == NotiPayLoad.normalPayParking) {}
}
