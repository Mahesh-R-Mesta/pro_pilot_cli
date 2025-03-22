import 'dart:io';
import 'package:hive/hive.dart';
import 'package:pro_pilot/ai/base_ai_service.dart';
import 'package:pro_pilot/ai/gemini_service.dart';
import 'package:pro_pilot/builder/base_builder.dart';
import 'package:pro_pilot/builder/fl_build.dart';
import 'package:pro_pilot/builder/react_build.dart';
import 'package:colorful_text/colorful_text.dart';
import 'dart:io' as io;

void main(List<String> arguments) async {
  // if no argument return
  if (arguments.isEmpty) {
    return io.stderr.write(ColorfulText.paint("""
    !No arguments provided

    Help!
    flutter - create flutter project
    react - create react project""", ColorfulText.yellow));
  }

  io.stdout.write(ColorfulText.paint("----- AI boilerplate project setup -----\n", ColorfulText.yellow));
  Hive.init(Directory.systemTemp.path);
  Builder builder;

  AIService aiService = GeminiService(); // OpenAIService();

  await aiService.loadApiKey();

  switch (arguments[0]) {
    case 'flutter':
      builder = FlBuilder(aiService);
      break;
    case 'react':
      builder = ReactBuilder(aiService);
      break;
    default:
      io.stderr.write(ColorfulText.paint("""
      !Invalid command

      Help
      flutter - create flutter project
      react - create react project""", ColorfulText.red));
      exit(1);
  }

  await builder.build(); // start build process
  exit(0);
}
