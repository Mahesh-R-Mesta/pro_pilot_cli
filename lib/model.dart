class Snippet {
  final String? package;
  final String path;
  final String? filename;
  final String? code;
  Snippet(this.package, this.path, this.code, this.filename);

  factory Snippet.fromJson(dynamic data) {
    return Snippet(data?['package'], (data['path'] as String).replaceAll('/', r'\'), data['code'], data['filename']);
  }
}
