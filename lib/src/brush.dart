import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'package:iragu/ffi/libmypaint_dart_bindings.dart' as cmp;
import 'package:iragu/src/clib.dart';
import 'package:iragu/src/surface.dart';

class Color {
  double r, g, b, a;
  Color(this.r, this.g, this.b, this.a);
}

class BrushSmudgeState {
  Color curr;
  Color prev;
  double prevColorRecentness;
  BrushSmudgeState(this.curr, this.prev, this.prevColorRecentness);
}

class MyPaintBrush {
  late final Pointer<cmp.MyPaintBrush> brush;
  MyPaintBrush() {
    brush = CLib().mypaint_brush_new();
  }
  MyPaintBrush.withBuckets(int numSmudgeBuckets) {
    brush = CLib().mypaint_brush_new_with_buckets(numSmudgeBuckets);
  }
  MyPaintBrush.withDefaults() {
    brush = CLib().mypaint_brush_new();
    CLib().mypaint_brush_from_defaults(brush);
  }
  MyPaintBrush.fromJSON(String json) {
    brush = CLib().mypaint_brush_new();
    CLib().mypaint_brush_from_string(brush, json.toNativeUtf8().cast<Char>());
  }

  void reset() {
    CLib().mypaint_brush_reset(brush);
  }

  void beginStroke() {
    CLib().mypaint_brush_new_stroke(brush);
  }

  int strokeTo(
    MyPaintSurface surface,
    double x,
    double y,
    double pressure,
    double xtilt,
    double ytilt,
    double dtime,
    double viewzoom,
    double viewrotation,
    double barrel_rotation,
    bool linear,
  ) {
    return CLib().mypaint_brush_stroke_to(
        brush,
        surface.surface,
        x,
        y,
        pressure,
        xtilt,
        ytilt,
        dtime,
        viewzoom,
        viewrotation,
        barrel_rotation,
        linear == true ? 1 : 0);
  }

  void setParam(int id, double value) {
    CLib().mypaint_brush_set_base_value(brush, id, value);
  }

  double getParam(int id) {
    return CLib().mypaint_brush_get_base_value(brush, id);
  }

  bool isParamConstant(int id) {
    return CLib().mypaint_brush_is_constant(brush, id) > 0;
  }

  int getInputsUsed(int id) {
    return CLib().mypaint_brush_get_inputs_used_n(brush, id);
  }

  void setMappingN(int paramid, int input, int n) {
    return CLib().mypaint_brush_set_mapping_n(brush, paramid, input, n);
  }

  int getMappingN(int paramid, int input) {
    return CLib().mypaint_brush_get_mapping_n(brush, paramid, input);
  }

  List<double> getMappingPoint(int paramid, int input, int index) {
    List<double> ret = [];
    Pointer<Float> x, y;
    x = malloc.allocate<Float>(1);
    y = malloc.allocate<Float>(1);

    CLib().mypaint_brush_get_mapping_point(brush, paramid, input, index, x, y);
    ret.add(x.value);
    ret.add(y.value);
    malloc.free(x);
    malloc.free(y);
    return ret;
  }

  double getState(int i) {
    return CLib().mypaint_brush_get_state(brush, i);
  }

  void setState(int i, double value) {
    return CLib().mypaint_brush_set_state(brush, i, value);
  }

  bool setSmudgeBucketState(
    int bucketIndex,
    BrushSmudgeState state,
  ) {
    return CLib().mypaint_brush_set_smudge_bucket_state(
            brush,
            bucketIndex,
            state.curr.r,
            state.curr.g,
            state.curr.b,
            state.curr.a,
            state.prev.r,
            state.prev.g,
            state.prev.b,
            state.prev.a,
            state.prevColorRecentness) >
        0;
  }

  BrushSmudgeState getSmudgeBucketState(int bucketIndex) {
    Pointer<Float> args = malloc.allocate<Float>(9);
    CLib().mypaint_brush_get_smudge_bucket_state(
        brush,
        bucketIndex,
        args.elementAt(0),
        args.elementAt(1),
        args.elementAt(2),
        args.elementAt(3),
        args.elementAt(4),
        args.elementAt(5),
        args.elementAt(6),
        args.elementAt(7),
        args.elementAt(8));
    var ret = BrushSmudgeState(
      Color(args.elementAt(0).value, args.elementAt(1).value,
          args.elementAt(2).value, args.elementAt(3).value),
      Color(args.elementAt(4).value, args.elementAt(5).value,
          args.elementAt(6).value, args.elementAt(7).value),
      args.elementAt(8).value,
    );
    malloc.free(args);
    return ret;
  }

  int getMinSmudgeBucketUsed() {
    return CLib().mypaint_brush_get_min_smudge_bucket_used(brush);
  }

  int getMaxSmudgeBucketUsed() {
    return CLib().mypaint_brush_get_min_smudge_bucket_used(brush);
  }

  void setPrintInputs(bool enabled) {
    return CLib().mypaint_brush_set_print_inputs(brush, enabled ? 1 : 0);
  }
}
