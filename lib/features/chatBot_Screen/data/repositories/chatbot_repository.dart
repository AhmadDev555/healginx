import 'package:healginx/constants/api_constants.dart';
import 'package:healginx/core/api_client/api_service_interface/i_api_service.dart';
import 'package:healginx/features/chatBot_Screen/data/models/chatbot_model.dart';

class ChatbotRepository {
  final ApiService _apiService;

  ChatbotRepository({required ApiService apiService}) : _apiService = apiService;

  Future<({Exception? error,ChatCompletionResponse? model})> AIOpenApi({required String? message,required List messagesList}) async {

    try {

      var response = await _apiService.post(
          ApiConstants.groqAIModel,
          data: {
            "model": "llama-3.1-8b-instant",
            "temperature": 0.7,
            "max_tokens": 400,
            "messages": messagesList,
            // [
            //   {
            //     "role": "system",
            //     "content": "You are a certified nutritionist. Generate structured diet plans in simple bullet points."
            //   },
            //   {
            //     "role": "user",
            //     "content": "22M, 70kg, muscle gain, 4 meals, desi food"
            //   }
            // ]
          }
      );

      return (error:null,model: ChatCompletionResponse.fromJson(response));
    }
    catch(e){
      return (error:e as Exception,model:null);
    }
  }

}