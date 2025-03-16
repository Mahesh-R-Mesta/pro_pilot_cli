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
}
