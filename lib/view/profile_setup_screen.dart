import 'package:flutter/material.dart';
import 'package:projectloomi/view/image_picker_controller.dart';
import 'dart:io';
import '../controllers/profile_setup_controller.dart';


class ProfileSetupScreen extends StatefulWidget {
  final String email;
  final String password;

  const ProfileSetupScreen({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final ProfileSetupController _controller = ProfileSetupController();
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
              SizedBox(height: MediaQuery.of(context).size.height / 20),
              Image.asset(
                'assets/img.png',
                width: 30,
                height: 30,
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 20),
              Text(
                "Tell us more!",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 35,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 99),
              Text(
                "look who is here!",
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Montserrat",
                  color: Colors.white24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: _navigateToImagePicker,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.height / 6,
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(30),
                        image: _image != null
                            ? DecorationImage(
                          image: FileImage(_image!),
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                      child: _image == null
                          ? Image.asset(
                        'assets/img_4.png',
                        width: 5,
                        height: 5,
                      )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      Text(
                        'CHOOSE IMAGE',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Montserrat",
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        ' A square .jpg .gif \n or .png image \n 200x200 or larger',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Montserrat",
                          color: Colors.white24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 10),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Your name',
                  labelStyle: TextStyle(color: Colors.white30, fontFamily: "Montserrat"),
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 20),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.purple.withOpacity(0.4), width: 2),
                    color: Colors.purple.withOpacity(0.3),
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      await _controller.registerWithEmail(
                        widget.email,
                        widget.password,
                        _nameController.text,
                        _image,
                        context,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 100,
                        vertical: 10,
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Back',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: "Montserrat",
                    color: Colors.purple.withOpacity(0.4),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}