import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hwl_portforlio/main.dart';
import 'dart:math' as math;
import 'package:hwl_portforlio/pages/project_detail.dart';

// --- Data Model ---
class Project {
  final String imagePath;
  final String title;
  final String description;
  // final String role;
  // final List<String> images;
  // final List<String> techStacks;
  // final List<String> psAndKf;
  // final List<String> challenges;
  final List<IconData> techIcons; // Using IconData for simplicity

  const Project({
    required this.imagePath,
    required this.title,
    required this.description,
    // required this.role,
    // required this.images,
    // required this.techStacks,
    // required this.psAndKf,
    // required this.challenges,
    required this.techIcons,
  });
}

// --- Main Page Widget ---
class ProjectsPage extends StatefulWidget {
  final String page;
  const ProjectsPage({super.key, required this.page});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _navbarFadeAnimation; // For the nav bar

  // --- Projects Data ---
  final List<Project> _projects = [
    Project(
      imagePath: 'assets/images/digicraft_main.png',
      title: 'Digicraft Home App',
      description:
          'A smart home control app that connects users with their IoT devices, allowing them to monitor and manage appliances remotely.',
      techIcons: [FontAwesomeIcons.flutter],
    ),
    Project(
      imagePath: 'assets/images/zcultures_main.png',
      title: 'Zcultures App',
      description:
          'A global AI-powered social commerce platform that uses an O2O strategy to connect brands, creators, nightlife venues.',
      techIcons: [FontAwesomeIcons.flutter],
    ),
    Project(
      imagePath: 'assets/images/suzuki_main.png',
      title: 'Suzuki Smart Order App',
      description:
          'An order management system developed for Suzuki, featuring product catalog, smart notifications, and Google Sign-In for easy access.',
      techIcons: [FontAwesomeIcons.flutter],
    ),
    Project(
      imagePath: 'assets/images/weday_main.png',
      title: 'Weday App',
      description:
          'A social app with features for posts, comments, nested replies, reactions, and live streaming powered by Agora SDK.',
      techIcons: [FontAwesomeIcons.flutter],
    ),

    Project(
      imagePath: 'assets/images/arfi_main.png',
      title: 'ARFI Ecommerce App',
      description:
          'A mobile e-commerce platform that enables brand owners to showcase products, manage customer orders, and handle online transactions seamlessly.',
      techIcons: [FontAwesomeIcons.flutter],
    ),
    Project(
      imagePath: 'assets/images/dr_rej_main.png',
      title: 'Dr Rejvue Clinic Membership App',
      description:
          'A membership management app for clinic patients to manage subscriptions, earn and redeem points, and access services with real-time updates.',
      techIcons: [FontAwesomeIcons.flutter],
    ),
    Project(
      imagePath: 'assets/images/hrm_main.png',
      title: 'Kwin HR Management App',
      description:
          'A complete HR solution providing employee management, leave requests, and performance tracking in one unified mobile platform.',
      techIcons: [FontAwesomeIcons.flutter],
    ),
    // Project(
    //   imagePath: 'assets/placeholder.png',
    //   title: 'Yankin Bubble Tea POS App',
    //   description:
    //   'A point-of-sale application redesigned from a legacy system, supporting offline data storage, order tracking, and efficient daily operations.',
    //   techIcons: [],
    // ),
    // Project(
    //   imagePath: 'assets/placeholder.png',
    //   title: 'Kwin Client Management App',
    //   description:
    //   'A lightweight client management tool that automates subscription expiry tracking and provides easy manual access control for customers.',
    //   techIcons: [],
    // ),
    Project(
      imagePath: 'assets/images/tiger_main.png',
      title: 'Tiger Backoffice',
      description:
          'A backoffice management system for online casinos, providing modules for banking, transactions, user settings, and log tracking.',
      techIcons: [FontAwesomeIcons.laravel],
    ),
    Project(
      imagePath: 'assets/images/infinity_main.jpg',
      title: 'Infinity 688 Backoffice',
      description:
          'A backoffice solution for casino operators, designed for secure transaction handling, banking integration, and operational monitoring.',
      techIcons: [FontAwesomeIcons.laravel],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));

    _navbarFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.6, 1.0,
            curve: Curves.easeOut), // Appears towards the end
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isDesktop = screenSize.width > 800; // Arbitrary breakpoint
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF121212),
        ),
        child: Stack(
          children: [
            Positioned(
              top: isDesktop ? 40 : 20, // Adjust padding for desktop/mobile
              right: isDesktop ? 60 : 12,
              left: isDesktop ? null : 12,
              child: FadeTransition(
                opacity: _navbarFadeAnimation,
                child: SizedBox(
                  height: 50,
                  child: ListView(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: [
                      NavLink(title: 'Home', page: widget.page),
                      NavLink(title: 'Projects', page: widget.page),
                      NavLink(title: 'Experiences', page: widget.page),
                      NavLink(title: 'Education', page: widget.page),
                      NavLink(title: 'Contact', page: widget.page),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 50),
                padding: EdgeInsets.only(
                  top: isDesktop ? 40 : 20, // Adjust padding for desktop/mobile
                ),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          vertical: 48.0, horizontal: 24.0),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1200),
                          child: Column(
                            children: [
                              _buildHeader(),
                              const SizedBox(height: 48),
                              _buildProjectsGrid(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          'My Projects',
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFBB86FC),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'A selection of my recent work, showcasing my skills and experience in software development.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey[400]),
        ),
      ],
    );
  }

  Widget _buildProjectsGrid() {
    return Wrap(
      spacing: 24, // Horizontal space between cards
      runSpacing: 24, // Vertical space between cards
      alignment: WrapAlignment.center,
      children:
          _projects.map((project) => ProjectCard(project: project)).toList(),
    );
  }
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
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 380,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: Colors.grey.shade700),
          boxShadow:
              // _isHovered
              //     ? [
              //         BoxShadow(
              //           color: Colors.black.withOpacity(0.1),
              //           spreadRadius: 4,
              //           blurRadius: 20,
              //           offset: const Offset(0, 10),
              //         ),
              //       ]
              //     :
              [
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
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
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
              decoration: const BoxDecoration(
                  color: Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16))),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Row(
                    children: widget.project.techIcons
                        .map((icon) => _buildTechIcon(icon))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ElevatedButton(
                      //   onPressed: () {},
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor:
                      //         const Color(0xFF1A237E), // Deep indigo
                      //     foregroundColor: Colors.white,
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 24, vertical: 16),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(8.0),
                      //     ),
                      //   ),
                      //   child: const Text('GitHub'),
                      // ),
                      // const SizedBox(width: 12),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProjectDetailPage()));
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
