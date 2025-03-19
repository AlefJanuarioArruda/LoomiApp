import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:projectloomi/firebase_options.dart';
import 'package:projectloomi/views/ImagePickerScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart'; // Para selecionar/tirar fotos
import 'dart:io';

import 'HomeScreen.dart'; // Para manipular arquivos de imagem

class ProfileSetupScreen extends StatefulWidget {
  final String email;
  final String password;

  const ProfileSetupScreen(
      {super.key, required this.email, required this.password});

  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  File? _image;

  Future<void> _navigateToImagePicker() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ImagePickerScreen()),
    );
    if (result != null) {
      setState(() {
        _image = result;
      });
    }
  }

  Future<void> _registerWithEmail() async {
    try {
      // Registrar o usuário no Firebase
      final userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.email,
        password: widget.password,
      );

      // Salvar o nome e a imagem no SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', _nameController.text);
      if (_image != null) {
        await prefs.setString('userImage', _image!.path);
      }

      // Navegar para a tela inicial
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      print('Erro ao registrar: $e');
    }
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
              SizedBox(height: MediaQuery.of(context).size.height / 20,),
              Image.asset(
                'assets/img.png', // Caminho da imagem
                width: 30, // Largura da imagem
                height: 30, // Altura da imagem
                //fit: BoxFit.cover, // Ajuste da imagem
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 20,),
              Text(
                "Tell us more!",
                style: TextStyle(
                  fontFamily: "Montserrat",
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 99,),
              Text(
                "look who is here!",
                style: TextStyle(
                    fontSize: 15,
                    fontFamily: "Montserrat",
                    color: Colors.white24,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // Centraliza horizontalmente
                crossAxisAlignment: CrossAxisAlignment.center,
                // Centraliza verticalmente
                children: [
                  InkWell(
                    onTap: _navigateToImagePicker,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.height / 6,
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.4),
                        // Roxo escuro com transparência
                        borderRadius: BorderRadius.circular(30),
                        image: _image != null
                            ? DecorationImage(
                          image: FileImage(_image!),
                          fit: BoxFit.cover, // Ajusta a imagem ao tamanho do container
                        )
                            : null,
                      ),
                      child:

                      _image == null
                          ?  Image.asset(
                        'assets/img_4.png', // Caminho da imagem
                        width: 5, // Largura da imagem
                        height: 5, // Altura da imagem
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
              SizedBox(height: MediaQuery.of(context).size.height / 10,),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Your name',
                  labelStyle: TextStyle(color: Colors.white30,fontFamily: "Montserrat"),
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                obscureText: false,
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 20,),

              SizedBox(height: MediaQuery.of(context).size.height / 20,),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all( color: Colors.purple.withOpacity(0.4)!, width: 2),
                    // Borda em roxo claro
                    color: Colors.purple.withOpacity(0.3),

                  ),
                  child: ElevatedButton(
                    onPressed: _registerWithEmail,
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
                        fontFamily: "Montserrat",
                        color: Colors.grey, // Cor do texto cinza
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              TextButton(onPressed: (){
                Navigator.pop(context);

              }, child: Text('Back',style: TextStyle(fontSize: 15,
                  fontFamily: "Montserrat",
                  color: Colors.purple.withOpacity(0.4),
                  fontWeight: FontWeight.bold),))


            ],
          ),
        ),
      ),
    );
  }
}