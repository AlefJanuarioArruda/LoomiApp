import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class UserModel {
  String? userName;
  String? userImage;

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('userName');
    userImage = prefs.getString('userImage');
  }

  Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
  }

  Future<void> saveUserImage(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userImage', imagePath);
  }
}