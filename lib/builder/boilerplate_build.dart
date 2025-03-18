import 'package:pro_pilot/ai/base_ai_service.dart';
import 'package:pro_pilot/builder/base_builder.dart';
import 'package:pro_pilot/folder_setup_tool.dart';
import 'dart:io' as io;
import 'package:pro_pilot/prompt.dart';

class BoilerPlateBuilder extends Builder {
  AIService aiService;
  BoilerPlateBuilder(this.aiService);
  @override
  build() async {
    final path = io.Directory.current.path;
    final projectStructure = FolderSetupTool.projectStructure();
    String? projectName;
    do {
      io.stdout.write("""🤖 Tell me what boilerplate code needs to be added in your project and
    in which folder you want? \n""");
      projectName = io.stdin.readLineSync();
    } while (projectName == null);
    print(Prompt.projectPrompt(
      path: path,
      projectStructure: projectStructure,
      userPrompt: projectName,
    ));
    final response = await aiService.getCompletions(
        Prompt.projectPrompt(
          path: path,
          projectStructure: projectStructure,
          userPrompt: projectName,
        ),
        instruction: Prompt.boilerplateSetupInstruction);
    await FolderSetupTool.createDirectories(projectName: projectName, snippets: response?.snippets ?? []);
    if (response?.packages.isNotEmpty == true) {
      final pkg = response!.packages;
      if (pkg.contains("flutter")) pkg.remove("flutter");
      if (pkg.contains("flutter_test")) pkg.remove("flutter_test");
      final out = await io.Process.run(executable, [exitType, 'dart pub add ', ...pkg], workingDirectory: path);
      io.stdout.write(out.stdout);
    }
    io.stdout.write("\n Task Completed 🌟. Please verify once");
  }
}
