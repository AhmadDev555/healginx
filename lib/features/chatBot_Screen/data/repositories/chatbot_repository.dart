import 'package:healginx/constants/api_constants.dart';
import 'package:healginx/core/api_client/api_service_interface/i_api_service.dart';

class ChatbotRepository {
  final ApiService _apiService;

  ChatbotRepository({required ApiService apiService}) : _apiService = apiService;

  Future<({Exception? error,Null? model})> AIOpenApi({required String? message,}) async {

    try {

      var response = await _apiService.post(
          ApiConstants.groqAIModel,
          data: {
            "model": "llama-3.1-8b-instant",
            "messages": [
              {
                "role": "system",
                "content": "You are a helpful assistant."
              },
              {
                "role": "user",
                "content": "Explain Flutter state management in simple terms."
              }
            ],
            "temperature": 0.7,
            "max_tokens": 512
          }
      );
      if(response["status"] == 400){
        throw(Exception(response["message"]));
      }

      return (error:null,model: null);
    }
    catch(e){
      return (error:e as Exception,model:null);
    }
  }

}