import 'package:flutter/material.dart';
import 'package:healginx/styles/app_colors.dart';

class CommonButton extends StatelessWidget {
  final VoidCallback? onTap ;
  final String? title ;
  final Color? backgroundColor ;
  final num? height ;
  final num? width ;
  final num? titleSize ;
  final Color? titleColor ;
  final num? borderRadius ;
  final EdgeInsets? margin ;
  final Widget? titleWidget ;
  final bool? disable ;

  const CommonButton({super.key, required this.onTap, this.title, this.backgroundColor, this.height, this.width, this.titleSize, this.titleColor, this.borderRadius, this.margin, this.titleWidget, this.disable});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: height != null ? height!.toDouble() : 45,

      child: MaterialButton(
        onPressed: myTap,
        minWidth: width != null ? width!.toDouble() : MediaQuery.sizeOf(context).width,
        color: bgColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        child: Center(
          child: titleWidget ?? Text(
            title ?? "",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: titleColor ?? AppColors.white,
                fontSize: titleSize?.toDouble()
            ),
          ),
        ),
      ),
    ) ;
  }

  Color get bgColor {

    if(disable == true) {
      return Colors.grey  ;
    }
    else if(backgroundColor != null) {
      return backgroundColor! ;
    }
    return AppColors.primary ;

  }

  VoidCallback? get myTap {

    if(disable == true) {
      return (){} ;
    }
    else if(onTap != null) {
      return onTap ;
    }
    return (){} ;

  }

}