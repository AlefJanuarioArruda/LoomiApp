import 'package:flutter/material.dart';

import '../models/auth_model.dart';


class ChangePasswordController {
  final AuthModel _authModel = AuthModel();

  Future<void> changePassword(
      String oldPassword,
      String newPassword,
      BuildContext context,
      ) async {
    try {
      await _authModel.changePassword(oldPassword, newPassword);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Senha atualizada com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar senha: $e')),
      );
    }
  }
}