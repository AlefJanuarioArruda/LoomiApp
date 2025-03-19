import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class ImagePickerModel {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      print('Erro ao selecionar imagem: $e');
    }
    return null;
  }

  Future<void> requestPermissions(ImageSource source) async {
    if (source == ImageSource.camera) {
      final status = await Permission.camera.request();
      if (status.isDenied) {
        throw 'Permissão da câmera negada.';
      }
    } else {
      final status = await Permission.storage.request();
      if (status.isDenied) {
        throw 'Permissão da galeria negada.';
      }
    }
  }
}