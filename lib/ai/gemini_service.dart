import 'dart:convert';

import 'package:colorful_text/colorful_text.dart';
import 'package:hive/hive.dart';
import 'package:pro_pilot/ai/base_ai_service.dart';
import 'package:pro_pilot/model.dart';
import 'package:pro_pilot/prompt.dart';
import 'dart:io' as io;

import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService extends AIService {
  final key = 'GEMINI_API_KEY';
  String? apiKey;
  String? clean(String? response) {
    return response?.replaceAll("```json", "").replaceAll("```", "").replaceAll(r"\$", r"$");
  }

  List<Content> history = [];

  @override
  Future<String?> loadApiKey() async {
    final box = await Hive.openBox('credential');
    apiKey = box.get(key);
    if (apiKey == null) {
      io.stdout.write("Enter your gemini api key (Stored securely on system) :");
      final apiKey = io.stdin.readLineSync();
      if (apiKey != null) await box.put(key, apiKey);
      return apiKey;
    }
    return apiKey;
  }

  @override
  Future<AIResponse?> getCompletions(String prompt, {String instruction = Prompt.projectSetupInstruction}) async {
    try {
      io.stdout.write('$prompt\n');
      if (apiKey == null) await loadApiKey();
      final model = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: apiKey!,
        generationConfig: GenerationConfig(
          temperature: 1.5,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 8192,
          responseMimeType: 'application/json',
        ),
        systemInstruction: Content.system(instruction),
      );

      final chat = model.startChat(history: []);
      final content = Content.text(prompt);
      final response = await chat.sendMessage(content);
      history.addAll(chat.history.toList());
      final data = response.text;
      if (data != null) {
        final map = json.decode(clean(data)!) as Map<String, dynamic>;
        io.stdout.write(ColorfulText.paint(map["files"].toString(), ColorfulText.green));
        io.stdout.write(ColorfulText.paint(map['packages'].toString(), ColorfulText.white));
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
}
