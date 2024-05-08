import 'package:synchronized/synchronized.dart';

class SyncApi {
  static final SyncApi instance = SyncApi._init();
  factory SyncApi() => instance;
  SyncApi._init();
  final _lock = Lock();
  Future<String?> queue() async {
    return await _lock.synchronized<String?>(() async => '');
  }
}
