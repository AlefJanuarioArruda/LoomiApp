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

import 'Login_screen.dart';
import 'ProfileScreen.dart'; // Para manipular arquivos de imagem

class ProfileScreenn extends StatefulWidget {
  const ProfileScreenn({super.key});

  @override
  _ProfileScreennState createState() => _ProfileScreennState();
}

class _ProfileScreennState extends State<ProfileScreenn> {
  final TextEditingController _nameController = TextEditingController();
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
      userName = prefs.getString('userName');
      userImage = prefs.getString('userImage');
    });
  }

  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userImage', _image!.path);
    }
  }

  Future<void> _updateName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', _nameController.text);
    setState(() {
      userName = _nameController.text;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nome atualizado com sucesso!')),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const ProfileScreen()),
    );
  }



  @override
  Widget build(BuildContext context) {
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
              Row(
                children: [
                  InkWell(
                    onTap:  _pickImage,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.height / 6,
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.4),
                        // Roxo escuro com transparência
                        borderRadius: BorderRadius.circular(30),
                        image:  userImage != null
                            ? DecorationImage(
                          image: FileImage(File(userImage!)), // Imagem de fundo
                          fit: BoxFit.cover, // Ajusta a imagem ao tamanho do container
                        )
                            : null,
                      ),
                      child: userImage == null
                          ? Image.asset(
                        'assets/img_4.png', // Imagem padrão
                        width: 40, // Largura da imagem
                        height: 40, // Altura da imagem
                      )
                          : null, // Ícone branco para contraste
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      Text(
                        'CHOOSE IMAGE',

                        style: TextStyle(fontSize: 15,
                            fontFamily: "Montserrat",
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        ' A square .jpg .gif \n or .png image \n 200x200 or larger',

                        style: TextStyle(fontSize: 15,
                            fontFamily: "Montserrat",
                            color: Colors.white24,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),


              const SizedBox(height: 16),
              Text(userName ?? 'User'),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Edit Name',
                  labelStyle: TextStyle(color: Colors.white30,fontFamily: "Montserrat"),
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              SizedBox(height: 50,),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all( color: Color(0xFF7A4AB0)!, width: 2),
                    // Borda em roxo claro
                    color: Colors.purple.withOpacity(0.3),

                  ),
                  child: ElevatedButton(
                    onPressed: _updateName,
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
                      'Save Name',
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
