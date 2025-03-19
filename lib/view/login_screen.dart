import 'package:flutter/material.dart';
import 'package:projectloomi/view/register_screen.dart';
import 'package:projectloomi/view/reset_password_screen.dart';
import '../controllers/login_controller.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginController _controller = LoginController();
  bool _obscureText = true;

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
        Text(
          "Welcome back",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 35,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "look who is here!",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 15,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height / 20),
        TextField(
          controller: _emailController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelStyle: TextStyle(color: Colors.white30, fontFamily: "Montserrat"),
            hintStyle: TextStyle(color: Colors.white),
            labelText: 'Email',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),),
          SizedBox(height: MediaQuery.of(context).size.height / 20),
          TextField(
            controller: _passwordController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.white30, fontFamily: "Montserrat"),
              hintStyle: TextStyle(color: Colors.white),
              labelText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white10,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
            obscureText: _obscureText,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResetPasswordScreen()),
                );
              },
              child: const Text(
                'Forgot password?',
                style: TextStyle(color: Color(0xFF7A4AB0)),
              ),
            ),
          ),
          SizedBox(height: 30),
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFF7A4AB0), width: 2),
                color: Colors.purple.withOpacity(0.3),
              ),
              child: ElevatedButton(
                onPressed: () async {
                  await _controller.signInWithEmail(
                    _emailController.text,
                    _passwordController.text,
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
                  'Login',
                  style: TextStyle(
                    color: Color(0xFF7A4AB0),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 20),
          Row(
            children: const [
              Expanded(
                child: Divider(
                  color: Colors.grey,
                  thickness: 1,
                  endIndent: 10,
                ),
              ),
              Text(
                ' Or Sign in With ',
                style: TextStyle(color: Colors.white24, fontFamily: "Montserrat"),
              ),
              Expanded(
                child: Divider(
                  color: Colors.grey,
                  thickness: 1,
                  indent: 10,
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purple.withOpacity(0.3),
                ),
                padding: const EdgeInsets.all(16),
                child: InkWell(
                  onTap: () async {
                    await _controller.signInWithGoogle(context);
                  },
                  child: Image.asset(
                    'assets/img_2.png',
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.3),
                ),
                padding: const EdgeInsets.all(16),
                child: InkWell(
                  onTap: () async {
                    await _controller.signInWithApple(context);
                  },
                  child: Image.asset(
                    'assets/img_3.png',
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 20),
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white24,
                    fontFamily: "Montserrat",
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterScreen()),
                    );
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Color(0xFF7A4AB0), fontFamily: "Montserrat"),
                  ),
                ),
              ],
            ),
          ),
          ],
        ),
      ),
    ),
    );
  }
}