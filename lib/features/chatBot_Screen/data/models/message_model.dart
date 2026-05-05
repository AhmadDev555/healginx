class MessageToAndFromAPI {
  final String role;
  final String content;

  MessageToAndFromAPI({
    required this.role,
    required this.content,
  });

  Map<String, String> toJson() {
    return {
      "role": role,
      "content": content,
    };
  }
}