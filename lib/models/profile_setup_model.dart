import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class ProfileSetupModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> registerWithEmail(String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  Future<void> saveUserData(String name, File? image) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    if (image != null) {
      await prefs.setString('userImage', image.path);
    }
  }
}