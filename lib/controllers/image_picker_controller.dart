import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../models/image_picker_model.dart';

class ImagePickerController {
  final ImagePickerModel _model = ImagePickerModel();

  Future<File?> pickImage(ImageSource source, BuildContext context) async {
    try {
      await _model.requestPermissions(source);
      if ((source == ImageSource.camera && await Permission.camera.isGranted) ||
          (source == ImageSource.gallery && await Permission.storage.isGranted)) {
        final image = await _model.pickImage(source);
        return image;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
    return null;
  }
}