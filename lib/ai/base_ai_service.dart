import 'package:pro_pilot/model.dart';

typedef AIResponse = ({List<Snippet> snippets, List<dynamic> packages});

abstract class AIService {
  Future<void> loadHistory(String projectName) async {}
  Future<AIResponse?> getCompletions(String prompt, {String instruction = ''});

  Future<void> close() async {}
}
