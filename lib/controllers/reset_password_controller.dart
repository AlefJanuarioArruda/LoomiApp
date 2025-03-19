import 'package:flutter/material.dart';

import '../models/reset_password_model.dart';


class ResetPasswordController {
  final ResetPasswordModel _resetPasswordModel = ResetPasswordModel();

  Future<void> sendPasswordResetEmail(String email, BuildContext context) async {
    try {
      await _resetPasswordModel.sendPasswordResetEmail(email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('E-mail de recuperação enviado! Verifique sua caixa de entrada.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar e-mail: $e')),
      );
    }
  }
}