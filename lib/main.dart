import 'package:flutter/material.dart';
import 'package:stock_market/auth.dart';
import 'package:stock_market/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Market',
      theme: buildAppTheme(),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
    const SplashScreen({super.key});

    @override
    State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
    @override
    void initState() {
      super.initState();
      _navigateToHome();
    }

    Future<void> _navigateToHome() async {
      await Future.delayed(const Duration(seconds: 2));
      if(!mounted) return;

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AuthScreen()),
      );
    }

    @override
    Widget build(BuildContext context) {
      return const Scaffold(
        body: Center(
          child: Text('Splash Screen'),
        ),
      );
    }
}


  
