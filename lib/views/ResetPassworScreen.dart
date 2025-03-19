
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';



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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 70,),
              Image.asset(
                'assets/img.png', // Caminho da imagem
                width: 50, // Largura da imagem
                height: 50, // Altura da imagem
                //fit: BoxFit.cover, // Ajuste da imagem
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 20,),
              Text(
                "Forgot Password?",
                style: TextStyle(
                    fontSize: 35,
                    fontFamily: "Montserrat",
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),SizedBox(height: MediaQuery.of(context).size.height / 20,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Enter the email address you used when you\njoined and we’ll send you instructions to reset\nyour password.",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white24,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.bold),
                ),
              ),SizedBox(height: MediaQuery.of(context).size.height / 10,),


              TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  labelStyle: TextStyle(color: Colors.white30,fontFamily: "Montserrat"),
                  hintStyle: TextStyle(color: Colors.white),

                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 10,),
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
        TextButton(onPressed: (){
          Navigator.pop(context);

        },
          child: Text(
            "Sign in!",
            style: TextStyle(
                fontSize: 15,
                fontFamily: "Montserrat",
                color: Color(0xFF7A4AB0),
                fontWeight: FontWeight.bold),
          ),),
            ],
          ),
        ),
      ),
    );
  }
}