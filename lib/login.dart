import 'package:flutter/material.dart';
import 'package:stock_market/widgets/big_button.dart';
import 'package:stock_market/widgets/edit_text.dart';
import 'package:stock_market/home.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _login(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Screen')),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blueGrey[900],
          borderRadius: BorderRadius.circular(10),
        ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Login', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
              const SizedBox(height: 20),
              EditText(label: 'Email', obscureText: false),
              const SizedBox(height: 20),
              EditText(label: 'Password', obscureText: true),
              const SizedBox(height: 20),
              BigButton(onPressed: () => _login(context), text: 'Login'),
            ],
          )
        ),
      );
  }
}