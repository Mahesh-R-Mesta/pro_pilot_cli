// import 'dart:convert';

// import 'package:hive/hive.dart';
// import 'package:pro_pilot/ai/base_ai_service.dart';
// import 'package:pro_pilot/model.dart';
// import 'package:dart_openai/dart_openai.dart';
// import 'package:pro_pilot/prompt.dart';
// import 'dart:io' as io;

// class OpenAIService extends AIService {
//   String model;

//   final String key = 'OPEN_AI_KEY';
//   String? apiKey;

//   @override
//   Future<String?> loadApiKey() async {
//     final box = await Hive.openBox('credential');
//     apiKey = box.get(key);
//     if (apiKey == null) {
//       io.stdout.write("Enter your gemini api key (Stored securely on system) :");
//       final apiKey = io.stdin.readLineSync();
//       if (apiKey != null) await box.put(key, apiKey);
//       return apiKey;
//     }
//     return apiKey;
//   }

//   OpenAIService({this.model = 'gpt-4o-mini'}) {
//     OpenAI.requestsTimeOut = Duration(seconds: 10);
//     OpenAI.showLogs = true;
//     OpenAI.showResponsesLogs = true;
//   }

//   Future showAvailableModels() async {
//     final models = await OpenAI.instance.model.list();
//     models.forEach(print);
//   }

//   @override
//   Future<AIResponse?> getCompletions(String prompt, {String instruction = Prompt.projectSetupInstruction}) async {
//     if (apiKey == null) await loadApiKey();
//     final completion = await OpenAI.instance.completion.create(
//       model: model,
//       suffix: instruction,
//       prompt: prompt,
//       temperature: 0.9,
//     );
//     String? payload = completion.choices.first.finishReason;
//     print(payload);
//     if (payload != null) {
//       final map = json.decode(payload) as Map<dynamic, dynamic>;
//       print(map);
//       final values = map[map.keys.first] as List<Map<dynamic, dynamic>>;
//       final snippets = values.map((data) => Snippet.fromJson(data)).toList();
//       return (snippets: snippets, packages: []);
//     }
//     return null;
//   }
// }
