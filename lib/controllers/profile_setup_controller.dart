import 'package:flutter/material.dart';
import 'package:projectloomi/View/home_screen.dart';
import '../models/profile_setup_model.dart';
import 'dart:io';

class ProfileSetupController {
  final ProfileSetupModel _profileSetupModel = ProfileSetupModel();

  Future<void> registerWithEmail(
      String email,
      String password,
      String name,
      File? image,
      BuildContext context,
      ) async {
    try {
      // Registrar o usuário no Firebase
      await _profileSetupModel.registerWithEmail(email, password);

      // Salvar o nome e a imagem no SharedPreferences
      await _profileSetupModel.saveUserData(name, image);

      // Navegar para a tela inicial
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao registrar: $e')),
      );
    }
  }
}