import 'dart:convert';

import 'package:pro_pilot/ai/base_ai_service.dart';
import 'package:pro_pilot/env_loader.dart';
import 'package:pro_pilot/model.dart';
import 'package:pro_pilot/promp.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_gemini/flutter_gemini.dart';
import 'dart:io' as io;

import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService extends AIService {
  String? clean(String? response) {
    return response?.replaceAll("```json", "").replaceAll("```", "");
  }

  List<Content>? history = [];

  @override
  Future<AIResponse?> getCompletions(String prompt) async {
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
        systemInstruction: Content.system(Prompt.systemInstruction),
      );

      final chat = model.startChat(history: []);
      final content = Content.text(prompt);
      final response = await chat.sendMessage(content);
      history?.add(content);
      history?.add(Content.system(response.text ?? ''));
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
}
