import 'package:flutter/material.dart';
import 'package:hwl_portforlio/pages/hero_section.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Htet Wai Lwin Portfolio',
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.blue,
      ),
      home: const HeroSection(
        page: 'Home',
      ),
    );
  }
}




