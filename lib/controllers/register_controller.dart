import 'package:flutter/material.dart';

import '../models/register_model.dart';
import '../view/profile_setup_screen.dart';


class RegisterController {
  final RegisterModel _registerModel = RegisterModel();

  Future<void> navigateToProfileSetup(
      String email,
      String password,
      String confirmPassword,
      BuildContext context,
      ) async {
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileSetupScreen(
          email: email,
          password: password,
        ),
      ),
    );
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final user = await _registerModel.signInWithGoogle();
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer login com Google: $e')),
      );
    }
  }

  Future<void> signInWithApple(BuildContext context) async {
    try {
      final user = await _registerModel.signInWithApple();
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer login com Apple: $e')),
      );
    }
  }
}