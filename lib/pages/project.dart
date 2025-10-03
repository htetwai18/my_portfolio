import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'package:hwl_portforlio/pages/project_detail.dart';

// --- Data Model ---
class Project {
  final String imagePath;
  final String title;
  final String description;
  final String role;
  final String company;
  final String platform;
  final String iosLink;
  final String androidLink;
  final String webLink;
  final List<String> images;
  final List<Map<String, String>> techStacks;
  final List<String> psAndKf;
  final List<String> challenges;
  final IconData techIcons;
  final String? status;

  const Project({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.role,
    required this.company,
    required this.platform,
    required this.iosLink,
    required this.androidLink,
    required this.webLink,
    required this.images,
    required this.techStacks,
    required this.psAndKf,
    required this.challenges,
    required this.techIcons,
    this.status,
  });
}

// --- Project Card Widget ---
class ProjectCard extends StatefulWidget {
  final Project project;

  const ProjectCard({super.key, required this.project});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isDesktop = screenSize.width > 800;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 300,
        height: 500,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12.0),
          // border: Border.all(color: Colors.grey.shade700),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        transform:
            _isHovered ? (Matrix4.identity()..scale(1.03)) : Matrix4.identity(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              child: Image.asset(
                widget.project.imagePath,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                // In case asset is not found
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: const Color(0xFF2D2D2D),
                  alignment: Alignment.center,
                  child:
                      const Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              ),
            ),
            Container(
              height: isDesktop ? null : 300,
              decoration: const BoxDecoration(
                  color: Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12))),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTechIcon(widget.project.techIcons),
                      // const SizedBox(width: 4),
                      Text(
                        widget.project.company,
                        style: GoogleFonts.poppins(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.project.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.project.description,
                    style: TextStyle(color: Colors.grey[400], height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  if (!isDesktop) const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProjectDetailPage(
                                        project: widget.project,
                                      )));
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF2D2D2D),
                          foregroundColor: const Color(0xFFBB86FC),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text('View Detail'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechIcon(IconData iconData) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: CircleAvatar(
        radius: 14,
        backgroundColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
            .withOpacity(0.2),
        child: Icon(iconData,
            color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                .withOpacity(1.0),
            size: 16),
      ),
    );
  }
}
