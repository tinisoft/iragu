import 'dart:ffi';

import 'package:iragu/ffi/libmypaint_dart_bindings.dart' as cmp;

class CLib extends cmp.NativeLibrary {
  static final CLib _singleton = CLib._internal();

  factory CLib() {
    return _singleton;
  }

  CLib._internal()
      : super(DynamicLibrary.open(
            "/home/ark/work/iragu/libmypaint/.libs/libmypaint-2.0.so"));
}
