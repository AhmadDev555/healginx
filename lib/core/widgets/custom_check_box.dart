import 'package:flutter/material.dart';
import 'package:healginx/constants/app_images.dart';
import 'package:healginx/styles/app_colors.dart';
import 'package:healginx/styles/font_style.dart';
import 'package:healginx/styles/sizes.dart';
import 'package:vibration/vibration.dart';

class CustomCheckBox extends StatelessWidget {
  final bool value ;
  final Function(bool) onChange ;

  const CustomCheckBox({super.key, required this.value, required this.onChange});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: 40,
      child: Center(
        child: GestureDetector(
          onTap: (){
            if(!value) {
              Vibration.vibrate(duration: 80) ;
            }
            onChange(!value) ;
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: value ? Curves.easeInSine : Curves.easeOutSine,
            margin: !value? EdgeInsets.only(
                top: 8
            ) : null ,
            width: value ? 35 : 20,
            height: value ? 35 : 20,
            decoration: BoxDecoration(
              color: value ? null : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: value ? null : Border.all(
                  color: AppColors.grey.withOpacity(0.3)
              ),
            ),
            child: value ? Image(
              image: AssetImage(AppImages.check),
              fit: BoxFit.fill,
            ) : null,
          ),
        ),
      ),
    ) ;

  }
}