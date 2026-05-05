import 'package:flutter/material.dart';
import 'package:healginx/constants/app_images.dart';
import 'package:healginx/core/local_cache/shared_preferences.dart';
import 'package:healginx/injection_container.dart';
import 'package:healginx/styles/app_colors.dart';
import 'package:healginx/styles/font_style.dart';
import 'package:healginx/styles/sizes.dart';


class LogoutDialog {
  LogoutDialog._() ;


  static void show(BuildContext context) {

    showDialog(
        context: context,
        builder: (context) {

          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18)
            ),
            insetAnimationDuration: const Duration(milliseconds: 200),
            insetAnimationCurve: Curves.easeInSine,
            backgroundColor: AppColors.white,
            surfaceTintColor: AppColors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                alignment: Alignment.topRight,
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      const Center(
                        child: Image(
                            height: 130,
                            width: 130,
                            fit: BoxFit.fill,
                            image: AssetImage(
                                Gifs.logout
                            )
                        ),
                      ),

                      const SizedBox(height: 20),

                      Center(
                        child: Text(
                          "Do you want to logout?",
                          textScaler: const TextScaler.linear(0.9),
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: AppColors.black,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                      ),


                      Padding(
                        padding: const EdgeInsets.only(
                            top: 30,
                            bottom: 10
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            _button(
                                context,
                                onTap: ()=> Navigator.pop(context),
                                title: "Cancel",
                                isFilled: false
                            ),

                            const SizedBox(width: 10),

                            _button(
                                context,
                                onTap: () async {
                                 // await SharedPreferencesClient.instance.clearSession();
                                 // sl<NavigationService>().pushAndClearStack(LoginScreen());
                                },
                                title: "Logout",
                                isFilled: true
                            ),

                          ],
                        ),
                      ),


                    ],
                  ),

                  GestureDetector(
                    onTap: ()=> Navigator.pop(context),
                    child: Icon(
                      Icons.cancel_outlined,
                      color: AppColors.black,
                      size: 25,
                    ),
                  ),


                ],
              ),
            ),
          ) ;

        }
    ) ;

  }


  static Widget _button(BuildContext context, {required VoidCallback onTap, required String title, required bool isFilled}) {
    return Expanded(
      child: OutlinedButton(
          onPressed: onTap,
          style: ButtonStyle(
              backgroundColor: isFilled ? MaterialStateProperty.resolveWith((_) => AppColors.primary) : null,
              side: isFilled ? MaterialStateProperty.resolveWith((_) => BorderSide.none) : null
          ),
          child: Text(
            title,
            textScaler: const TextScaler.linear(0.9),
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: isFilled ? AppColors.white : AppColors.primary,
                fontWeight: FontWeight.w600
            ),
          )
      ),
    ) ;
  }

}