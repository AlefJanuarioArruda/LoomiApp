import 'package:flutter/material.dart';
import 'package:projectloomi/view/Login_screen.dart';
import '../models/profile_model.dart';


class ProfileController {
  final ProfileModel _profileModel = ProfileModel();

  Future<Map<String, String?>> loadUserData() async {
    return await _profileModel.loadUserData();
  }

  Future<void> deleteAccount(BuildContext context) async {
    try {
      await _profileModel.deleteAccount();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir conta: $e')),
      );
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await _profileModel.logout();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer logout: $e')),
      );
    }
  }
}