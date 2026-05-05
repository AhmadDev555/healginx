import 'package:flutter/material.dart';
import 'package:healginx/styles/app_colors.dart';
import 'package:healginx/styles/font_style.dart';
import 'package:healginx/styles/sizes.dart';

class InformationText extends StatelessWidget {
  final String leftText;
  final String rightRight;
  final Widget? showStatOrder ;

  const InformationText({
    super.key,
    required this.leftText,
    required this.rightRight, this.showStatOrder,
  });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: width * 0.25,
            child: Text(
              leftText,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: Sizes.font16,
                  fontWeight: FontStyles.fontWeightMedium),
            ),
          ),
          const Text(' :  '),
          showStatOrder != null ? Container(child: showStatOrder,) : Expanded(
            child: Text(
              rightRight,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontSize: Sizes.font16, color: AppColors.whiteGrey),
            ),
          ),
        ],
      ),
    );
  }
}