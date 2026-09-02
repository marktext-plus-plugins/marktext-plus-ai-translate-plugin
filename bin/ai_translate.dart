import 'dart:async';
import 'dart:convert';
import 'dart:io';

String? provider;
Uri? endpoint;
String? model;
String? apiKey;

Future<void> main() async {
  var queue = Future<void>.value();
  final done = Completer<void>();
  stdin.transform(utf8.decoder).transform(const LineSplitter()).listen(
    (line) {
      queue = queue.then((_) => _handle(line));
    },
    onDone: () => done.complete(),
    onError: done.completeError,
  );
  await done.future;
  await queue;
}

Future<void> _handle(String line) async {
  final request = jsonDecode(line) as Map<String, dynamic>;
  final id = request['id'];
  if (id is! int) return;
  try {
    final method = request['method'] as String?;
    final params = Map<String, dynamic>.from(request['params'] as Map? ?? const {});
    final result = switch (method) {
      'initialize' => _initialize(params),
      'translate' => await _translate(params),
      'shutdown' => _shutdown(),
      _ => throw FormatException('unknown method: $method'),
    };
    stdout.writeln(jsonEncode({'jsonrpc': '2.0', 'id': id, 'result': result}));
  } catch (error) {
    stderr.writeln('[ERROR] $error');
    stdout.writeln(jsonEncode({'jsonrpc': '2.0', 'id': id, 'error': {'message': '$error'}}));
  }
}

Map<String, dynamic> _initialize(Map<String, dynamic> params) {
  final configuredProvider = params['provider'] as String?;
  final configuredEndpoint = params['endpoint'] as String?;
  final configuredModel = params['model'] as String?;
  final configuredKey = params['apiKey'] as String?;
  if (configuredProvider == null || configuredEndpoint == null || configuredModel == null || configuredKey == null) {
    throw const FormatException('initialize requires provider, endpoint, model and apiKey');
  }
  provider = configuredProvider;
  endpoint = Uri.tryParse(configuredEndpoint);
  model = configuredModel;
  apiKey = configuredKey;
  if (endpoint == null || !(endpoint!.isScheme('https') || endpoint!.isScheme('http'))) {
    throw const FormatException('endpoint must use http or https');
  }
  return {'ready': true};
}

Future<String> _translate(Map<String, dynamic> params) async {
  final text = params['text'] as String?;
  final target = params['targetLanguage'] as String?;
  if (text == null || target == null || text.isEmpty || target.isEmpty) {
    throw const FormatException('translate requires text and targetLanguage');
  }
  if (provider == null || endpoint == null || model == null || apiKey == null) {
    throw StateError('plugin is not initialized');
  }
  final client = HttpClient();
  try {
    final request = await client.postUrl(endpoint!);
    request.headers.contentType = ContentType.json;
    request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $apiKey');
    if (provider == 'anthropic') {
      request.headers.removeAll(HttpHeaders.authorizationHeader);
      request.headers.set('x-api-key', apiKey!);
      request.headers.set('anthropic-version', '2023-06-01');
      request.write(jsonEncode({'model': model, 'max_tokens': 4096, 'messages': [
        {'role': 'user', 'content': 'Translate the following Markdown to $target. Preserve Markdown syntax and return only the translation.\\n\\n$text'},
      ]}));
    } else {
      request.write(jsonEncode({'model': model, 'messages': [
        {'role': 'system', 'content': 'Translate Markdown while preserving its syntax. Return only the translation.'},
        {'role': 'user', 'content': 'Target language: $target\\n\\n$text'},
      ]}));
    }
    final response = await request.close();
    final body = jsonDecode(await utf8.decoder.bind(response).join()) as Map<String, dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException('AI provider returned ${response.statusCode}');
    }
    if (provider == 'anthropic') {
      final content = body['content'] as List?;
      final first = content?.whereType<Map>().firstOrNull;
      final value = first?['text'];
      if (value is String) return value;
    } else {
      final choices = body['choices'] as List?;
      final message = choices?.whereType<Map>().firstOrNull?['message'];
      final value = message is Map ? message['content'] : null;
      if (value is String) return value;
    }
    throw const FormatException('AI provider response had no text');
  } finally {
    client.close(force: true);
  }
}

Map<String, dynamic> _shutdown() {
  apiKey = null;
  exit(0);
}
