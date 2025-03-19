import 'package:flutter/material.dart';

import '../models/home_model.dart';


class HomeController {
  final HomeModel _homeModel = HomeModel();

  Future<void> loadUserData() async {
    await _homeModel.loadUserData();
  }

  Future<void> fetchMovies() async {
    await _homeModel.fetchMovies();
  }

  Future<void> likeMovie(int movieId, int userId, BuildContext context) async {
    try {
      await _homeModel.likeMovie(movieId, userId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Like enviado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar like: $e')),
      );
    }
  }

  Future<void> dislikeMovie(int likeId, BuildContext context) async {
    try {
      await _homeModel.dislikeMovie(likeId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deslike removido com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao remover deslike: $e')),
      );
    }
  }

  String? get userImage => _homeModel.userImage;
  List<dynamic> get movies => _homeModel.movies;
}