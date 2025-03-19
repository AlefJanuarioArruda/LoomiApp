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
import 'dart:io';

import 'HomeScreen.dart';
import 'ProfileSetupScreen.dart'; // Para manipular arquivos de imagem


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  void _navigateToProfileSetup() {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileSetupScreen(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      ),
    );
  }

  Future<void> _saveUserData(User user, String name, String? imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    await prefs.setString('userEmail', user.email ?? '');
    await prefs.setString('userUID', user.uid);
    if (imagePath != null) {
      await prefs.setString('userImage', imagePath);
    }
  }

  Future<User?> _signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential =
    await FirebaseAuth.instance.signInWithCredential(credential);
    await _saveUserData(userCredential.user!,
        googleUser.displayName ?? 'Usuário', googleUser.photoUrl);
    return userCredential.user;
  }

  Future<User?> _signInWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName
      ],
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              SizedBox(height: MediaQuery.of(context).size.height / 99,),
              Image.asset(
                'assets/img_1.png', // Caminho da imagem
                width: 130, // Largura da imagem
                height: 130, // Altura da imagem
                //fit: BoxFit.cover, // Ajuste da imagem
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an accont?",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Montserrat",
                        color: Colors.white30,
                        fontWeight: FontWeight.bold),
                  ),TextButton(onPressed: (){
                    Navigator.pop(context);

                  },
                    child: Text(
                      "Sign in!",
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Montserrat",
                          color: Color(0xFF7A4AB0),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 60,),
              Text(
                "Create an account",
                style: TextStyle(
                    fontSize: 35,
                    fontFamily: "Montserrat",
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10,),
              Text(
                "To get started, please complete your \n                   accont registration",
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.white30,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold),
              ),

              SizedBox(
                height: 30,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botão Google
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                      Colors.purple.withOpacity(0.3), // Roxo transparente
                    ),
                    padding: const EdgeInsets.all(16),
                    child: InkWell(
                      onTap: () async {
                        final user = await _signInWithGoogle();
                        if (user != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                          );
                        }
                      },
                      child:Image.asset(
                        'assets/img_2.png', // Caminho da imagem
                        width: 40, // Largura da imagem
                        height: 40, // Altura da imagem
                      ),
                    ),
                  ),
                  SizedBox(width: 20), // Espaçamento entre os ícones

                  // Botão Apple
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                      Colors.white.withOpacity(0.3), // Branco transparente
                    ),
                    padding: const EdgeInsets.all(16),
                    child: InkWell(
                      onTap: () async {
                        final user = await _signInWithApple();
                        if (user != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                          );
                        }
                      },
                      child: Image.asset(
                        'assets/img_3.png', // Caminho da imagem
                        width: 40, // Largura da imagem
                        height: 40, // Altura da imagem
                      ),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height / 20,),
                ],
              ), Row(
                children: const [
                  Expanded(
                    child: Divider(
                      color: Colors.grey, // Cor da linha
                      thickness: 1,
                      endIndent: 10, // Espaçamento antes do texto
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    ' Or Sign in Wih ',
                    style: TextStyle(color: Colors.white24,fontFamily: "Montserrat",),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey, // Cor da linha
                      thickness: 1,
                      indent: 10, // Espaçamento depois do texto
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                obscureText: true,
              ),

              SizedBox(
                height: 30,
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                obscureText: true,
              ),

              SizedBox(
                height: 30,
              ),
              TextField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                obscureText: true,
              ),

              const SizedBox(height: 30),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all( color: Colors.purple.withOpacity(0.4)!, width: 2),
                    // Borda em roxo claro
                    color: Colors.purple.withOpacity(0.3),

                  ),
                  child: ElevatedButton(
                    onPressed: _navigateToProfileSetup,
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
                      'Continue',
                      style: TextStyle(
                        color: Colors.grey, // Cor do texto cinza
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