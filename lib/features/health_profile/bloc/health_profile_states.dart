import 'package:healginx/features/health_profile/data/models/user_profile_data.dart';

abstract class HealthProfileStates {}

class HealthProfileInitial extends HealthProfileStates {}

class HealthProfileLoading extends HealthProfileStates {}

class HealthProfileLoadSuccess extends HealthProfileStates {
  final UserProfileData? profile;

  HealthProfileLoadSuccess({required this.profile});
}

class HealthProfileSaveLoading extends HealthProfileStates {}

class HealthProfileSaveSuccess extends HealthProfileStates {
  final UserProfileData profile;

  HealthProfileSaveSuccess({required this.profile});
}

class HealthProfileFailure extends HealthProfileStates {
  final String error;

  HealthProfileFailure({required this.error});
}
