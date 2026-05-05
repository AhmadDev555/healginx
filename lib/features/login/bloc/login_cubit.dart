import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healginx/features/login/bloc/login_states.dart';
import 'package:healginx/features/login/data/repositories/login_repository.dart';

class LoginCubit extends Cubit<LoginStates> {

  LoginCubit(this._loginRepository) : super(LoginInitial());


  final LoginRepository _loginRepository;

  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    emit(LoginWithEmailLoading());

    final response = await _loginRepository.loginWithEmail(email: email, password: password);
    if(response != null) {
      emit(LoginWithEmailSuccess(loginModel: response));
    }
    else {
      emit(LoginWithEmailFailure(error: response.toString()));
    }
  }

  Future<void> loginWithGoogle() async {
    emit(LoginWithGoogleLoading());

    try {
      final response = await _loginRepository.loginWithGoogle();

      if (response != null) {
        emit(LoginWithGoogleSuccess(loginModel: response));
      } else {
        emit(LoginWithGoogleFailure(error: "Google sign-in cancelled"));
      }
    } catch (e) {
      emit(LoginWithGoogleFailure(error: e.toString()));
    }
  }




}