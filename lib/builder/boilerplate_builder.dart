import 'dart:convert';

import 'package:colorful_text/colorful_text.dart';
import 'package:pro_pilot/ai/base_ai_service.dart';
import 'package:pro_pilot/builder/base_builder.dart';
import 'package:pro_pilot/folder_setup_tool.dart';
import 'package:pro_pilot/prompt.dart';
import 'dart:io' as io;
import 'package:path/path.dart' as p;

class BoilerPlateGenerator extends Builder {
  AIService aiService;
  BoilerPlateGenerator(this.aiService);
  @override
  build() async {
    String? projectName;
    String? projectType;

    await for (final entity in io.Directory.current.list()) {
      if (p.basename(entity.path) == "pubspec.yaml") {
        final lines = await io.File(entity.path).readAsLines();
        projectName = lines[0].split(":").last.trim();
        projectType = 'flutter';
      } else if (p.basename(entity.path) == "package.json") {
        final content = await io.File(entity.path).readAsString();
        projectName = json.decode(content)['name'];
        projectType = 'react';
      }
    }

    if (projectName == null && projectType == null) {
      return io.stderr.write(ColorfulText.paint("""!No project found
Please make sure you are running command inside project folder""", ColorfulText.red));
    }
    final folders = FolderSetupTool.retrieveProjectDirectories();

    String? userPrompt;
    do {
      io.stdout.write(ColorfulText.paint(
        """AI: Tell me what boilerplate code you need for your project and also specify project folder too: """,
        ColorfulText.yellow,
      ));
      userPrompt = io.stdin.readLineSync();
    } while (userPrompt == null);

    final response = await aiService.getCompletions(
      Prompt.template2(
        projectType: projectType,
        projectName: projectName,
        folders: folders,
        prompt: userPrompt,
      ),
      instruction: Prompt.boilerplateSetupInstruction,
    );
    await FolderSetupTool.createDirectories(snippets: response?.snippets ?? []);
    if (response?.packages.isNotEmpty == true) {
      if (projectType == 'flutter') {
        final pkg = response!.packages;
        if (pkg.contains("flutter")) pkg.remove("flutter");
        if (pkg.contains("flutter_test")) pkg.remove("flutter_test");
        final out = await io.Process.run(executable, [exitType, 'dart pub add ', ...pkg]);
        io.stdout.write(out.stdout);
      } else {
        final allPackages = response!.packages.join(" ");
        io.stdout.write(ColorfulText.paint('run this -> npm install $allPackages', ColorfulText.blue));
      }
    }
  }
}
