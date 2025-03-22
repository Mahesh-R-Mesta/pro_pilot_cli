import 'package:pro_pilot/model.dart';

typedef AIResponse = ({List<Snippet> snippets, List<dynamic> packages});

abstract class AIService {
  Future<String?> loadApiKey();
  Future<AIResponse?> getCompletions(String prompt, {String instruction = ''});

  Future<void> close() async {}
}
