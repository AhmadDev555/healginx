abstract class ChatbotStates {}

class ChatbotInitial extends ChatbotStates {}

class ChatbotLoading extends ChatbotStates {}

class ChatbotSuccess extends ChatbotStates {
  final ChatbotSuccess loginModel;

  ChatbotSuccess({required this.loginModel});
}

class ChatbotFailure extends ChatbotStates {
  final String? error;
  ChatbotFailure({required this.error});
}