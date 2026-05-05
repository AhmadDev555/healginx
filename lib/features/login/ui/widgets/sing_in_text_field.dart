import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healginx/styles/app_colors.dart';



typedef OnValidation = String? Function(String?)? ;

mixin SignInTextField {

  Widget AuthTextField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    bool? readOnly,
    bool? isObscure,
    List<TextInputFormatter>? textInputFormatters,
    TextInputType? inputType,

    Widget? suffixIcon,
    OnValidation validation
  }) {
    return _AuthTextField(
        controller: controller,
        hint: hint,
        prefixIcon: prefixIcon,
      readOnly:readOnly,
        isObscure: isObscure,
      inputType:inputType,
      textInputFormatters:textInputFormatters,
        suffixIcon: suffixIcon,
        validation: validation,
    ) ;
  }

}


class _AuthTextField extends StatelessWidget {
  final TextEditingController controller ;
  final String hint ;
  final IconData prefixIcon ;
  final bool? isObscure ;
  final bool? readOnly ;
  final Widget? suffixIcon ;
  final TextInputType? inputType;
  final List<TextInputFormatter>? textInputFormatters;
  final OnValidation validation ;
  const _AuthTextField({required this.controller, required this.hint, required this.prefixIcon, this.suffixIcon, this.validation, this.isObscure,this.readOnly,this.inputType,this.textInputFormatters});

  @override
  Widget build(BuildContext context) {
    final theme=Theme.of(context);
    // final isDarkTheme=context.watch<ThemeCubit>().state == ThemeMode.dark;
    return Card(
      elevation: 0,
      child: TextFormField(
          // style:Theme.of(context).textTheme.labelLarge!.copyWith(
          //     color: isDarkTheme? Colors.white70: AppColors.lightBlack
          // ),
          controller: controller,
          obscureText: isObscure == true,
          readOnly: readOnly??false,
          keyboardType: inputType,
            inputFormatters:textInputFormatters,
      
      
          decoration: InputDecoration(
            filled: true,
            hintStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
                color:  AppColors.whiteGrey.withValues(alpha:0.4)
            ),



            fillColor: const Color(0xFFF4F6FA),
            hintText: hint,
            prefixIcon: Icon(
              prefixIcon,
              color:  const Color(0xFF707070),
            ),
      
            suffixIcon: suffixIcon,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color: AppColors.errorToastColor.withValues(alpha:0.2)
                )
            ),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color: AppColors.errorToastColor.withValues(alpha:0.2)
                )
            ),
          ),
          validator: validation
      ),
    ) ;
  }
}
