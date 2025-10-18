import 'dart:ffi';
import 'package:ffi/ffi.dart';
import '../app_core.dart';

extension StringFfi on String {
  Pointer<Char> toPtr() => toNativeUtf8(allocator: malloc).cast<Char>();
}

extension PointerFfi on Pointer<Char> {
  String toStr() {
    if (this == nullptr) return '';
    final dartString = cast<Utf8>().toDartString();
    bindings.free_c_string(this);
    return dartString;
  }

  String toStrNoFree() {
    if (this == nullptr) return '';
    return cast<Utf8>().toDartString();
  }

  String? toStrOptional() {
    if (this == nullptr) return null;
    final dartString = cast<Utf8>().toDartString();
    bindings.free_c_string(this);
    return dartString;
  }

  String? toStrOptionalNoFree() {
    if (this == nullptr) return null;
    return cast<Utf8>().toDartString();
  }
}
