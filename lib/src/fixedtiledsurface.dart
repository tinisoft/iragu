import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

import 'package:iragu/ffi/libmypaint_dart_bindings.dart' as cmp;
import 'package:iragu/src/clib.dart';
import 'surface.dart';

class MyPaintFixedTiledSurface extends MyPaintSurface {
  late final Pointer<cmp.MyPaintFixedTiledSurface> ftsurface;
  MyPaintFixedTiledSurface(int width, int height) : super.empty() {
    ftsurface = CLib().mypaint_fixed_tiled_surface_new(width, height);
    surface = CLib().mypaint_fixed_tiled_surface_interface(ftsurface);
  }
  int get width {
    return CLib().mypaint_fixed_tiled_surface_get_width(ftsurface);
  }

  int get height {
    return CLib().mypaint_fixed_tiled_surface_get_height(ftsurface);
  }

  Uint8List image() {
    int bufferSize = width * height * 4;
    Pointer<Uint8> img = malloc.allocate<Uint8>(bufferSize);
    CLib().mypaint_fixed_tiled_surface_as_uint8(ftsurface, img);
    return img.asTypedList(bufferSize);
  }
}
