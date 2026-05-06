class MessageToAndFromAPI {
  final String role;
  final String content;
  final bool hidden;

  MessageToAndFromAPI({
    required this.role,
    required this.content,
    this.hidden = false,
  });

  Map<String, String> toJson() {
    return {
      "role": role,
      "content": content,
    };
  }
}
