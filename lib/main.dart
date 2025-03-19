import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projectloomi/services/firebase_options.dart';
import 'package:projectloomi/view/myapp.dart';


void main() async {
  // Inicializa o Flutter e o Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Verifica se o usuário já está autenticado
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;

  // Inicia o aplicativo
  runApp(MyApp(user: user));
}

