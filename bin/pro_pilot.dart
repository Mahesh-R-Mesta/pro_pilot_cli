import 'dart:io';
import 'package:args/args.dart';
import 'package:hive/hive.dart';
import 'package:pro_pilot/ai/base_ai_service.dart';
import 'package:pro_pilot/ai/gemini_service.dart';
import 'package:pro_pilot/builder/base_builder.dart';
import 'package:pro_pilot/builder/boilerplate_builder.dart';
import 'package:pro_pilot/builder/fl_build.dart';
import 'package:pro_pilot/builder/react_build.dart';
import 'package:colorful_text/colorful_text.dart';
import 'dart:io' as io;

void main(List<String> arguments) async {
  final firstParser = ArgParser();
  final secondParser = ArgParser();

  firstParser.addCommand("project", secondParser)
    ..addCommand("flutter") // pro_cli project flutter -> creates flutter project
    ..addCommand("react"); // pro_cli project react -> creates react project

  final projectResult = firstParser.parse(arguments);

  secondParser.addCommand('append'); // pro_cli append -> for adding boilerplate for existing project
  final appendResult = secondParser.parse(arguments);

  io.stdout.write(ColorfulText.paint("----- AI boilerplate project setup -----\n", ColorfulText.yellow));
  Hive.init(Directory.systemTemp.path);
  Builder builder;

  AIService aiService = GeminiService(); // OpenAIService();

  await aiService.loadApiKey();
  if (projectResult.command?.name == "project") {
    final subcommand = projectResult.command?.command?.name;
    switch (subcommand) {
      case 'flutter':
        builder = FlBuilder(aiService);
        break;
      case 'react':
        builder = ReactBuilder(aiService);
        break;
      default:
        io.stderr.write(ColorfulText.paint("""
          !Invalid command
          --------------------------------
          flutter - create flutter project
          react - create react project
          boilerplate - generate boilerplate for existing project""", ColorfulText.red));
        exit(1);
    }
  } else if (appendResult.command?.name == "append") {
    builder = BoilerPlateGenerator(aiService);
  } else {
    io.stderr.write(ColorfulText.paint("""
          !Invalid command
          --------------------------------
          "pro_pilot project flutter" - create flutter project
          "pro_pilot project react" - create react project
          "pro_pilot append" - generate boilerplate for existing project""", ColorfulText.red));
    exit(1);
  }

  await builder.build(); // start build process
  exit(0);
}
