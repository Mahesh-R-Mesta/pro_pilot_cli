import 'package:pro_pilot/model.dart';

typedef AIResponse = ({List<Snippet> snippets, List<dynamic> packages});

abstract class AIService {
  Future<AIResponse?> getCompletions(String prompt);
}
