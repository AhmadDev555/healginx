import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healginx/features/chatBot_Screen/bloc/chatbot_states.dart';
import 'package:healginx/features/chatBot_Screen/data/repositories/chatbot_repository.dart';

import '../data/models/message_model.dart';

class ChatbotCubit extends Cubit<ChatbotStates> {

  ChatbotCubit(this._chatbotRepository) : super(ChatbotInitial());

  List<MessageToAndFromAPI> messageList = [];

  final ChatbotRepository _chatbotRepository;

  Future<void> AIOpenApi({String? message}) async {

    try{
      emit(ChatbotLoading());

      messageList.add(
          MessageToAndFromAPI(
            role: "user",
            content: message??"",
          )
      );

      final response = await _chatbotRepository.AIOpenApi(message: message, messagesList: messageList);
      if(response.model != null) {
        messageList.add(
            MessageToAndFromAPI(
              role: "assistant",
              content: response.model?.choices.last.message.content??"",
            )
        );
        emit(ChatbotSuccess(chatModelResponse: response.model!));
      }
      else {
        emit(ChatbotFailure(error: response.error.toString()));
      }
    }catch (e){
      emit(ChatbotFailure(error: e.toString()));
    }

  }
}