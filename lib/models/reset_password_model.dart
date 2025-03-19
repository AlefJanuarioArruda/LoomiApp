import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendPasswordResetEmail(String email) async {
    if (email.isEmpty) {
      throw 'Por favor, insira seu e-mail.';
    }

    await _auth.sendPasswordResetEmail(email: email);
  }
}