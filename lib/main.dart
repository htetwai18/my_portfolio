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

class NavLink extends StatefulWidget {
  final String title;
  final String page;

  const NavLink({
    super.key,
    required this.title,
    required this.page,
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
            if (widget.title == 'Home') {
              if (widget.title != widget.page) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HeroSection(page: 'Home')));
              }
            }
            // if (widget.title == 'Education') {
            //   if (widget.title != widget.page) {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) =>
            //                 const EducationPage(page: 'Education')));
            //   }
            // }

            // if (widget.title == 'Projects') {
            //   if (widget.title != widget.page) {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) =>
            //                 const ProjectsPage(page: 'Projects')));
            //   }
            // }

            // if (widget.title == 'Contact') {
            //   if (widget.title != widget.page) {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => const ContactPage(
            //                   page: 'Contact',
            //                 )));
            //   }
            // }

            // if (widget.title == 'Experiences') {
            //   if (widget.title != widget.page) {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) =>
            //                 const ExperiencePage(page: 'Experiences')));
            //   }
            // }
          },
          child: AnimatedScale(
            scale: _isHovered ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Text(
              widget.title,
              style: TextStyle(
                color: (widget.page == widget.title)
                    ? const Color(0xFFBB86FC)
                    : Colors.white,
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
