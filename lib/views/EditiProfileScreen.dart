import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:projectloomi/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart'; // Para selecionar/tirar fotos
import 'dart:io'; // Para manipular arquivos de imagem


class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();

    Future<void> _changePassword() async {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final cred = EmailAuthProvider.credential(
              email: user.email!, password: oldPasswordController.text);
          await user.reauthenticateWithCredential(cred);
          await user.updatePassword(newPasswordController.text);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Senha atualizada com sucesso!')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar senha: $e')),
        );
      }
    }
    bool _obscureText = true;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.purple),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Edit\nProfile",
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              TextField(
                controller: oldPasswordController,
                style: const TextStyle(color: Colors.white),
                decoration:  InputDecoration(
                  labelStyle: TextStyle(color: Colors.white30,fontFamily: "Montserrat"),
                  hintStyle: TextStyle(color: Colors.white),
                  labelText: 'Current password',

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white10,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText; // Alterna o estado
                    });
                  },
                ),
                ),obscureText: _obscureText,
              ),
              const SizedBox(height: 70),
              TextField(
                controller: newPasswordController,
                style: const TextStyle(color: Colors.white),
                decoration:  InputDecoration(
                  labelStyle: TextStyle(color: Colors.white30,fontFamily: "Montserrat"),
                  hintStyle: TextStyle(color: Colors.white),
                  labelText: 'New Password',

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white10,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText; // Alterna o estado
                    });
                  },
                ),
                ),obscureText: _obscureText,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: newPasswordController,
                style: const TextStyle(color: Colors.white),
                decoration:  InputDecoration(
                  labelStyle: TextStyle(color: Colors.white30,fontFamily: "Montserrat"),
                  hintStyle: TextStyle(color: Colors.white),
                  labelText: 'Confirm New Password',

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white10,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText; // Alterna o estado
                    });
                  },
                ),
                ),obscureText: _obscureText,
              ),



              const SizedBox(height: 70),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all( color: Color(0xFF7A4AB0)!, width: 2),
                    // Borda em roxo claro
                    color: Colors.purple.withOpacity(0.3),

                  ),
                  child: ElevatedButton(
                    onPressed: _changePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      // Torna o fundo transparente
                      shadowColor: Colors.transparent,
                      // Remove a sombra
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 100, vertical: 10),
                    ),
                    child: const Text(
                      'Update Password',
                      style: TextStyle(
                        color: Color(0xFF7A4AB0), // Cor do texto cinza
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
