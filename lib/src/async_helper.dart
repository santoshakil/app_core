import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';

Future<T> ffiAsync<T>(
  void Function(int port) rustCall,
  T Function(dynamic message) parser,
) {
  final port = ReceivePort();
  final completer = Completer<T>();

  port.listen((message) {
    try {
      completer.complete(parser(message));
    } catch (e) {
      completer.completeError(e);
    } finally {
      port.close();
    }
  });

  rustCall(port.sendPort.nativePort);
  return completer.future;
}
