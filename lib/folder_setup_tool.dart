import 'dart:io' as io;

import 'package:pro_pilot/model.dart';
import 'package:colorful_text/colorful_text.dart';
import 'package:path/path.dart' as p;

mixin FolderSetupTool {
  static String getProjectPath(String project) => p.join(io.Directory.current.path, project);

  static createDirectories({String? projectName, required List<Snippet> snippets}) async {
    final currentDir = io.Directory.current;
    print(currentDir.path);
    for (final snippet in snippets) {
      try {
        String path;
        if (projectName != null) {
          path = p.join(currentDir.path, projectName, snippet.path, snippet.filename);
        } else {
          path = p.join(currentDir.path, snippet.path, snippet.filename);
        }
        final file = io.File(path);
        if (!file.existsSync()) file.createSync(recursive: true);
        io.stdout.write("${ColorfulText.paint("created $file", ColorfulText.cyan)}\n");
        if (snippet.code != null) await file.writeAsString(snippet.code!);
      } catch (error) {
        io.stderr.write(error.toString());
      }
    }
  }

  static String retrieveProjectDirectories() {
    Set<String> paths = {};
    final path = io.Directory.current.path;
    final fileEntities = io.Directory(path).listSync(recursive: true);
    final ignored = ['.dart_tool', '.vscode', '.git', 'node_modules'];
    for (final entity in fileEntities) {
      final path = entity.path;
      if (!ignored.any((folder) => path.contains(folder))) {
        paths.add(p.dirname(path));
      }
    }
    return paths.join('\n');
  }

  static projectStructure() {
    final subpath = "├── ";
    final endPath = "└── ";
    final dirPath = "│   ";
    final path = io.Directory.current.path;

    final fileEntities = io.Directory(path).listSync(recursive: true);
    final rootPath = (path.split('\\')..removeLast()).join('\\');
    Map<String, dynamic> folderStruct = {};

    final ignored = ['.dart_tool', '.vscode', '.git', 'node_modules'];

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
    return list.join('\n');
  }
}
