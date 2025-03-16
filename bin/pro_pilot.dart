import 'dart:io';
import 'package:pro_pilot/ai/base_ai_service.dart';
import 'package:pro_pilot/ai/gemini_service.dart';
import 'package:pro_pilot/builder/builder.dart';
import 'package:pro_pilot/builder/fl_build.dart';
import 'package:pro_pilot/builder/react_build.dart';
import 'package:args/args.dart';
import 'package:colorful_text/colorful_text.dart';
import 'dart:io' as io;

import 'package:pro_pilot/env_loader.dart';

void main(List<String> arguments) async {
  // await io.Process.run("clear", []);
  await AppEnv.load();
  io.stdout.write(ColorfulText.paint("----- AI project setup -----\n", ColorfulText.yellow));

  final args = ArgParser();
  args.parse(arguments);

  if (arguments.isEmpty) {
    io.stdout.write("""Help
      flutter  - create flutter project
      react  - create react project\n""");
    io.stdout.write(ColorfulText.paint("No command found\n", ColorfulText.red));
    exit(1);
  }

  Builder builder;

  AIService aiService = GeminiService(); // OpenAIService();

  switch (arguments[0]) {
    case 'flutter':
      builder = FlBuilder(aiService);
      break;
    case 'react':
      builder = ReactBuilder(aiService);
      break;
    default:
      io.stdout.write("""Help
      flutter  - create flutter project
      react  - create react project""");
      exit(1);
  }

  await builder.build();
  exit(0);
}
