import 'dart:io';

import 'package:flutter/material.dart';
import 'package:projectloomi/view/profile_screen_view.dart';

import '../controllers/home_controller.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController _controller = HomeController();

  @override
  void initState() {
    super.initState();
    _controller.loadUserData().then((_) {
      setState(() {});
    });
    _controller.fetchMovies().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Image.asset(
          'assets/img.png',
          height: 40,
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
                backgroundImage: _controller.userImage != null
                    ? FileImage(File(_controller.userImage!))
                    : null,
                child: _controller.userImage == null ? const Icon(Icons.person) : null,
              ),
            ),
          ),
        ],
      ),
      body: _controller.movies.isEmpty
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
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
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
            const SizedBox(height: 50),
            SizedBox(
              height: 600,
              child: PageView.builder(
                itemCount: _controller.movies.length,
                itemBuilder: (context, index) {
                  final movie = _controller.movies[index];
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
                                onTap: () => _controller.likeMovie(movie['id'], 19, context),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/img_8.png',
                                      height: 30,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 30),
                              InkWell(
                                onTap: () => _controller.dislikeMovie(movie['id'], context),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/img_9.png',
                                      height: 30,
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