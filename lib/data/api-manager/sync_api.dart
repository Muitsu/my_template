import 'package:synchronized/synchronized.dart';

class SyncApi {
  static final SyncApi _instance = SyncApi._init();
  factory SyncApi() => _instance;

  SyncApi._init();

  final _lock = Lock();

  Future<T?> queue<T>(Future<T> Function() task) async {
    return await _lock.synchronized<T?>(() async => await task());
  }
}
