 import 'package:get_it/get_it.dart';
import 'package:healginx/core/api_client/api_service_imp.dart';
import 'package:healginx/core/api_client/api_service_interface/i_api_service.dart';
import 'package:healginx/core/navigation_service.dart';
import 'package:healginx/features/chatBot_Screen/bloc/chatbot_cubit.dart';
import 'package:healginx/features/chatBot_Screen/data/repositories/chatbot_repository.dart';
import 'package:healginx/features/health_profile/bloc/health_profile_cubit.dart';
import 'package:healginx/features/health_profile/data/repositories/health_profile_repository.dart';
import 'package:healginx/features/login/bloc/login_cubit.dart';
import 'package:healginx/features/login/data/repositories/login_repository.dart';


final sl = GetIt.instance;

Future<void> initDependencies() async {

  sl.registerSingleton<NavigationService>(NavigationService());

  sl.registerLazySingleton<ApiService>(() => DioApiService());

  sl.registerLazySingleton<HealthProfileRepository>(() => HealthProfileRepository());
  sl.registerLazySingleton<ChatbotRepository>(
    () => ChatbotRepository(
      apiService: sl(),
      healthProfileRepository: sl(),
    ),
  );
  sl.registerLazySingleton<LoginRepository>(() => LoginRepository(apiService: sl()));



  sl.registerSingleton<ChatbotCubit>(ChatbotCubit(sl()));
  sl.registerSingleton<HealthProfileCubit>(HealthProfileCubit(sl()));
  sl.registerSingleton<LoginCubit>(LoginCubit(sl()));

}
