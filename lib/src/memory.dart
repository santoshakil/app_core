import 'dart:ffi';
import 'package:ffi/ffi.dart';

void freeDartString(Pointer<Char> ptr) {
  if (ptr == nullptr) return;
  malloc.free(ptr);
}
