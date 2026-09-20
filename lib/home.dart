import 'package:flutter/material.dart';

import 'package:stock_market/widgets/navbar.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StandardAdaptiveShell(),
    );
  }
}