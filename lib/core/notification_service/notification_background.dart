import 'noti_service.dart';
import 'dart:developer' as dev;

@pragma('vm:entry-point')
void bgNotiResponse(NotificationResponse details) {
  final payload = details.payload ?? 'error';
  dev.log('Payload Background Noti: $payload');
  if (payload == NotiPayLoad.normalPayParking) {}
}
