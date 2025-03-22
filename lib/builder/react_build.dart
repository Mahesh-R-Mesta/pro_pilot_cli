import 'package:pro_pilot/ai/base_ai_service.dart';
import 'package:pro_pilot/builder/base_builder.dart';
import 'package:pro_pilot/folder_setup_tool.dart';
import 'package:pro_pilot/prompt.dart';
import 'dart:io' as io;

import 'package:colorful_text/colorful_text.dart';

class ReactBuilder extends Builder {
  AIService aiService;
  ReactBuilder(this.aiService);

  @override
  build() async {
    final projectName = getProjectName();
    io.stdout.write("It might take some time please wait...");
    final result = await io.Process.run(executable, [exitType, 'npx', 'create-react-app', projectName], runInShell: true);
    io.stdout.write(ColorfulText.paint(result.stdout, ColorfulText.green));
    if (result.exitCode != 0) {
      return io.stderr.write(ColorfulText.paint("\n☠️ Failed to create project -> ${result.stderr}", ColorfulText.red));
    } else {
      io.stdout.write(ColorfulText.paint("\n👏 Project creation done\n ", ColorfulText.green));
    }

    String? description = getDescription();

    final response = await aiService.getCompletions(Prompt.template(
      project: "react",
      projectName: projectName,
      stateManagement: 'redux',
      description: description,
    ));
    await FolderSetupTool.createDirectories(projectName: projectName, snippets: response?.snippets ?? []);

    if (response?.packages.isNotEmpty == true) {
      final allPackages = response!.packages.join(" ");
      io.stdout.write("Installing packages\n");
      var path = FolderSetupTool.getProjectPath(projectName);
      io.stdout.write(path);
      final out = await io.Process.run(executable, [exitType, 'npm', 'install', allPackages], workingDirectory: "$path\\");
      if (out.exitCode == 0) {
        io.stdout.write(ColorfulText.paint(out.stdout, ColorfulText.green));
      } else {
        io.stdout.write(ColorfulText.paint(out.stderr, ColorfulText.red));
        io.stdout.write(ColorfulText.paint('run this -> npm install $allPackages', ColorfulText.blue));
      }
    }
    io.stdout.write("\nAll the Best for your project 😂");
  }
}
