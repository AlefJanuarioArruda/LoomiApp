import 'dart:io';

import 'package:flutter/material.dart';
import 'package:projectloomi/view/profile_screen_view.dart';

import '../controllers/profile_controller.dart';


class ProfileScreenn extends StatefulWidget {
  const ProfileScreenn({super.key});

  @override
  _ProfileScreennState createState() => _ProfileScreennState();
}

class _ProfileScreennState extends State<ProfileScreenn> {
  final TextEditingController _nameController = TextEditingController();
  final ProfileController _controller = ProfileController();

  @override
  void initState() {
    super.initState();
    _controller.loadUserData().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.purple),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Edit\nProfile",
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                children: [
                  InkWell(
                    onTap: () async {
                      await _controller.pickImage();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfileScreen()),
                      );
                      setState(() {});
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.height / 6,
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(30),
                        image: _controller.userImage != null
                            ? DecorationImage(
                          image: FileImage(File(_controller.userImage!)),
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                      child: _controller.userImage == null
                          ? Image.asset(
                        'assets/img_4.png',
                        width: 40,
                        height: 40,
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
                            fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        ' A square .jpg .gif \n or .png image \n 200x200 or larger',
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Montserrat",
                            color: Colors.white24,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(_controller.userName ?? 'User'),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Edit Name',
                  labelStyle: TextStyle(color: Colors.white30, fontFamily: "Montserrat"),
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0xFF7A4AB0), width: 2),
                    color: Colors.purple.withOpacity(0.3),
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      await _controller.updateName(_nameController.text, context);
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                    ),
                    child: const Text(
                      'Save Name',
                      style: TextStyle(
                        color: Color(0xFF7A4AB0),
                        fontSize: 16,
                      ),
                    ),
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