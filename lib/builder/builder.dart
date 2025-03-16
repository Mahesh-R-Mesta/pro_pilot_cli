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

  String getDescription() {
    String? description;
    do {
      io.stdout.write(ColorfulText.paint(
        """(AI) Write about your project!
        1) About features you will be using (Optional)
        2) About Boilerplate code which you need (Optional)
        3) About Specify folder structure which you want (Optional):\n""",
        ColorfulText.yellow,
      ));
      description = io.stdin.readLineSync();
    } while (description == null);
    return description;
  }

  String get executable => io.Platform.isWindows
      ? 'cmd'
      : io.Platform.isLinux
          ? 'bash'
          : '';
  String get exitType => io.Platform.isWindows
      ? '/c'
      : io.Platform.isLinux
          ? '-c'
          : '';

  build();
}
