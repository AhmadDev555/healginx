class ChatCompletionResponse {
  final String id;
  final String object;
  final int created;
  final String model;
  final List<Choice> choices;
  final Usage usage;
  final String systemFingerprint;

  ChatCompletionResponse({
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required this.choices,
    required this.usage,
    required this.systemFingerprint,
  });

  factory ChatCompletionResponse.fromJson(Map<String, dynamic> json) {
    return ChatCompletionResponse(
      id: json['id'],
      object: json['object'],
      created: json['created'],
      model: json['model'],
      choices: (json['choices'] as List)
          .map((e) => Choice.fromJson(e))
          .toList(),
      usage: Usage.fromJson(json['usage']),
      systemFingerprint: json['system_fingerprint'] ?? '',
    );
  }
}
class Choice {
  final int index;
  final Message message;
  final String finishReason;

  Choice({
    required this.index,
    required this.message,
    required this.finishReason,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      index: json['index'],
      message: Message.fromJson(json['message']),
      finishReason: json['finish_reason'],
    );
  }
}
class Message {
  final String role;
  final String content;

  Message({
    required this.role,
    required this.content,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      role: json['role'],
      content: json['content'],
    );
  }
}
class Usage {
  final double queueTime;
  final int promptTokens;
  final double promptTime;
  final int completionTokens;
  final double completionTime;
  final int totalTokens;
  final double totalTime;

  Usage({
    required this.queueTime,
    required this.promptTokens,
    required this.promptTime,
    required this.completionTokens,
    required this.completionTime,
    required this.totalTokens,
    required this.totalTime,
  });

  factory Usage.fromJson(Map<String, dynamic> json) {
    return Usage(
      queueTime: (json['queue_time'] ?? 0).toDouble(),
      promptTokens: json['prompt_tokens'],
      promptTime: (json['prompt_time'] ?? 0).toDouble(),
      completionTokens: json['completion_tokens'],
      completionTime: (json['completion_time'] ?? 0).toDouble(),
      totalTokens: json['total_tokens'],
      totalTime: (json['total_time'] ?? 0).toDouble(),
    );
  }
}