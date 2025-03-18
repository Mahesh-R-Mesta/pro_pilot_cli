import 'dart:convert';

import 'package:pro_pilot/ai/base_ai_service.dart';
import 'package:pro_pilot/env_loader.dart';
import 'package:pro_pilot/folder_setup_tool.dart';
import 'package:pro_pilot/model.dart';
import 'package:pro_pilot/prompt.dart';
import 'dart:io' as io;
import 'package:path/path.dart' as path;

import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService extends AIService {
  String? clean(String? response) {
    return response?.replaceAll("```json", "").replaceAll("```", "");
  }

  io.File? file;

  List<Content> history = [];

  @override
  Future<void> loadHistory(String projectName) async {
    final directoryPath = path.join(FolderSetupTool.getProjectPath(projectName), 'gemini_history.json');
    print(directoryPath);
    file = io.File(directoryPath);
    if (!file!.existsSync()) {
      await file!.create(recursive: true);
    }

    try {
      final data = await file!.readAsString();
      if (data.isNotEmpty) {
        final contents = json.decode(data) as List<Map<String, dynamic>>;
        try {
          history.addAll(contents.map((map) {
            if (map['role'] == 'user') {
              return Content.multi((map['parts'] as List<Map>).map((m) => TextPart(m['text'])).toList());
            }
            return Content.model((map['parts'] as List<Map>).map((m) => TextPart(m['text'])).toList());
          }).toList());
        } catch (error) {
          io.stderr.write(error.toString());
        }
      }
    } catch (error) {
      io.stderr.write(error.toString());
    }
  }

  @override
  Future<AIResponse?> getCompletions(String prompt, {String instruction = Prompt.projectSetupInstruction}) async {
    try {
      final model = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: AppEnv.env['GEMINI_API_KEY']!, //dotenv.env['GEMINI_API_KEY']!,
        generationConfig: GenerationConfig(
          temperature: 1.5,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 8192,
          responseMimeType: 'application/json',
        ),
        systemInstruction: Content.system(Prompt.projectSetupInstruction),
      );

      final chat = model.startChat(history: []);
      final content = Content.text(prompt);
      final response = await chat.sendMessage(content);
      history.addAll(chat.history.toList());
      final data = response.text;
      print(clean(data));
      if (data != null) {
        final map = json.decode(clean(data)!) as Map<String, dynamic>;
        print(map["files"]);
        print(map['packages']);
        final values = map["files"] as List<dynamic>;
        final packages = map['packages'] as List<dynamic>;
        List<Snippet> snippets = [];
        for (var value in values) {
          try {
            snippets.add(Snippet.fromJson(value));
          } catch (error) {
            io.stderr.write(error.toString());
          }
        }
        return (snippets: snippets, packages: packages);
      }
    } catch (error) {
      io.stderr.write(error.toString());
    }
    return null;
  }

  @override
  Future<void> close() async {
    try {
      await file?.writeAsString(json.encode(history.map((content) => content.toJson()).toList()));
    } catch (error) {
      io.stderr.write(error.toString());
    }
  }
}
