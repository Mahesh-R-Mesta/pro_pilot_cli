import 'dart:io' as io;

import 'package:colorful_text/colorful_text.dart';

abstract class Builder {
  String getProjectName() {
    io.stdout.write("💻 Enter the project name: ");
    String? projectName = io.stdin.readLineSync();
    if (projectName == null) {
      io.stderr.write(ColorfulText.paint("\n☠️ Project name not found !!!", ColorfulText.red));
      io.exit(1);
    }
    return projectName;
  }

  build();
}
