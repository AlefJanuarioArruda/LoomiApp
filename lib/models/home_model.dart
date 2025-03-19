import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class HomeModel {
  final Dio _dio = Dio();
  String? userImage;
  List<dynamic> movies = [];

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userImage = prefs.getString('userImage');
  }

  Future<void> fetchMovies() async {
    try {
      final response = await _dio.get(
        'https://untold-strapi.api.prod.loomi.com.br/api/movies?populate=poster',
      );
      movies = response.data['data'];
    } catch (e) {
      throw e; // Lança a exceção para ser tratada no Controller
    }
  }

  Future<void> likeMovie(int movieId, int userId) async {
    try {
      await _dio.post(
        'https://untold-strapi.api.prod.loomi.com.br/api/likes',
        data: {
          "data": {"movie_id": movieId, "user_id": userId}
        },
      );
    } catch (e) {
      throw e; // Lança a exceção para ser tratada no Controller
    }
  }

  Future<void> dislikeMovie(int likeId) async {
    try {
      await _dio.delete(
        'https://untold-strapi.api.prod.loomi.com.br/api/likes/$likeId',
      );
    } catch (e) {
      throw e; // Lança a exceção para ser tratada no Controller
    }
  }
}