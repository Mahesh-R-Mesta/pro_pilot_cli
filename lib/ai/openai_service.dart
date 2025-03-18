import 'dart:convert';

import 'package:pro_pilot/ai/base_ai_service.dart';
import 'package:pro_pilot/env_loader.dart';
import 'package:pro_pilot/model.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:pro_pilot/prompt.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenAIService extends AIService {
  String model;

  OpenAIService({this.model = 'gpt-4o-mini'}) {
    OpenAI.apiKey = AppEnv.env['OPEN_AI_KEY']!; //dotenv.env['OPEN_AI_KEY']!;
    OpenAI.requestsTimeOut = Duration(seconds: 10);
    OpenAI.showLogs = true;
    OpenAI.showResponsesLogs = true;
  }

  Future showAvailableModels() async {
    final models = await OpenAI.instance.model.list();
    models.forEach(print);
  }

  @override
  Future<AIResponse?> getCompletions(String prompt, {String instruction = Prompt.projectSetupInstruction}) async {
    final completion = await OpenAI.instance.completion.create(
      model: model,
      suffix: Prompt.projectSetupInstruction,
      prompt: prompt,
      temperature: 0.9,
    );
    String? payload = completion.choices.first.finishReason;
    print(payload);
    if (payload != null) {
      final map = json.decode(payload) as Map<dynamic, dynamic>;
      print(map);
      final values = map[map.keys.first] as List<Map<dynamic, dynamic>>;
      final snippets = values.map((data) => Snippet.fromJson(data)).toList();
      return (snippets: snippets, packages: []);
    }
    return null;
  }
}
