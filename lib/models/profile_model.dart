import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, String?>> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'userName': prefs.getString('userName') ?? 'Usuário',
      'userImage': prefs.getString('userImage'),
    };
  }

  Future<void> deleteAccount() async {
    await _auth.currentUser?.delete();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> logout() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}