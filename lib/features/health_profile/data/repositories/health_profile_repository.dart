import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healginx/features/health_profile/data/models/user_profile_data.dart';

class HealthProfileRepository {
  HealthProfileRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  Future<UserProfileData?> loadProfile() async {
    final userId = _currentUserId();
    final document =
        await _firestore.collection('health_profiles').doc(userId).get();

    final data = document.data();
    if (!document.exists || data == null) {
      return null;
    }

    return UserProfileData.fromMap(data);
  }

  Future<void> saveProfile(UserProfileData profile) async {
    final userId = _currentUserId();
    await _firestore.collection('health_profiles').doc(userId).set(
      {
        ...profile.toMap(),
        'userId': userId,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  String _currentUserId() {
    final userId = _auth.currentUser?.uid;
    if (userId == null || userId.isEmpty) {
      throw Exception('No logged-in user found');
    }
    return userId;
  }
}
