import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projectloomi/view/home_screen.dart';
import 'package:projectloomi/view/login_screen.dart';





class MyApp extends StatelessWidget {
  final User? user;

  const MyApp({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Aguarda 3 segundos antes de navegar
    Future.delayed(const Duration(seconds: 3), () async {
      // Verifica se o usuário está autenticado
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;

      // Navega para a tela apropriada após a splash screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => user != null ? const HomeScreen() : const LoginScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Cor de fundo
      body: Center(
        child: Image.asset(
          'assets/img_1.png', // Caminho da sua imagem
          width: 300, // Ajuste o tamanho da imagem conforme necessário
        ),
      ),
    );
  }
}