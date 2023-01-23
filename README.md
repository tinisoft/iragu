Iragu : Dart bindings for libmypaint https://github.com/mypaint/libmypaint.

## Features
- Just a simple working version, has to be improved.
- [] Have to add documentation.

## Getting started
Build libmypaint from here https://github.com/tinisoft/libmypaint and install it.

## Usage

Simple example and checkout examples folder how to use with flutter.
`
import 'dart:typed_data';

import 'package:iragu/iragu.dart';

void strokeTo(MyPaintBrush brush, MyPaintSurface surface, double x, double y) {
  double viewzoom = 1.0, viewrotation = 0.0, barrel_rotation = 0.0;
  double pressure = 1.0, ytilt = 0.0, xtilt = 0.0, dtime = 1.0 / 10;
  bool linear = false;
  brush.strokeTo(surface, x, y, pressure, xtilt, ytilt, dtime, viewzoom,
      viewrotation, barrel_rotation, linear);
}

void main() {
  // var awesome = Awesome();
  // print('awesome: ${awesome.isAwesome}');
  int width = 300, height = 150;
  MyPaintBrush brush = MyPaintBrush.withDefaults();
  MyPaintFixedTiledSurface surface = MyPaintFixedTiledSurface(width, height);
  brush.setParam(MyPaintBrushSetting.COLOR_H, 0.0);
  brush.setParam(MyPaintBrushSetting.COLOR_S, 1.0);
  brush.setParam(MyPaintBrushSetting.COLOR_V, 1.0);

  /* Draw a rectangle on the surface using the brush */
  surface.beginAtomic();
  double wq = width / 5;
  double hq = height / 5;
  strokeTo(brush, surface, wq, hq);
  strokeTo(brush, surface, 4 * wq, hq);
  strokeTo(brush, surface, 4 * wq, 4 * hq);
  strokeTo(brush, surface, wq, 4 * hq);
  strokeTo(brush, surface, wq, hq);

  MyPaintRectangle roi;
  MyPaintRectangles rois;
  var numRectangles = 1;
  surface.endAtomic(numRectangles);
  Uint8List? im = surface.image();
  print("$im");
  im = null;
}
`
## Additional information
Welcome to any feature requests, pull requests.

