import 'package:healginx/features/chatBot_Screen/data/models/chatbot_model.dart';
import 'package:healginx/features/chatBot_Screen/data/models/message_model.dart';

abstract class ChatbotStates {}

class ChatbotInitial extends ChatbotStates {}

class ChatbotProfileLoading extends ChatbotStates {}

class ChatbotReady extends ChatbotStates {
  final bool hasProfile;
  final List<MessageToAndFromAPI> messages;

  ChatbotReady({
    required this.hasProfile,
    required this.messages,
  });
}

class ChatbotLoading extends ChatbotStates {}

class ChatbotSuccess extends ChatbotStates {
  final ChatCompletionResponse chatModelResponse;
  final List<MessageToAndFromAPI> messages;

  ChatbotSuccess({
    required this.chatModelResponse,
    required this.messages,
  });
}

class ChatbotFailure extends ChatbotStates {
  final String? error;
  ChatbotFailure({required this.error});
}
