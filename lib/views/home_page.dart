import 'package:flutter/material.dart';
import 'widgets/custom_app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Home Page'),
      body: const Center(child: Text("Welcome to the Home Page!")),
    );
  }
}
