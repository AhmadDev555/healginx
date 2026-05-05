import 'package:flutter/material.dart';
import 'package:healginx/styles/app_colors.dart';

import 'animated_text_widget.dart';

class RefreshScreenWidget extends StatelessWidget {

   String? text;
  final VoidCallback onTap;
   RefreshScreenWidget({required this.onTap,this.text,super.key});

  // RefreshScreenWidget._() ;
  //
  //
  // static Widget show(BuildContext context, {String? text, required VoidCallback onTap}) {
  //
  //   return SizedBox(
  //     height: (MediaQuery.sizeOf(context).height) - kToolbarHeight,
  //     width: MediaQuery.sizeOf(context).width,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //
  //         AnimatedTextWidget(
  //             showText: text ?? "Refresh Again !"
  //         ),
  //
  //         const SizedBox(height: 30,),
  //
  //         GestureDetector(
  //           onTap: onTap,
  //           child: const Icon(
  //             Icons.refresh,
  //             color: AppColors.primary,
  //             size: 40,
  //           ),
  //         ),
  //
  //       ],
  //     ),
  //   ) ;
  //
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      height: (MediaQuery.sizeOf(context).height) - kToolbarHeight,
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          AnimatedTextWidget(
              showText: text ?? "Refresh Again !"
          ),

          const SizedBox(height: 30,),

          GestureDetector(
            onTap: onTap,
            child: const Icon(
              Icons.refresh,
              color: AppColors.primary,
              size: 40,
            ),
          ),

        ],
      ),
    );
  }

}