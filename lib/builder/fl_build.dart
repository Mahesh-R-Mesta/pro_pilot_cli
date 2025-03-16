import 'package:pro_pilot/ai/base_ai_service.dart';
import 'package:pro_pilot/folder_setup_tool.dart';
import 'package:pro_pilot/builder/builder.dart';
import 'dart:io' as io;

import 'package:pro_pilot/prompt.dart';
import 'package:colorful_text/colorful_text.dart';

class FlBuilder extends Builder {
  // final openAIService = OpenAIService();
  AIService aiService;
  FlBuilder(this.aiService);

  @override
  build() async {
    String? projectName = getProjectName();

    final result = await io.Process.run(executable, [exitType, 'flutter', 'create', projectName]);
    io.stdout.write(ColorfulText.paint(result.stdout, ColorfulText.green));
    if (result.exitCode != 0) {
      return io.stderr.write(ColorfulText.paint("\n☠️ Failed to create project -> ${result.stderr}", ColorfulText.red));
    } else {
      io.stdout.write(ColorfulText.paint("\n👏 Project creation done ", ColorfulText.green));
    }

    var packages = ['provider', 'flutter_bloc bloc', 'get'];
    var options = ['Provider', 'Bloc', 'GetX'];
    io.stdout.write(ColorfulText.paint("\n1. Provider\n2. Bloc\n3. GetX ", ColorfulText.yellow));
    io.stdout.write("\nEnter state-management tool you will use (Enter the number): ");
    int index = 1;
    try {
      index = int.parse(io.stdin.readLineSync()!);
      var path = FolderSetupTool.getProjectPath(projectName);

      final out = await io.Process.run(executable, [exitType, 'dart pub add ${packages[index - 1]}'], workingDirectory: "$path/");
      //'dart', 'pub', 'add', packages[index]
      print(out.stdout);
    } catch (error) {
      io.stderr.write("☠️ error $error");
      io.exit(1);
    }

    String? description = getDescription();

    final response = await aiService.getCompletions(Prompt.template(
      project: "flutter",
      projectName: projectName,
      stateManagement: options[index - 1],
      description: description,
    ));
    print(response);
    await FolderSetupTool.createDirectories(projectName: projectName, snippets: response?.snippets ?? []);
    var path = FolderSetupTool.getProjectPath(projectName);
    if (response?.packages.isNotEmpty == true) {
      final pkg = response!.packages;
      if (pkg.contains("flutter")) pkg.remove("flutter");
      if (pkg.contains("flutter_test")) pkg.remove("flutter_test");
      if (pkg.contains(options[index - 1])) pkg.remove(options[index - 1]);
      final out = await io.Process.run(executable, [exitType, 'dart pub add ', ...pkg], workingDirectory: path);
      io.stdout.write(out.stdout);
    }
    io.stdout.write("All the Best for your project 😂😂😂");
  }
}
