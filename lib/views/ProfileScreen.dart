import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:projectloomi/firebase_options.dart';
import 'package:projectloomi/views/EditiProfileScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart'; // Para selecionar/tirar fotos
import 'dart:io';

import 'Login_screen.dart';
import 'Edit_profile.dart'; // Para manipular arquivos de imagem

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  String? userImage;
  String? userName;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'Usuário';
      userImage = prefs.getString('userImage');
    });
  }


  Future<void> _deleteAccount() async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir conta: $e')),
      );
    }
  }

  void _navigateToChangePassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
    );
  }
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreenn()),
              );
            },
                child: const Text(
                    'Edit Profile', style: TextStyle(fontSize: 20,color: Colors.purple,fontFamily: "Montserrat",))),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.purple),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 70,

                  backgroundImage: userImage != null ? FileImage(
                      File(userImage!)) : null,
                  child: userImage == null
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),
                const SizedBox(width: 20),
                Text("Hello.\n${userName ?? 'Usuário' }",
                    style: const TextStyle(color: Colors.white, fontSize: 25,fontFamily: "Montserrat",)),
              ],
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: _navigateToChangePassword,
              child: Container(
                height: 80,
                padding: const EdgeInsets.symmetric(
                    vertical: 16, horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/img_6.png', // Caminho da imagem
                      height: 40, // Ajuste o tamanho conforme necessário
                    ),
                    Text('Change Password', style: const TextStyle(
                        fontFamily: "Montserrat",
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800)),
                    const Icon(Icons.arrow_forward_ios, color: Colors.white),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
                onTap: _deleteAccount,
                child: Container(
                  height: 80,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/img_7.png', // Caminho da imagem
                        height: 40, // Ajuste o tamanho conforme necessário
                      ),
                      Text('Delete My Account', style: const TextStyle(
                          fontFamily: "Montserrat",
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800)),
                      const Icon(Icons.arrow_forward_ios, color: Colors.white),
                    ],
                  ),
                )
            ), const SizedBox(height: 20),
            GestureDetector(
                onTap: _logout,
                child: Container(
                  height: 80,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/img.png', // Caminho da imagem
                        height: 40, // Ajuste o tamanho conforme necessário
                      ),
                      Text('Log out', style: const TextStyle(
                          fontFamily: "Montserrat",
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800)),
                      const Icon(Icons.arrow_forward_ios, color: Colors.white),
                    ],
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
