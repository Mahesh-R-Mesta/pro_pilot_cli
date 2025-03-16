import 'package:pro_pilot/ai/base_ai_service.dart';
import 'package:pro_pilot/builder/builder.dart';
import 'package:pro_pilot/folder_setup_tool.dart';
import 'package:pro_pilot/promp.dart';
import 'dart:io' as io;

import 'package:colorful_text/colorful_text.dart';

class ReactBuilder extends Builder {
  AIService aiService;
  ReactBuilder(this.aiService);

  @override
  build() async {
    final projectName = getProjectName();
    final result = await io.Process.run('cmd', ['/c', 'npx', 'create-react-app', projectName]);
    io.stdout.write(ColorfulText.paint(result.stdout, ColorfulText.green));
    if (result.exitCode != 0) {
      return io.stderr.write(ColorfulText.paint("\n☠️ Failed to create project -> ${result.stderr}", ColorfulText.red));
    } else {
      io.stdout.write(ColorfulText.paint("\n👏 Project creation done ", ColorfulText.green));
    }

    io.stdout.write(ColorfulText.paint("Write short description about project in one line: ", ColorfulText.yellow));
    String? description = io.stdin.readLineSync();

    final response = await aiService.getCompletions(Prompt.template3(
      project: "react",
      projectName: projectName,
      stateManagement: 'redux',
      description: description ?? "No description",
    ));
    print(response);
    await FolderSetupTool.createDirectories(projectName: projectName, snippets: response?.snippets ?? []);

    io.stdout.write("All the Best for your project 😂");
  }
}
