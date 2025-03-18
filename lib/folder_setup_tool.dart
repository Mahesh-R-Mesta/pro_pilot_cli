import 'dart:io' as io;

import 'package:pro_pilot/model.dart';
import 'package:colorful_text/colorful_text.dart';
import 'package:path/path.dart' as path;

mixin FolderSetupTool {
  static String getProjectPath(String project) => path.join(io.Directory.current.path, project);

  static createDirectories({required String projectName, required List<Snippet> snippets}) async {
    final currentDir = io.Directory.current;
    print(currentDir.path);
    for (final snippet in snippets) {
      try {
        final doPathContainFileName = snippet.path.split('.').last == 'dart';
        final file = io.File(path.join(currentDir.path, projectName, snippet.path, !doPathContainFileName ? snippet.filename : ''));
        if (!file.existsSync()) file.createSync(recursive: true);
        io.stdout.write("${ColorfulText.paint("created $file", ColorfulText.cyan)}\n");
        if (snippet.code != null) await file.writeAsString(snippet.code!);
      } catch (error) {
        io.stderr.write(error.toString());
      }
    }
  }

  static projectStructure() {
    final subpath = "├── ";
    final endPath = "└── ";
    final dirPath = "│   ";
    final path = io.Directory.current.path;

    final fileEntities = io.Directory(path).listSync(recursive: true);
    final rootPath = (path.split('\\')..removeLast()).join('\\');
    Map<String, dynamic> folderStruct = {};

    final ignored = ['.dart_tool', '.vscode', '.git'];

    void stackMap(Map<String, dynamic> map, List<String> value, int index) {
      if (index == value.length || ignored.contains(value[index])) {
        return;
      }
      if (!map.containsKey(value[index])) {
        map[value[index]] = <String, dynamic>{};
      }
      stackMap(map[value[index]], value, index + 1);
    }

    List<String> createMap(Map<String, dynamic> map, List<String> structure, int level) {
      final keys = map.keys;
      if (keys.isEmpty) return structure;
      List<String> results = [];
      for (final key in keys) {
        if (level == 0) {
          results.add("$key/");
          results.addAll(createMap(map[key], structure, level + 1));
        } else {
          bool isFile = key.contains('.');
          results.add("${dirPath * (level - 1)}${key == keys.last ? endPath : subpath}$key${!isFile ? '/' : ''}");
          if (!isFile) results.addAll(createMap(map[key], structure, level + 1));
        }
      }
      return results;
    }

    for (final entity in fileEntities) {
      final refinedPath = entity.path.replaceAll("$rootPath\\", '');
      stackMap(folderStruct, refinedPath.split('\\').toList(), 0);
    }
    final list = createMap(folderStruct, [], 0);
    print(list.join('\n'));
    return list.join('\n');
  }
}
