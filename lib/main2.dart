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
import 'dart:io'; // Para manipular arquivos de imagem

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Verifica se o usuário já está autenticado
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: user != null ? const HomeScreen() : const LoginScreen(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _saveUserData(User user, String name, String? imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    await prefs.setString('userEmail', user.email ?? '');
    await prefs.setString('userUID', user.uid);
    if (imagePath != null) {
      await prefs.setString('userImage', imagePath);
    }
  }

  Future<User?> _signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential =
    await FirebaseAuth.instance.signInWithCredential(credential);
    await _saveUserData(userCredential.user!,
        googleUser.displayName ?? 'Usuário', googleUser.photoUrl);
    return userCredential.user;
  }

  Future<User?> _signInWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName
      ],
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    final userCredential =
    await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    await _saveUserData(
        userCredential.user!, appleCredential.givenName ?? 'Usuário', null);
    return userCredential.user;
  }

  Future<void> _signInWithEmail() async {
    try {
      final userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      print('Erro ao fazer login: $e');
    }
  }

  Future<void> _resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email de recuperação de senha enviado!')),
      );
    } catch (e) {
      print('Erro ao enviar email de recuperação: $e');
    }
  }
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      //appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(height: MediaQuery.of(context).size.height / 20,),
              Image.asset(
                'assets/img.png', // Caminho da imagem
                width: 30, // Largura da imagem
                height: 30, // Altura da imagem
                //fit: BoxFit.cover, // Ajuste da imagem
              ),
              Text(
                "Welcome back",
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "look who is here!",
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 15,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 20,
              ),
              TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.white30,fontFamily: "Montserrat"),
                  hintStyle: TextStyle(color: Colors.white),
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                obscureText: false,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 20,
              ),
              TextField(
                controller: _passwordController,
                style: const TextStyle(color: Colors.white),
                decoration:  InputDecoration(
                  labelStyle: TextStyle(color: Colors.white30,fontFamily: "Montserrat"),
                  hintStyle: TextStyle(color: Colors.white),
                  labelText: 'Password',

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white10,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText; // Alterna o estado
                    });
                  },
                ),
                ),obscureText: _obscureText,
              ),



              Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResetPasswordScreen()),
                      );
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(color: Color(0xFF7A4AB0)),
                    ),
                  )),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all( color: Color(0xFF7A4AB0)!, width: 2),
                    // Borda em roxo claro
                    color: Colors.purple.withOpacity(0.3),

                  ),
                  child: ElevatedButton(
                    onPressed: _signInWithEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      // Torna o fundo transparente
                      shadowColor: Colors.transparent,
                      // Remove a sombra
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 100, vertical: 10),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Color(0xFF7A4AB0), // Cor do texto cinza
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height / 20,), // Espaçamento

              // Linha com "Faça login também"
              Row(
                children: const [
                  Expanded(
                    child: Divider(
                      color: Colors.grey, // Cor da linha
                      thickness: 1,
                      endIndent: 10, // Espaçamento antes do texto
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    ' Or Sign in Wih ',
                    style: TextStyle(color: Colors.white24,fontFamily: "Montserrat",),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey, // Cor da linha
                      thickness: 1,
                      indent: 10, // Espaçamento depois do texto
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 20,), // Espaçamento

              // Botões de Login com Google e Apple
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botão Google
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                      Colors.purple.withOpacity(0.3), // Roxo transparente
                    ),
                    padding: const EdgeInsets.all(16),
                    child: InkWell(
                      onTap: () async {
                        final user = await _signInWithGoogle();
                        if (user != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                          );
                        }
                      },
                      child:Image.asset(
                        'assets/img_2.png', // Caminho da imagem
                        width: 40, // Largura da imagem
                        height: 40, // Altura da imagem
                      ),
                    ),
                  ),
                  SizedBox(width: 20), // Espaçamento entre os ícones

                  // Botão Apple
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                      Colors.white.withOpacity(0.3), // Branco transparente
                    ),
                    padding: const EdgeInsets.all(16),
                    child: InkWell(
                      onTap: () async {
                        final user = await _signInWithApple();
                        if (user != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                          );
                        }
                      },
                      child: Image.asset(
                        'assets/img_3.png', // Caminho da imagem
                        width: 40, // Largura da imagem
                        height: 40, // Altura da imagem
                      ),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height / 20,),
                ],
              ),
              SizedBox(
                height:MediaQuery.of(context).size.height / 20,
              ),
              Padding(
                padding: EdgeInsets.only(left: 50, right: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Don`t have an account?",
                      style: TextStyle(fontSize: 15, color: Colors.white24,fontFamily: "Montserrat",),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: const Text('Registrar',style: TextStyle(color: Color(0xFF7A4AB0),fontFamily: "Montserrat",),),
                    ),
                  ],
                ),
              ),
            ])),
      ),
    );
  }
}

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _sendPasswordResetEmail() async {
    if (_emailController.text.isEmpty) {
      _showMessage('Por favor, insira seu e-mail.');
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text);
      _showMessage(
          'E-mail de recuperação enviado! Verifique sua caixa de entrada.');
    } catch (e) {
      _showMessage(
          'Erro ao enviar e-mail. Verifique o endereço e tente novamente.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Forgot Password?",
              style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "look who is here!",
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            ),
            const Text(
              'Digite seu e-mail para recuperar sua senha:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all( color: Colors.purple.withOpacity(0.4)!, width: 2),
                  // Borda em roxo claro
                  color: Colors.purple.withOpacity(0.3),

                ),
                child: ElevatedButton(
                  onPressed: _sendPasswordResetEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    // Torna o fundo transparente
                    shadowColor: Colors.transparent,
                    // Remove a sombra
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 70, vertical: 16),
                  ),
                  child: const Text(
                    'Send reset instructions',
                    style: TextStyle(
                      color: Colors.grey, // Cor do texto cinza
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            TextButton(
                onPressed: () {},
                child: Text(
                  "Back",
                  style: TextStyle(color: Colors.purple),
                ))
          ],
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  void _navigateToProfileSetup() {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileSetupScreen(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      ),
    );
  }

  Future<void> _saveUserData(User user, String name, String? imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    await prefs.setString('userEmail', user.email ?? '');
    await prefs.setString('userUID', user.uid);
    if (imagePath != null) {
      await prefs.setString('userImage', imagePath);
    }
  }

  Future<User?> _signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential =
    await FirebaseAuth.instance.signInWithCredential(credential);
    await _saveUserData(userCredential.user!,
        googleUser.displayName ?? 'Usuário', googleUser.photoUrl);
    return userCredential.user;
  }

  Future<User?> _signInWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName
      ],
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );
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
              SizedBox(height: MediaQuery.of(context).size.height / 99,),
              Image.asset(
                'assets/img_1.png', // Caminho da imagem
                width: 130, // Largura da imagem
                height: 130, // Altura da imagem
                //fit: BoxFit.cover, // Ajuste da imagem
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an accont?",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Montserrat",
                        color: Colors.white30,
                        fontWeight: FontWeight.bold),
                  ),Text(
                    "Sign in!",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Montserrat",
                        color: Color(0xFF7A4AB0),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 40,),
              Text(
                "Create an account",
                style: TextStyle(
                    fontSize: 35,
                    fontFamily: "Montserrat",
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10,),
              Text(
                "To get started, please complete your \n                   accont registration",
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.white30,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold),
              ),

              SizedBox(
                height: 30,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botão Google
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                      Colors.purple.withOpacity(0.3), // Roxo transparente
                    ),
                    padding: const EdgeInsets.all(16),
                    child: InkWell(
                      onTap: () async {
                        final user = await _signInWithGoogle();
                        if (user != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                          );
                        }
                      },
                      child:Image.asset(
                        'assets/img_2.png', // Caminho da imagem
                        width: 40, // Largura da imagem
                        height: 40, // Altura da imagem
                      ),
                    ),
                  ),
                  SizedBox(width: 20), // Espaçamento entre os ícones

                  // Botão Apple
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                      Colors.white.withOpacity(0.3), // Branco transparente
                    ),
                    padding: const EdgeInsets.all(16),
                    child: InkWell(
                      onTap: () async {
                        final user = await _signInWithApple();
                        if (user != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                          );
                        }
                      },
                      child: Image.asset(
                        'assets/img_3.png', // Caminho da imagem
                        width: 40, // Largura da imagem
                        height: 40, // Altura da imagem
                      ),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height / 20,),
                ],
              ), Row(
                children: const [
                  Expanded(
                    child: Divider(
                      color: Colors.grey, // Cor da linha
                      thickness: 1,
                      endIndent: 10, // Espaçamento antes do texto
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    ' Or Sign in Wih ',
                    style: TextStyle(color: Colors.white24,fontFamily: "Montserrat",),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey, // Cor da linha
                      thickness: 1,
                      indent: 10, // Espaçamento depois do texto
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                obscureText: true,
              ),

              SizedBox(
                height: 30,
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                obscureText: true,
              ),

              SizedBox(
                height: 30,
              ),
              TextField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirmar Senha',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                obscureText: true,
              ),

              const SizedBox(height: 50),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all( color: Colors.purple.withOpacity(0.4)!, width: 2),
                    // Borda em roxo claro
                    color: Colors.purple.withOpacity(0.3),

                  ),
                  child: ElevatedButton(
                    onPressed: _navigateToProfileSetup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      // Torna o fundo transparente
                      shadowColor: Colors.transparent,
                      // Remove a sombra
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 70, vertical: 16),
                    ),
                    child: const Text(
                      'Continuar',
                      style: TextStyle(
                        color: Colors.grey, // Cor do texto cinza
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
class ProfileSetupScreen extends StatefulWidget {
  final String email;
  final String password;

  const ProfileSetupScreen(
      {super.key, required this.email, required this.password});

  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
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

  Future<void> _registerWithEmail() async {
    try {
      // Registrar o usuário no Firebase
      final userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.email,
        password: widget.password,
      );

      // Salvar o nome e a imagem no SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', _nameController.text);
      if (_image != null) {
        await prefs.setString('userImage', _image!.path);
      }

      // Navegar para a tela inicial
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      print('Erro ao registrar: $e');
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
              Text(
                "Forgot Password?",
                style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "look who is here!",
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // Centraliza horizontalmente
                crossAxisAlignment: CrossAxisAlignment.center,
                // Centraliza verticalmente
                children: [
                  InkWell(
                    onTap: _navigateToImagePicker,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.7),
                        // Roxo escuro com transparência
                        borderRadius: BorderRadius.circular(30),
                        image: _image != null
                            ? DecorationImage(
                          image: FileImage(_image!),
                          fit: BoxFit.cover, // Ajusta a imagem ao tamanho do container
                        )
                            : null,
                      ),
                      child:  _image == null
                          ? const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      )
                          : null, // Ícone branco para contraste
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    'Choose Image',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),

              const SizedBox(height: 16),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all( color: Colors.purple.withOpacity(0.4)!, width: 2),
                    // Borda em roxo claro
                    color: Colors.purple.withOpacity(0.3),

                  ),
                  child: ElevatedButton(
                    onPressed: _registerWithEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      // Torna o fundo transparente
                      shadowColor: Colors.transparent,
                      // Remove a sombra
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 70, vertical: 16),
                    ),
                    child: const Text(
                      'Continuar',
                      style: TextStyle(
                        color: Colors.grey, // Cor do texto cinza
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

class ImagePickerScreen extends StatelessWidget {
  const ImagePickerScreen({super.key});

  Future<File?> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      print('Erro ao selecionar imagem: $e');
    }
    return null;
  }

  Future<void> _requestPermissions(
      ImageSource source, BuildContext context) async {
    if (source == ImageSource.camera) {
      final status = await Permission.camera.request();
      if (status.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permissão da câmera negada.')),
        );
      }
    } else {
      final status = await Permission.storage.request();
      if (status.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permissão da galeria negada.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.purple), // Seta roxa
          onPressed: () {
            Navigator.of(context).pop(); // Voltar para a tela anterior
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 60),
          child: const Text(
            'Choose Image',

            style: TextStyle(color: Colors.purple), // Título
          ),
        ),
        backgroundColor: Colors.black, // Fundo branco
        elevation: 0, // Remove a sombra
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // Centraliza horizontalmente
              //crossAxisAlignment: CrossAxisAlignment.center,
              // Centraliza verticalmente
              children: [
                InkWell(
                  onTap: () async {
                    await _requestPermissions(ImageSource.camera, context);
                    if (await Permission.camera.isGranted) {
                      final image = await _pickImage(ImageSource.camera);
                      if (image != null) {
                        Navigator.pop(context, image);
                      }
                    }
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.7),
                      // Roxo escuro com transparência
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(Icons.camera_alt,
                        color: Colors.white), // Ícone branco para contraste
                  ),
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () async {
                    await _requestPermissions(ImageSource.gallery, context);
                    if (await Permission.storage.isGranted) {
                      final image = await _pickImage(ImageSource.gallery);
                      if (image != null) {
                        Navigator.pop(context, image);
                      }
                    }
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.7),
                      // Roxo escuro com transparência
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(Icons.style_outlined,
                        color: Colors.white), // Ícone branco para contraste
                  ),),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
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
            colors: [Colors.black, Colors.blue],
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
                            movie['attributes']['title'] ?? 'Sem título',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          right: 20,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.thumb_up, color: Colors.white),
                                onPressed: () => _likeMovie(movie['id'], 19),
                              ),
                              IconButton(
                                icon: const Icon(Icons.thumb_down, color: Colors.white),
                                onPressed: () => _dislikeMovie(movie['id']),
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
class ProfileScreenn extends StatefulWidget {
  const ProfileScreenn({super.key});

  @override
  _ProfileScreennState createState() => _ProfileScreennState();
}

class _ProfileScreennState extends State<ProfileScreenn> {
  final TextEditingController _nameController = TextEditingController();
  File? _image;
  String? userImage;
  String? userName;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName');
      userImage = prefs.getString('userImage');
    });
  }

  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userImage', _image!.path);
    }
  }

  Future<void> _updateName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', _nameController.text);
    setState(() {
      userName = _nameController.text;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nome atualizado com sucesso!')),
    );
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage:
              userImage != null ? FileImage(File(userImage!)) : null,
              child:
              userImage == null ? const Icon(Icons.person, size: 50) : null,
            ),
            const SizedBox(height: 16),
            Text(userName ?? 'Usuário'),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Editar Nome'),
            ),
            ElevatedButton(
              onPressed: _updateName,
              child: const Text('Salvar Nome'),
            ),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Alterar Foto'),
            ),
            ElevatedButton(
              onPressed: _logout,
              child: const Text('Sair'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  String? userImage;
  String? userName;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'Usuário';
      userImage = prefs.getString('userImage');
    });
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _deleteAccount() async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir conta: $e')),
      );
    }
  }

  void _navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
    ).then((_) => _loadUserData());
  }

  void _navigateToChangePassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: InkWell(onTap:(){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreenn()),
          );
        },child: const Text('Edit Profile', style: TextStyle(color: Colors.white))),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: userImage != null ? FileImage(File(userImage!)) : null,
                  child: userImage == null ? const Icon(Icons.person, size: 50) : null,
                ),
                const SizedBox(width: 16),
                Text(userName ?? 'Usuário',
                    style: const TextStyle(color: Colors.white, fontSize: 20)),
              ],
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: _navigateToChangePassword,
              child: _buildRoundedContainer('Change Password'),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _deleteAccount,
              child: _buildRoundedContainer('Delete My Account'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundedContainer(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 18)),
          const Icon(Icons.arrow_forward_ios, color: Colors.white),
        ],
      ),
    );
  }
}

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
      ),
      body: Center(child: Text('Tela de edição de nome e foto')),
    );
  }
}

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();

    Future<void> _changePassword() async {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final cred = EmailAuthProvider.credential(
              email: user.email!, password: oldPasswordController.text);
          await user.reauthenticateWithCredential(cred);
          await user.updatePassword(newPasswordController.text);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Senha atualizada com sucesso!')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar senha: $e')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Alterar Senha')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha Atual'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Nova Senha'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _changePassword,
              child: const Text('Atualizar Senha'),
            ),
          ],
        ),
      ),
    );
  }
}