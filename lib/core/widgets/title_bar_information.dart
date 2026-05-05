import 'package:flutter/material.dart';
import 'package:healginx/styles/app_colors.dart';
import 'package:healginx/styles/sizes.dart';



class TitleBarInformation extends StatelessWidget {

  final String title;
  final IconData iconData;
  final Widget? suffixIcon;

  const TitleBarInformation({
    super.key,
    required this.title,
    required this.iconData, this.suffixIcon,
  });


  @override
  Widget build(BuildContext context) {

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(left: 3, right: 3, top: 3),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.blue,
        ),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(
                  iconData,
                  color: AppColors.white,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall!
                      .copyWith(
                    color: AppColors.white,
                    fontSize: Sizes.font16,
                  ),
                ),
              ],
            ),

            Container(
              child: suffixIcon,
            ),
          ],
        ),
      ),
    );
  }
}