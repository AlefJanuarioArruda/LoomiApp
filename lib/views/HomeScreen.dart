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

import 'ProfileScreen.dart'; // Para manipular arquivos de imagem

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userImage;
  List<dynamic> movies = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchMovies();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userImage = prefs.getString('userImage');
    });
  }

  Future<void> _fetchMovies() async {
    try {
      final dio = Dio();
      final response = await dio.get(
          'https://untold-strapi.api.prod.loomi.com.br/api/movies?populate=poster');
      setState(() {
        movies = response.data['data'];
      });
    } catch (e) {
      debugPrint('Erro ao buscar filmes: $e');
    }
  }

  Future<void> _likeMovie(int movieId, int userId) async {
    final dio = Dio();
    try {
      await dio.post('https://untold-strapi.api.prod.loomi.com.br/api/likes',
          data: {
            "data": {"movie_id": movieId, "user_id": userId}
          });
      debugPrint("Like enviado com sucesso!");
    } catch (e) {
      debugPrint("Erro ao enviar like: $e");
    }
  }

  Future<void> _dislikeMovie(int likeId) async {
    final dio = Dio();
    try {
      await dio.delete(
          'https://untold-strapi.api.prod.loomi.com.br/api/likes/$likeId');
      debugPrint("Deslike removido com sucesso!");
    } catch (e) {
      debugPrint("Erro ao remover deslike: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        automaticallyImplyLeading: false,// Garante que o título (imagem) fique centralizado
        title: Image.asset(
          'assets/img.png', // Caminho da imagem
          height: 40, // Ajuste o tamanho conforme necessário
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: userImage != null
                    ? FileImage(File(userImage!))
                    : null,
                child: userImage == null ? const Icon(Icons.person) : null,
              ),
            ),
          ),
        ],
      ),
      body: movies.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.pink],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 40,),
            Align(
              alignment: Alignment.centerLeft, // Alinha o texto à esquerda
              child: Padding(
                padding: const EdgeInsets.only(left: 20), // Adiciona padding à esquerda
                child: Text(
                  "Now Showing",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 50,),
            SizedBox(
              height: 600,
              child: PageView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                        image: NetworkImage(movie['attributes']['poster']['data']['attributes']['url']),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: IconButton(
                            icon: const Icon(Icons.play_circle_fill, size: 80, color: Colors.white),
                            onPressed: () {
                              // Navegar para assistir o filme
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: Text(
                            movie['attributes']['title'] ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: Row(

                            children: [
                              InkWell(
                                 onTap:() => _likeMovie(movie['id'], 19),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/img_8.png', // Caminho da imagem
                                      height: 30, // Ajuste o tamanho conforme necessário
                                    ),
                                       ],
                                ),
                              ),
                              SizedBox(width: 30,),
                              InkWell(
                                onTap:() => _dislikeMovie(movie['id']),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/img_9.png', // Caminho da imagem
                                      height: 30, // Ajuste o tamanho conforme necessário
                                    ),
                                           ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}