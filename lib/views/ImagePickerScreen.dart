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
class ImagePickerScreen extends StatelessWidget {
  const ImagePickerScreen({super.key});

  Future<File?> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      print('Erro ao selecionar imagem: $e');
    }
    return null;
  }

  Future<void> _requestPermissions(
      ImageSource source, BuildContext context) async {
    if (source == ImageSource.camera) {
      final status = await Permission.camera.request();
      if (status.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permissão da câmera negada.')),
        );
      }
    } else {
      final status = await Permission.storage.request();
      if (status.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permissão da galeria negada.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.purple), // Seta roxa
          onPressed: () {
            Navigator.of(context).pop(); // Voltar para a tela anterior
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 60),
          child: const Text(
            'CHOOSE IMAGE',

            style: TextStyle(fontSize: 15,
                fontFamily: "Montserrat",
                color: Colors.white,
                fontWeight: FontWeight.bold), // Título
          ),
        ),
        backgroundColor: Colors.black, // Fundo branco
        elevation: 0, // Remove a sombra
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // Centraliza horizontalmente
              //crossAxisAlignment: CrossAxisAlignment.center,
              // Centraliza verticalmente
              children: [
                InkWell(
                  onTap: () async {
                    await _requestPermissions(ImageSource.camera, context);
                    if (await Permission.camera.isGranted) {
                      final image = await _pickImage(ImageSource.camera);
                      if (image != null) {
                        Navigator.pop(context, image);
                      }
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.height / 6,
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.4),
                      // Roxo escuro com transparência
                      borderRadius: BorderRadius.circular(30),



                    ),
                    child:
                     Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/img_4.png', // Caminho da imagem

                          ),
                          Text('\nTake a \n photo', style: TextStyle(fontSize: 15,
                              fontFamily: "Montserrat",
                              color: Colors.white24,
                              fontWeight: FontWeight.bold),)
                        ],

                    ), // Ícone branco para contraste
                  ),
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () async {
                    await _requestPermissions(ImageSource.gallery, context);
                    if (await Permission.storage.isGranted) {
                      final image = await _pickImage(ImageSource.gallery);
                      if (image != null) {
                        Navigator.pop(context, image);
                      }
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.height / 6,
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.4),
                      // Roxo escuro com transparência
                      borderRadius: BorderRadius.circular(30),



                    ),
                    child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/img_5.png', // Caminho da imagem

                        ),
                        Text('\nChoose from \n gallery', style: TextStyle(fontSize: 15,
                            fontFamily: "Montserrat",
                            color: Colors.white24,
                            fontWeight: FontWeight.bold),)
                      ],

                    ), // Ícone branco para contraste
                  ),),
              ],
            ),

          ],
        ),
      ),
    );
  }
}