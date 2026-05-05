import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginStates {}

class LoginInitial extends LoginStates {}

class LoginWithEmailLoading extends LoginStates{}

class LoginWithEmailSuccess extends LoginStates {
  final User loginModel;

  LoginWithEmailSuccess({required this.loginModel});
}

class LoginWithEmailFailure extends LoginStates {
  final String? error;
  LoginWithEmailFailure({required this.error});
}



class LoginWithGoogleLoading extends LoginStates {}

class LoginWithGoogleSuccess extends LoginStates {
  final User loginModel;

  LoginWithGoogleSuccess({required this.loginModel});
}

class LoginWithGoogleFailure extends LoginStates {
  final String? error;

  LoginWithGoogleFailure({this.error});
}