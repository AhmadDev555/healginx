import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healginx/core/features/singleton.dart';
import 'package:healginx/features/chatBot_Screen/bloc/chatbot_states.dart';
import 'package:healginx/features/chatBot_Screen/data/models/message_model.dart';
import 'package:healginx/features/chatBot_Screen/data/repositories/chatbot_repository.dart';
import 'package:healginx/features/health_profile/data/models/user_profile_data.dart';

class ChatbotCubit extends Cubit<ChatbotStates> {
  ChatbotCubit(this._chatbotRepository) : super(ChatbotInitial());

  static List<MessageToAndFromAPI> messageList = [];

  final ChatbotRepository _chatbotRepository;
  bool hasProfileContext = false;

  List<MessageToAndFromAPI> get visibleMessages {
    return messageList.where((message) => !message.hidden).toList();
  }

  Future<void> initializeChatbot() async {
    emit(ChatbotProfileLoading());

    try {
      final profile = await _chatbotRepository.loadProfileData();
      Singleton.userProfileData = profile;
      hasProfileContext = profile != null;
      messageList = _buildInitialMessages(profile);
      emit(
        ChatbotReady(
          hasProfile: hasProfileContext,
          messages: visibleMessages,
        ),
      );
    } catch (_) {
      Singleton.userProfileData = null;
      hasProfileContext = false;
      messageList = _buildInitialMessages(null);
      emit(
        ChatbotReady(
          hasProfile: false,
          messages: visibleMessages,
        ),
      );
    }
  }

  Future<void> AIOpenApi({String? message}) async {
    await sendMessage(message ?? '');
  }

  Future<void> sendMessage(String message) async {
    final text = message.trim();
    if (text.isEmpty) return;

    if (messageList.isEmpty) {
      messageList = _buildInitialMessages(Singleton.userProfileData);
    }

    messageList.add(MessageToAndFromAPI(role: 'user', content: text));
    emit(ChatbotLoading());

    final startedAt = DateTime.now();
    final response = await _chatbotRepository.AIOpenApi(
      messagesList: messageList,
    );
    final elapsed = DateTime.now().difference(startedAt);
    const minimumTypingTime = Duration(seconds: 2);
    if (elapsed < minimumTypingTime) {
      await Future.delayed(minimumTypingTime - elapsed);
    }

    if (response.model != null) {
      messageList.add(
        MessageToAndFromAPI(
          role: 'assistant',
          content: response.model!.choices.last.message.content,
        ),
      );
      emit(
        ChatbotSuccess(
          chatModelResponse: response.model!,
          messages: visibleMessages,
        ),
      );
    } else {
      emit(ChatbotFailure(error: response.error.toString()));
    }
  }

  List<MessageToAndFromAPI> _buildInitialMessages(UserProfileData? profile) {
    return [
      MessageToAndFromAPI(
        role: 'system',
        hidden: true,
        content: _baseNutritionPrompt(hasProfile: profile != null),
      ),
      MessageToAndFromAPI(
        role: 'system',
        hidden: true,
        content: profile == null
            ? _missingProfilePrompt()
            : _profileContextPrompt(profile),
      ),
    ];
  }

  String _baseNutritionPrompt({required bool hasProfile}) {
    return '''
You are Healginx AI, a careful diet and nutrition assistant.
Scope:
- Help only with diet plans, food choices, calories, macros, grocery ideas, hydration, meal timing, and healthy habits.
- If the user asks about non-nutrition topics, briefly say you can only help with nutrition and guide them back.
- Do not diagnose disease, prescribe medicine, or replace a doctor. For medical conditions, give general nutrition guidance and advise professional care when needed.
- Keep answers practical, structured, and easy to follow.
- Prefer simple Pakistani/desi food options when appropriate.
- If saved profile data is available, personalize every answer with it.
- If saved profile data is not available, collect the missing profile first before giving a detailed diet plan.

Response rules:
- Ask at most two profile questions at a time when data is missing.
- Never invent age, weight, goal, activity level, allergies, or medical conditions.
- For diet plans, include meals, portion guidance, hydration, and one safety note.

Static test cases:
1. User: "Make me a weight loss diet plan." If profile exists, create a plan from the profile. If no profile exists, ask for age, gender, height, weight, goal, activity level, diet type, restrictions, meals per day, and medical issues.
2. User: "Write Flutter code." Assistant: "I can help with nutrition and diet planning only. Tell me your meal goal or health profile."
3. User: "I have diabetes, what should I eat?" Assistant: Give general balanced meal guidance, recommend monitoring blood sugar, and suggest consulting a clinician.
4. User: "Can I eat biryani?" Assistant: Answer with portion control and healthier pairing options, based on profile if available.

Current profile availability: ${hasProfile ? 'saved profile is available' : 'saved profile is not available'}.
''';
  }

  String _missingProfilePrompt() {
    return '''
No saved health profile was found for this user.
Start the conversation as a diet nutritionist and ask for the minimum required data before making a detailed plan:
full name optional, age, gender, height, weight, primary goal, target weight if any, activity level, diet strictness, diet type, food restrictions, meals per day, eating style, eating window, appetite level, routine, medical conditions, allergies, medications, and weekly tracking preference.
Ask naturally and in small batches. If the user gives partial data, remember it in conversation and continue with the remaining questions.
''';
  }

  String _profileContextPrompt(UserProfileData profile) {
    final map = profile.toMap();
    final lines = map.entries.map((entry) {
      final value = entry.value;
      final display = value is List ? value.join(', ') : value?.toString();
      return '${entry.key}: ${display == null || display.isEmpty ? 'not provided' : display}';
    }).join('\n');

    return '''
Saved health profile for this user:
$lines

Use this saved profile as the user's baseline context. If the user later updates any detail in chat, use the newer chat detail for that answer.
''';
  }
}
