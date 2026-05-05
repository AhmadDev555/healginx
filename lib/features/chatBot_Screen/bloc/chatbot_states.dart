import 'package:healginx/features/chatBot_Screen/data/models/chatbot_model.dart';

abstract class ChatbotStates {}

class ChatbotInitial extends ChatbotStates {}

class ChatbotLoading extends ChatbotStates {}

class ChatbotSuccess extends ChatbotStates {
  final ChatCompletionResponse chatModelResponse;

  ChatbotSuccess({required this.chatModelResponse});
}

class ChatbotFailure extends ChatbotStates {
  final String? error;
  ChatbotFailure({required this.error});
}