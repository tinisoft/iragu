import 'package:flutter/material.dart';

import 'dart:typed_data';
import 'package:iragu/iragu.dart';
import 'package:bitmap/bitmap.dart';

const int width = 600;
const int height = 600;

void strokeTo(MyPaintBrush brush, MyPaintSurface surface, double x, double y) {
  double viewzoom = 1.0, viewrotation = 0.0, barrel_rotation = 0.0;
  double pressure = 1.0, ytilt = 0.0, xtilt = 0.0, dtime = 1.0 / 10;
  bool linear = false;
  brush.strokeTo(surface, x, y, pressure, xtilt, ytilt, dtime, viewzoom,
      viewrotation, barrel_rotation, linear);
}

Future<Uint8List> LibMyPaintTest() async {
  // Load brush presets.
  var brushLib = BrushPresetLibrary();
  await brushLib.addCollection("/usr/share/mypaint-data/2.0/brushes/classic");

  var brushPreset = brushLib.getBrush("classic/marker_small");

  // MyPaintBrush brush = MyPaintBrush.withDefaults();
  MyPaintBrush? brush;
  brush = brushPreset != null ? brushPreset!.brush : null;

  brush ??= MyPaintBrush.withDefaults();

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
  strokeTo(brush, surface, 4 * wq, hq);

  MyPaintRectangle roi;
  MyPaintRectangles rois;
  var numRectangles = 1;
  rois = surface.endAtomic(numRectangles);
  return surface.image();
}

Uint8List? im;

void main() async {
  im = await LibMyPaintTest();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Iragu Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Iragu Test'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    Bitmap bitmap = Bitmap.fromHeadless(width, height, im!);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(child: Image.memory(bitmap.buildHeaded())),
    );
  }
}
