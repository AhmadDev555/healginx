import 'package:healginx/constants/api_constants.dart';
import 'package:healginx/core/api_client/api_service_interface/i_api_service.dart';
import 'package:healginx/features/chatBot_Screen/data/models/chatbot_model.dart';
import 'package:healginx/features/chatBot_Screen/data/models/message_model.dart';
import 'package:healginx/features/health_profile/data/models/user_profile_data.dart';
import 'package:healginx/features/health_profile/data/repositories/health_profile_repository.dart';

class ChatbotRepository {
  final ApiService _apiService;
  final HealthProfileRepository _healthProfileRepository;

  ChatbotRepository({
    required ApiService apiService,
    required HealthProfileRepository healthProfileRepository,
  })  : _apiService = apiService,
        _healthProfileRepository = healthProfileRepository;

  Future<UserProfileData?> loadProfileData() {
    return _healthProfileRepository.loadProfile();
  }

  Future<({Exception? error, ChatCompletionResponse? model})> AIOpenApi({
    required List<MessageToAndFromAPI> messagesList,
  }) async {

    try {

      var response = await _apiService.post(
          ApiConstants.groqAIModel,
          data: {
            "model": "llama-3.1-8b-instant",
            "temperature": 0.7,
            "max_tokens": 650,
            "messages": messagesList.map((message) => message.toJson()).toList(),
          }
      );

      return (error:null,model: ChatCompletionResponse.fromJson(response));
    }
    catch(e){
      return (error:e is Exception ? e : Exception(e.toString()),model:null);
    }
  }

}
