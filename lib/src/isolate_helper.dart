import 'dart:isolate';
import 'package:flutter/foundation.dart';

Future<R> ffiCompute<M, R>(R Function(M) callback, M message) {
  if (kIsWeb) {
    return Future.value(callback(message));
  }
  return compute(callback, message);
}

Future<R> ffiIsolate<M, R>(
  R Function(M) callback,
  M message, {
  String? debugName,
}) async {
  final port = ReceivePort();

  await Isolate.spawn(
    _isolateEntry,
    _IsolateConfig(
      callback: callback,
      message: message,
      sendPort: port.sendPort,
    ),
    debugName: debugName,
  );

  final result = await port.first as R;
  return result;
}

class _IsolateConfig<M, R> {
  final R Function(M) callback;
  final M message;
  final SendPort sendPort;

  _IsolateConfig({
    required this.callback,
    required this.message,
    required this.sendPort,
  });
}

void _isolateEntry<M, R>(_IsolateConfig<M, R> cfg) {
  final result = cfg.callback(cfg.message);
  cfg.sendPort.send(result);
}
