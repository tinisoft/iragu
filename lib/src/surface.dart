import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:iragu/ffi/libmypaint_dart_bindings.dart' as cmp;
import 'package:iragu/iragu.dart';

import 'clib.dart';

class MyPaintSurface {
  late final Pointer<cmp.MyPaintSurface> surface;
  MyPaintSurface.empty();
  MyPaintSurface(this.surface);
  void init() {
    CLib().mypaint_surface_init(surface);
  }

  int drawDab(
      double x,
      double y,
      double radius,
      double color_r,
      double color_g,
      double color_b,
      double opaque,
      double hardness,
      double softness,
      double alpha_eraser,
      double aspect_ratio,
      double angle,
      double lock_alpha,
      double colorize,
      double posterize,
      double posterize_num,
      double paint) {
    return CLib().mypaint_surface_draw_dab(
        surface,
        x,
        y,
        radius,
        color_r,
        color_g,
        color_b,
        opaque,
        hardness,
        softness,
        alpha_eraser,
        aspect_ratio,
        angle,
        lock_alpha,
        colorize,
        posterize,
        posterize_num,
        paint);
  }

  Color getColor(double x, double y, double radius, double paint) {
    Pointer<Float> args = malloc<Float>(4);
    CLib().mypaint_surface_get_color(surface, x, y, radius, args.elementAt(0),
        args.elementAt(1), args.elementAt(2), args.elementAt(3), paint);
    return Color(args.elementAt(0).value, args.elementAt(1).value,
        args.elementAt(2).value, args.elementAt(3).value);
  }

  double getAlpha(double x, double y, double z) {
    return CLib().mypaint_surface_get_alpha(surface, x, y, z);
  }

  void savePng(String fpath, int x, int y, int width, int height) {
    return CLib().mypaint_surface_save_png(
        surface, fpath.toNativeUtf8().cast<Char>(), x, y, width, height);
  }

  void beginAtomic() {
    return CLib().mypaint_surface_begin_atomic(surface);
  }

  MyPaintRectangles endAtomic(int numRectangles) {
    print("endAtomic is called\n");
    Pointer<MyPaintRectangles> roi = malloc<MyPaintRectangles>(1);
    roi.ref.rectangles = malloc<MyPaintRectangle>(numRectangles);
    roi.ref.num_rectangles = numRectangles;
    CLib().mypaint_surface_end_atomic(surface, roi);
    return roi.ref;
  }
}
