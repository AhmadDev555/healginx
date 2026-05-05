import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';






class Loading {
  Loading._();

  static void show(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha:0.8),
      pageBuilder: (_, __, ___) {
        return const LoadingScreen();
      },
    );
  }

  static void dismiss(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}

class LoadingScreen extends StatelessWidget {
  final String loadingMessage;
  const LoadingScreen({Key? key, this.loadingMessage = 'Please Wait'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                "assets/gifs/loading.json",
                height: size.height * 0.2,
                onLoaded: (composition) {},
              ),
              Text(
                '$loadingMessage ',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class LoaderScreen extends StatelessWidget {
//   const LoaderScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async => false,
//       child: Dialog(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         shape:ContinuousRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(24)),
//         ),
//         // shape: RoundedRectangleBorder(
//         //   borderRadius: BorderRadius.all(Radius.circular(16)),
//         // ),
//         insetPadding: EdgeInsets.symmetric(horizontal: 40),
//         child: Padding(
//           padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
//           child: Center(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withValues(alpha:0.1),
//                     blurRadius: 6,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   SizedBox(
//                     width: 24,
//                     height: 24,
//                     child: SpinKitFadingCircle(
//                       color: AppColors.primary,
//                       size: 24,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                    Text(
//                     'Loading, please wait.',
//                     style:Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black)
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//
//
//       ),
//     );
//   }
// }





