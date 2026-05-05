import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healginx/features/chatBot_Screen/bloc/chatbot_states.dart';
import 'package:healginx/features/chatBot_Screen/data/repositories/chatbot_repository.dart';

class ChatbotCubit extends Cubit<ChatbotStates> {

  ChatbotCubit(this._chatbotRepository) : super(ChatbotInitial());


  final ChatbotRepository _chatbotRepository;

  Future<void> login({String? message}) async {
    emit(ChatbotLoading());

    final response = await _chatbotRepository.AIOpenApi(message: message);
    if(response.model != null) {
      emit(ChatbotSuccess(loginModel: response.model!));
    }
    else {
      emit(ChatbotFailure(error: response.error.toString()));
    }
  }
}