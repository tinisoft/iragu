import 'dart:convert';
import 'package:iragu/iragu.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

String getCollectNameFromDir(String dirName) {
  var paths = p.split(dirName);
  if (paths.length < 2) {
    return ".";
  }
  return paths[paths.length - 1];
}

String getCollectNameFromBrushName(String brushName) {
  var paths = p.split(brushName);
  if (paths.length < 2) {
    return ".";
  }
  return paths[paths.length - 2];
}

String getBrushName(String brushName) {
  var paths = p.split(brushName);
  if (paths.length < 2) {
    return brushName;
  }
  return paths[paths.length - 1];
}

class BrushPreset {
  String fpath;
  String brushName;
  String collectionName;
  String? preset; //Holds the preset json.
  BrushPreset.fromFile(this.fpath)
      : brushName = p.basenameWithoutExtension(fpath),
        collectionName = getCollectNameFromBrushName(fpath);
  // Called expected to handle the exception here.
  Future<void> load() async {
    preset = await File(fpath).readAsString();
    try {
      json.decode(preset!) as Map<String, dynamic>;
    } catch (e) {
      preset = "";
      rethrow;
    }
  }

  MyPaintBrush? get brush {
    if (preset == null) {
      return null;
    }
    return MyPaintBrush.fromJSON(preset!);
  }
}

const String DEFAULT_COLLECTION = ".";

class BrushPresetLibrary {
  static final BrushPresetLibrary _singleton = BrushPresetLibrary._internal();
  static final Map<String, List<BrushPreset>> library = {};
  factory BrushPresetLibrary() {
    return _singleton;
  }
  BrushPresetLibrary._internal() {}

  Future<void> addCollection(String dirPath) async {
    var brushes = await loadCollection(dirPath);
    library[getCollectNameFromDir(dirPath)] = brushes;
  }

  void addBrush(BrushPreset brush) {
    List<BrushPreset>? brushes = library[DEFAULT_COLLECTION];
    brushes ??= <BrushPreset>[];
    brushes.add(brush);
    library[DEFAULT_COLLECTION] = brushes;
  }

  Future<List<BrushPreset>> loadCollection(String dirPath) async {
    List<BrushPreset> brushes = [];
    // check if the directory exists.
    var dir = Directory(dirPath);

    bool exists = await dir.exists();
    final List<FileSystemEntity> entities = await dir.list().toList();
    for (var entity in entities) {
      if (!entity.path.endsWith(".myb")) {
        continue;
      }
      print("adding brush:${entity.path}");
      try {
        var brp = BrushPreset.fromFile(entity.path);
        await brp.load();
        brushes.add(brp);
      } catch (e) {
        print(
            "reading brush ${entity.path} in collection $dirPath failed as: $e");
      }
    }
    return brushes;
  }

  BrushPreset? getBrush(String _brushName) {
    String collection = getCollectNameFromBrushName(_brushName);
    String brushName = getBrushName(_brushName);
    print("searching for brush: $collection $brushName");
    for (var collectname in library.keys) {
      if (collection != collectname && collection != ".") {
        continue;
      }
      print("searching in $collectname");
      var brushes = library[collectname];
      for (var brush in brushes!) {
        print("checking brush: ${brush.brushName}");
        if (brush.brushName == brushName) {
          return brush;
        }
      }
    }
  }
}
