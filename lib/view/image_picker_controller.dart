import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/image_picker_controller.dart';
import 'image_picker_controller.dart';
import 'dart:io';

class ImagePickerScreen extends StatelessWidget {
  const ImagePickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ImagePickerController _controller = ImagePickerController();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.purple),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 60),
          child: const Text(
            'CHOOSE IMAGE',
            style: TextStyle(
              fontSize: 15,
              fontFamily: "Montserrat",
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    final image = await _controller.pickImage(ImageSource.camera, context);
                    if (image != null) {
                      Navigator.pop(context, image);
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.height / 6,
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/img_4.png'),
                        const Text(
                          '\nTake a \n photo',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Montserrat",
                            color: Colors.white24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () async {
                    final image = await _controller.pickImage(ImageSource.gallery, context);
                    if (image != null) {
                      Navigator.pop(context, image);
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.height / 6,
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/img_5.png'),
                        const Text(
                          '\nChoose from \n gallery',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Montserrat",
                            color: Colors.white24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}