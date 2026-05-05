import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healginx/core/navigation_service.dart';
import 'package:healginx/features/chatBot_Screen/bloc/chatbot_cubit.dart';
import 'package:healginx/features/login/bloc/login_cubit.dart';
import 'package:healginx/features/splash/splash_screen.dart';
import 'package:healginx/injection_container.dart';
import 'package:healginx/styles/app_theme.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider<ChatbotCubit>(create: (_) => sl()),
        BlocProvider<LoginCubit>(create: (_) => sl()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: AppTheme.theme,
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        navigatorKey: sl<NavigationService>().navigatorKey,
      ),
    );
  }
}
