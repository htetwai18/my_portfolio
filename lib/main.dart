import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

class NavLink extends StatefulWidget {
  final String title;
  final String page;
  final Function(String)? onSectionClick;

  const NavLink({
    super.key,
    required this.title,
    required this.page,
    this.onSectionClick,
  });

  @override
  State<NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<NavLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() => _isHovered = true),
      onExit: (event) => setState(() => _isHovered = false),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextButton(
          style: const ButtonStyle(
            overlayColor: MaterialStatePropertyAll(Colors.transparent),
            padding: MaterialStatePropertyAll(EdgeInsets.zero),
          ),
          onPressed: () {
            // Use callback to scroll to section if available
            if (widget.onSectionClick != null) {
              widget.onSectionClick!(widget.title);
            }
          },
          child: AnimatedScale(
            scale: _isHovered ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Text(
              widget.title,
              style:  GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16, // Increased base font size
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
