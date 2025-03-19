import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../models/profile_model.dart';
import '../models/user_model.dart';


class ProfileController {
  final UserModel _userModel = UserModel();
  File? _image;

  Future<void> loadUserData() async {
    await _userModel.loadUserData();
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      await _userModel.saveUserImage(_image!.path);
    }
  }

  Future<void> updateName(String name, BuildContext context) async {
    await _userModel.saveUserName(name);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nome atualizado com sucesso!')),
    );
  }

  String? get userName => _userModel.userName;
  String? get userImage => _userModel.userImage;
  File? get image => _image;


}