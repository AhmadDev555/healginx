
import 'package:flutter/material.dart';
import 'package:healginx/core/local_cache/shared_preferences.dart';
import 'package:healginx/core/navigation_service.dart';
import 'package:healginx/features/home/ui/home.dart';
import 'package:healginx/features/login/ui/login.dart';
import 'package:healginx/injection_container.dart';
import 'package:healginx/styles/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{



  @override
  void initState() {
    super.initState();
    navigateToNext();
  }

  Future<void> navigateToNext() async {
    var isLoggedIn = await SharedPreferencesClient.instance.isLoggedIn();
    await Future.delayed(const Duration(seconds: 2));

    if (isLoggedIn) {
      sl<NavigationService>().pushAndClearStack(HomeScreen());
    } else {
      sl<NavigationService>().push(LoginScreen());
    }
  }






  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height ;
    var width = MediaQuery.sizeOf(context).width ;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primary,
                AppColors.primary,
                AppColors.primary,
                AppColors.primary.withOpacity(0.9),
                AppColors.primary.withOpacity(0.8),
                AppColors.primary.withOpacity(0.7),
                AppColors.primary.withOpacity(0.65),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/logo.png"),
              SizedBox(height: 20,),
              Text("TrueMedIt",style: TextStyle(color: AppColors.white,fontSize: 18),),

            ],
          ),
        ),
      ),
    ) ;

  }

}



