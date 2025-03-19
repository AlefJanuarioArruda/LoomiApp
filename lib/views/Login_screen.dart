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
import 'RegisterScreen.dart';
import 'ResetPassworScreen.dart'; // Para manipular arquivos de imagem

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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

    final userCredential =
    await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    await _saveUserData(
        userCredential.user!, appleCredential.givenName ?? 'Usuário', null);
    return userCredential.user;
  }

  Future<void> _signInWithEmail() async {
    try {
      final userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      print('Erro ao fazer login: $e');
    }
  }

  Future<void> _resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email de recuperação de senha enviado!')),
      );
    } catch (e) {
      print('Erro ao enviar email de recuperação: $e');
    }
  }
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      //appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(height: MediaQuery.of(context).size.height / 20,),
              Image.asset(
                'assets/img.png', // Caminho da imagem
                width: 30, // Largura da imagem
                height: 30, // Altura da imagem
                //fit: BoxFit.cover, // Ajuste da imagem
              ),
              Text(
                "Welcome back",
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "look who is here!",
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 15,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 20,
              ),
              TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.white30,fontFamily: "Montserrat"),
                  hintStyle: TextStyle(color: Colors.white),
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                obscureText: false,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 20,
              ),
              TextField(
                controller: _passwordController,
                style: const TextStyle(color: Colors.white),
                decoration:  InputDecoration(
                  labelStyle: TextStyle(color: Colors.white30,fontFamily: "Montserrat"),
                  hintStyle: TextStyle(color: Colors.white),
                  labelText: 'Password',

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



              Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResetPasswordScreen()),
                      );
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(color: Color(0xFF7A4AB0)),
                    ),
                  )),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all( color: Color(0xFF7A4AB0)!, width: 2),
                    // Borda em roxo claro
                    color: Colors.purple.withOpacity(0.3),

                  ),
                  child: ElevatedButton(
                    onPressed: _signInWithEmail,
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
                      'Login',
                      style: TextStyle(
                        color: Color(0xFF7A4AB0), // Cor do texto cinza
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height / 20,), // Espaçamento

              // Linha com "Faça login também"
              Row(
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
              SizedBox(height: MediaQuery.of(context).size.height / 20,), // Espaçamento

              // Botões de Login com Google e Apple
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
              ),
              SizedBox(
                height:MediaQuery.of(context).size.height / 20,
              ),
              Padding(
                padding: EdgeInsets.only(left: 50, right: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Don`t have an account?",
                      style: TextStyle(fontSize: 15, color: Colors.white24,fontFamily: "Montserrat",),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: const Text('Register',style: TextStyle(color: Color(0xFF7A4AB0),fontFamily: "Montserrat",),),
                    ),
                  ],
                ),
              ),
            ])),
      ),
    );
  }
}
