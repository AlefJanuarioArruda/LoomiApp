import 'package:flutter/material.dart';

import '../models/auth_model.dart';

class LoginController {
  final AuthModel _authModel = AuthModel();

  Future<void> signInWithEmail(
      String email, String password, BuildContext context) async {
    try {
      await _authModel.signInWithEmail(email, password);
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer login: $e')),
      );
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final user = await _authModel.signInWithGoogle();
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
      final user = await _authModel.signInWithApple();
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer login com Apple: $e')),
      );
    }
  }

  Future<void> resetPassword(String email, BuildContext context) async {
    try {
      await _authModel.resetPassword(email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email de recuperação de senha enviado!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar email de recuperação: $e')),
      );
    }
  }
}