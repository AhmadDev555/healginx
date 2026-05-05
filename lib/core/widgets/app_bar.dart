import 'package:flutter/material.dart';
import 'package:healginx/styles/app_colors.dart';

class CustomTitleBar extends StatelessWidget implements PreferredSizeWidget {
  final String title ;
  final Color textColor;
  final Color iconColor;
  final VoidCallback? backOnTap ;
  final IconData? icon ;
  final double? titleSize ;
  final Animation<double>? fadeAnimation;
  /// if it is null then the back button did not show

   CustomTitleBar({super.key, required this.title, this.backOnTap, this.fadeAnimation, this.icon, this.textColor = AppColors.primary, this.iconColor = AppColors.primary, this.titleSize});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          Visibility(
            visible: backOnTap != null,
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: InkWell(
                onTap: backOnTap,
                child: Icon(
                  icon ?? Icons.arrow_back_ios_rounded,
                  color: iconColor,
                  size: 25,
                ),
              ),
            ),
          ),

          Builder(
              builder: (context) {
                if(fadeAnimation != null) {
                  return FadeTransition(
                    opacity: fadeAnimation!,
                    child: _title(context),
                  ) ;
                }
                else {
                  return _title(context) ;
                }
              }
          )

        ],
      ),
    ) ;
  }

  Widget _title(BuildContext context) {
    return Text(
      title,
      textScaler: const TextScaler.linear(0.7),
      style: Theme.of(context).textTheme.displaySmall!.copyWith(
          color:iconColor,
          fontWeight: FontWeight.w700,
          fontSize: titleSize
      ),
    ) ;
  }


  @override
  Size get preferredSize => const Size.fromHeight(100);

}