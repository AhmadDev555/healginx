import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healginx/features/health_profile/bloc/health_profile_states.dart';
import 'package:healginx/features/health_profile/data/models/user_profile_data.dart';
import 'package:healginx/features/health_profile/data/repositories/health_profile_repository.dart';

class HealthProfileCubit extends Cubit<HealthProfileStates> {
  HealthProfileCubit(this._healthProfileRepository)
      : super(HealthProfileInitial());

  final HealthProfileRepository _healthProfileRepository;

  Future<void> loadProfile() async {
    try {
      emit(HealthProfileLoading());
      final profile = await _healthProfileRepository.loadProfile();
      emit(HealthProfileLoadSuccess(profile: profile));
    } catch (e) {
      emit(HealthProfileFailure(error: e.toString()));
    }
  }

  Future<void> saveProfile(UserProfileData profile) async {
    try {
      emit(HealthProfileSaveLoading());
      await _healthProfileRepository.saveProfile(profile);
      emit(HealthProfileSaveSuccess(profile: profile));
    } catch (e) {
      emit(HealthProfileFailure(error: e.toString()));
    }
  }
}
