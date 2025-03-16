import 'dart:io';

import 'package:pro_pilot/folder_setup_tool.dart';

class AppEnv {
  static Map<String, String> env = {};

  static load({String fileName = '.env'}) async {
    final path = FolderSetupTool.getProjectPath(fileName);
    final file = File(path);
    final lines = await file.readAsLines();
    for (final line in lines) {
      final keyValue = line.split("=").map((value) => value.trim());
      env[keyValue.first] = keyValue.last;
    }
  }
}
