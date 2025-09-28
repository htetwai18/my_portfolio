import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hwl_portforlio/main.dart';
import 'package:hwl_portforlio/pages/education.dart';
import 'dart:html' as html;
import 'package:hwl_portforlio/pages/experience.dart';
import 'package:hwl_portforlio/pages/project.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class HeroSection extends StatefulWidget {
  final String page;
  const HeroSection({
    super.key,
    required this.page,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  // Add controllers to get the text field values
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  // Scroll controller for smooth scrolling
  final ScrollController _scrollController = ScrollController();

  // GlobalKeys for each section

  final GlobalKey _experiencesKey = GlobalKey();
  final GlobalKey _educationKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  // Back to top button visibility
  bool _showBackToTop = false;

  late AnimationController _controller;
  late Animation<Offset> _nameSlideAnimation;
  late Animation<Offset> _titleSlideAnimation;
  late Animation<Offset> _descriptionSlideAnimation;
  late Animation<double> _imageScaleAnimation;
  late Animation<double> _navbarFadeAnimation;

  final List<Experience> _experiences = const [
    Experience(
      title: 'Flutter & Laravel Developer',
      company: 'Whatif Solutions Sdn Bhd',
      duration: 'May 2025 - Sep 2025',
      responsibilities: [
        'Digicraft Home App',
        'Zcultures App',
        'Tiger Online Casino Backoffice',
        'Infinity 688 Casino Backoffice',
      ],
      link: 'https://www.whatifsolutions.my/',
    ),
    Experience(
      title: 'Part-time Flutter Developer',
      company: 'My Day Thu Kywal',
      duration: 'Sep 2024 - Jan 2025',
      responsibilities: [
        'Weday App',
      ],
      link: 'https://myday.com.mm/',
    ),
    Experience(
      title: 'Flutter Developer',
      company: 'Kwin Technologies',
      duration: 'Sep 2022 - Apr 2025',
      responsibilities: [
        'Suzuki Smart Order App',
        'Kwin HR Management App',
        'ARFI Ecommerce App',
        'Dr Rejvue Aesthetic Clinic Membership App',
        'Yankin Bubble Tea POS App',
        'Kwin Client Management App',
      ],
      link: 'http://kwintechnologies.com/',
    ),
  ];

  final List<EducationItem> _educationItems = const [
    EducationItem(
      degree: 'Bachelor of Science - BSc(Hons), Computing',
      university: 'University of Greenwich',
      duration: 'Dec 2024 - Nov 2025',
      linkUni: 'https://www.gre.ac.uk/',
      linkDegree: '',
    ),
    EducationItem(
      degree: 'Level-5 Higher Diploma, Computing',
      university: 'NCC Education',
      duration: 'Dec 2023 - Oct 2024',
      linkUni: 'https://www.nccedu.com/',
      linkDegree:
          'https://drive.google.com/file/d/17Arr6LxB79z-KRWQOodM7-jT2C9dT1Md/view?usp=sharing',
    ),
    EducationItem(
      degree: 'Level-4 Higher Diploma, Computing',
      university: 'NCC Education',
      duration: 'Jan 2023 - Dec 2023',
      linkUni: 'https://www.nccedu.com/',
      linkDegree:
          'https://drive.google.com/file/d/1JpU3znVEIstXyJopNBdGqJ8ysAgDo4jA/view?usp=sharing',
    ),
    EducationItem(
      degree: 'Final Part II - MBBS',
      university: 'University of Medicine 2, Yangon',
      duration: 'Dec 2014 - Jan 2020',
      linkUni: 'https://um2ygn.edu.mm/',
      linkDegree: '',
    ),
  ];

  final List<CertificationItem> _certificationItems = const [
    CertificationItem(
      icon: Icons.phone_android,
      name: 'Flutter Full Term Course(PADC)',
      link:
          'https://drive.google.com/file/d/1omIB7SXl7D_xmjbrkk-nEPDkfPuxvqD8/view?usp=sharing',
    ),
  ];

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
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Add scroll listener to show/hide back to top button
    _scrollController.addListener(() {
      if (_scrollController.offset >= 400) {
        if (!_showBackToTop) {
          setState(() {
            _showBackToTop = true;
          });
        }
      } else {
        if (_showBackToTop) {
          setState(() {
            _showBackToTop = false;
          });
        }
      }
    });

    // Animations remain the same
    _nameSlideAnimation =
        Tween<Offset>(begin: const Offset(-0.2, 0), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _controller,
                curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic)));
    _titleSlideAnimation =
        Tween<Offset>(begin: const Offset(-0.2, 0), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _controller,
                curve: const Interval(0.1, 0.7, curve: Curves.easeOutCubic)));
    _descriptionSlideAnimation =
        Tween<Offset>(begin: const Offset(-0.2, 0), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _controller,
                curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic)));
    _imageScaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
        CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.4, 1.0, curve: Curves.easeOutBack)));
    _navbarFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.6, 1.0, curve: Curves.easeOut)));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // Method to scroll to specific section
  void _scrollToSection(String section) {
    GlobalKey? targetKey;

    switch (section) {
      case 'Experiences':
        targetKey = _experiencesKey;
        break;
      case 'Education':
        targetKey = _educationKey;
        break;
      case 'Projects':
        targetKey = _projectsKey;
        break;
      case 'Contact':
        targetKey = _contactKey;
        break;
    }

    if (targetKey != null && targetKey.currentContext != null) {
      Scrollable.ensureVisible(
        targetKey.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        alignment: 0.1, // Scroll to show the section near the top
      );
    }
  }

  // Method to scroll to top
  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _sendEmail() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
      const serviceId = 'service_dx6jkwf';
      const templateId = 'template_dsbktpk';
      const userId = 'nEOpcklJoxm-lX5As';

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'name': _nameController.text,
            'email': _emailController.text,
            'message': _messageController.text,
          }
        }),
      );

      if (response.statusCode == 200) {
        // Clear the form fields
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Message sent successfully!')),
        );
      } else {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to send message. Please try again.')),
        );
      }
    }
  }

  void _downloadResume() {
    const String assetPath = "assets/NCCL5_HWL_certificate_1.pdf";

    html.AnchorElement(href: assetPath)
      ..setAttribute("download", "NCCL5_HWL_certificate_1.pdf")
      ..click();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isDesktop = screenSize.width > 960;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      floatingActionButton: _showBackToTop
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              backgroundColor: const Color(0xFFBB86FC),
              foregroundColor: const Color(0xFF121212),
              elevation: 8,
              child: const Icon(Icons.keyboard_arrow_up, size: 28),
            )
          : null,
      body: Container(
        // --- FIX #1: REMOVE PINK/PURPLE TINT FROM GRADIENT ---
        // Replaced the previous colors with a cleaner, more neutral gradient.
        decoration: const BoxDecoration(
          color: Color(0xFF121212),
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: EdgeInsets.only(
                    top: isDesktop
                        ? 40
                        : 20, // Adjust padding for desktop/mobile
                    right: isDesktop ? 60 : 12,
                    left: 12,
                  ),
                  height: 50,
                  child: FadeTransition(
                    opacity: _navbarFadeAnimation,
                    child: ListView(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: [
                        NavLink(
                            title: 'Projects',
                            page: widget.page,
                            onSectionClick: _scrollToSection),
                        NavLink(
                            title: 'Experiences',
                            page: widget.page,
                            onSectionClick: _scrollToSection),
                        NavLink(
                            title: 'Education',
                            page: widget.page,
                            onSectionClick: _scrollToSection),
                        NavLink(
                            title: 'Contact',
                            page: widget.page,
                            onSectionClick: _scrollToSection),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 120 : 20,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: isDesktop ? double.infinity : 900),
                  child: Flex(
                    direction: isDesktop ? Axis.horizontal : Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // --- Left Section: Text and Buttons ---
                      Flexible(
                        flex: isDesktop ? 2 : 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: isDesktop
                              ? CrossAxisAlignment.start
                              : CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SlideTransition(
                              position: _nameSlideAnimation,
                              child: Text(
                                'Htet Wai Lwin',
                                style: TextStyle(
                                  fontSize: isDesktop ? 66 : 48,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFBB86FC),
                                ),
                                textAlign: isDesktop
                                    ? TextAlign.start
                                    : TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SlideTransition(
                              position: _titleSlideAnimation,
                              child: Text(
                                'Mobile Application Developer(Flutter)',
                                style: TextStyle(
                                    fontSize: isDesktop ? 32 : 22,
                                    color: Colors.white),
                                textAlign: isDesktop
                                    ? TextAlign.start
                                    : TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SlideTransition(
                              position: _descriptionSlideAnimation,
                              child: Text(
                                'Building cross-platform apps with Flutter & Dart.',
                                style: TextStyle(
                                    fontSize: isDesktop ? 24 : 16,
                                    color: Colors.grey[400]),
                                textAlign: isDesktop
                                    ? TextAlign.start
                                    : TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 32),
                            Text(
                              "I'm a passionate Mobile developer with a focus on creating beautiful and functional cross-platform applications. I have over 3 years of experience in mobile app development, specializing in Flutter and Dart.",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      height: 1.6, color: Colors.grey[300]),
                              textAlign: isDesktop
                                  ? TextAlign.start
                                  : TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () {
                                _downloadResume();
                              },
                              icon: const Icon(Icons.download),
                              label: const Text('Download Resume'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFBB86FC),
                                foregroundColor: const Color(0xFF121212),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                elevation: 2,
                              ),
                            ),
                            const SizedBox(height: 32),
                            Text('My Skills',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                            const SizedBox(height: 16),
                            buildSkillsWrap(isDesktop),
                          ],
                        ),
                      ),

                      if (isDesktop) const SizedBox(width: 80),
                      if (!isDesktop) const SizedBox(height: 40),

                      // --- Right Section: Profile Picture ---
                      Flexible(
                        flex: isDesktop ? 2 : 0,
                        child: ScaleTransition(
                          scale: _imageScaleAnimation,
                          child: Container(
                            width: isDesktop
                                ? 380
                                : 200, // Slightly larger on desktop
                            height: isDesktop ? 380 : 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF1E1E1E),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 40,
                                    offset: const Offset(0, 15))
                              ],
                              border: Border.all(
                                  color:
                                      const Color(0xFFBB86FC).withOpacity(0.3),
                                  width: 6),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/me_profile.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.person, size: 100),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 100),
              // Home section
              Container(
                key: _experiencesKey,
                child: _buildHeader(),
              ),
              const SizedBox(height: 48),
              _buildTimeline(),
              const SizedBox(height: 100),
              Container(
                key: _educationKey,
                child: _buildSectionHeader('Education'),
              ),
              const SizedBox(height: 24),
              _buildEducationTimeline(),
              const SizedBox(height: 48),
              _buildSectionHeader('Certifications'),
              const SizedBox(height: 24),
              _buildCertificationsGrid(),
              const SizedBox(height: 100),
              // Projects section
              Container(
                key: _projectsKey,
                child: _buildProjectHeader(),
              ),
              const SizedBox(height: 48),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildProjectsGrid(),
              ),
              const SizedBox(height: 100),
              // Contact section
              Container(
                key: _contactKey,
                child: _buildContactHeader(context),
              ),
              const SizedBox(height: 32),
              _buildFormCard(context),
              const SizedBox(height: 48),
              _buildContactFooter(context),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets (No changes needed below this line) ---
  Widget buildSkillsWrap(bool isLargeScreen) {
    final List<String> skills = [
      'Flutter',
      'Dart',
      'Firebase',
      'REST API',
      'Provider',
      'Riverpod',
      'Bloc',
      'GetX',
      'Git',
      'Laravel',
      'SQL'
    ];
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      alignment: isLargeScreen ? WrapAlignment.start : WrapAlignment.center,
      children: skills.map((skill) => buildSkillChip(skill)).toList(),
    );
  }

  Widget buildSkillChip(String skill) {
    return Chip(
      label: Text(skill,
          style: TextStyle(
              color: const Color(0xFFBB86FC), fontWeight: FontWeight.w500)),
      backgroundColor: const Color(0xFF1E1E1E),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: const Color(0xFFBB86FC).withOpacity(0.3)),
      ),
    );
  }

  Widget buildQuickStatsSection(bool isLargeScreen) {
    final List<Map<String, String>> stats = [
      {'value': '3+', 'label': 'Years Experience'},
      {'value': '8+', 'label': 'Projects Completed'},
    ];

    if (!isLargeScreen) {
      return Column(
        children: stats
            .map((stat) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: buildStatCard(stat)))
            .toList(),
      );
    } else {
      return Row(
        children: stats
            .map((stat) => Expanded(
                child: buildStatCard(stat,
                    margin: const EdgeInsets.only(right: 16.0))))
            .toList(),
      );
    }
  }

  Widget buildStatCard(Map<String, String> stat, {EdgeInsetsGeometry? margin}) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 4))
          ],
          border: Border.all(color: Colors.grey.shade700)),
      child: Column(
        children: [
          Text(stat['value']!,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold, color: const Color(0xFFBB86FC))),
          const SizedBox(height: 8),
          Text(stat['label']!,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.grey[400]),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily:
                  'YourFontFamily', // Make sure to add a font if you have one
            ),
            children: [
              const TextSpan(text: 'My Professional '),
              TextSpan(
                text: 'Experience',
                style: TextStyle(color: const Color(0xFFBB86FC)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'A timeline of my journey as a Flutter Developer, contributing to innovative mobile applications.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey[400]),
        ),
      ],
    );
  }

  Widget _buildTimeline() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use a single-column layout on narrow screens
        bool isNarrow = constraints.maxWidth < 760;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: (isNarrow) ? 14 : 100),
          child: Column(
            children: List.generate(_experiences.length, (index) {
              final experience = _experiences[index];
              final isFirst = index == 0;
              final isLast = index == _experiences.length - 1;
              // On wide screens, alternate alignment. On narrow, all are right-aligned.
              final isLeftAligned = !isNarrow && index % 2 == 1;

              return TimelineTile(
                experience: experience,
                isFirst: isFirst,
                isLast: isLast,
                isLeftAligned: isLeftAligned,
                isNarrow: isNarrow,
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Color(0xFFBB86FC),
      ),
    );
  }

  Widget _buildEducationTimeline() {
    Future<void> _launchUrl(String url) async {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      )) {
        throw "Cannot launch url";
      }
    }

    return Column(
      children: List.generate(_educationItems.length, (index) {
        // Alternate between left and right alignment for zigzag effect
        final isLeftAligned = index % 2 == 1;

        return EducationTile(
          onTapLinkDegree: () async {
            if (_educationItems[index].linkDegree != '') {
              await _launchUrl(_educationItems[index].linkDegree);
            }
          },
          item: _educationItems[index],
          isFirst: index == 0,
          isLast: index == _educationItems.length - 1,
          isLeftAligned: isLeftAligned,
          onTapLinkUni: () async {
            await _launchUrl(_educationItems[index].linkUni);
          },
        );
      }),
    );
  }

  Widget _buildCertificationsGrid() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: _certificationItems
          .map(
            (item) => CertificationCard(item: item),
          )
          .toList(),
    );
  }

  Widget _buildProjectHeader() {
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

  Widget _buildContactHeader(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Get in Touch',
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: Color(0xFFBB86FC),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "I'm always open to discussing new projects, creative ideas, or opportunities.\nFeel free to reach out, and I'll get back to you as soon as possible.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[400],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isDesktop = screenSize.width > 960;
    return Container(
      width: isDesktop ? (screenSize.width) / 2 : null,
      margin: isDesktop
          ? const EdgeInsets.symmetric(horizontal: 0)
          : const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Use LayoutBuilder for responsive Name/Email fields
            LayoutBuilder(
              builder: (context, constraints) {
                // Use a breakpoint to switch between Row and Column
                if (constraints.maxWidth > 550) {
                  return Row(
                    children: [
                      Expanded(
                          child: _buildTextFormField('Your Name',
                              controller: _nameController)),
                      const SizedBox(width: 16),
                      Expanded(
                          child: _buildTextFormField('Your Email',
                              controller: _emailController)),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildTextFormField('Your Name',
                          controller: _nameController),
                      const SizedBox(height: 16),
                      _buildTextFormField('Your Email',
                          controller: _emailController),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            _buildTextFormField('Your Message',
                maxLines: 5, controller: _messageController),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _sendEmail, // Call the new function here
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBB86FC),
                foregroundColor: const Color(0xFF121212),
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 4,
                shadowColor: Colors.indigo.withOpacity(0.4),
              ),
              child: const Text(
                'Send Message',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Update the TextFormField to accept a controller
  Widget _buildTextFormField(String label,
      {int maxLines = 1, required TextEditingController controller}) {
    return TextFormField(
      controller: controller, // Assign the controller
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(color: Colors.grey[500]),
        filled: true,
        fillColor: const Color(0xFF2D2D2D),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey[600]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: const Color(0xFFBB86FC), width: 2),
        ),
      ),
      style: TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        if (label == 'Your Email' && !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _buildContactFooter(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isDesktop = screenSize.width > 960;

    Future<void> _launchUrl(String url) async {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      )) {
        throw "Cannot launch url";
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : 16),
      child: Column(
        children: [
          SizedBox(
            height: 30,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialIcon(FontAwesomeIcons.linkedin, () async {
                  await _launchUrl('https://www.linkedin.com/in/htetwailwin/');
                }, 'LinkedIn'),
                const SizedBox(width: 24),
                _buildSocialIcon(FontAwesomeIcons.github, () async {
                  await _launchUrl('https://github.com/htetwai18');
                }, 'Github'),
                const SizedBox(width: 24),
                _buildSocialIcon(
                    FontAwesomeIcons
                        .reddit, // Phone is available in default Material Icons
                    () async {
                  await _launchUrl(
                      'https://www.reddit.com/user/OkFudge8505/'); // opens phone dialer
                }, 'Reddit'),
                const SizedBox(width: 24),
                _buildSocialIcon(
                    FontAwesomeIcons
                        .medium, // Phone is available in default Material Icons
                    () async {
                  await _launchUrl(
                      'https://medium.com/@htetwai.18.lwin'); // opens phone dialer
                }, 'Medium'),
                const SizedBox(width: 24),
                _buildSocialIcon(
                    FontAwesomeIcons
                        .youtube, // Phone is available in default Material Icons
                    () async {
                  await _launchUrl(
                      'https://www.youtube.com/@HtetWaiLwin-q1g'); // opens phone dialer
                }, 'Youtube'),
                const SizedBox(width: 24),
                _buildSocialIcon(
                    FontAwesomeIcons
                        .stackOverflow, // Phone is available in default Material Icons
                    () async {
                  await _launchUrl(
                      'https://stackoverflow.com/users/27296718/htet-wai-lwin'); // opens phone dialer
                }, 'Stack overflow'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '© 2025 Htet Wai Lwin. Created with Flutter 3.35.4',
            style: TextStyle(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Function onTap, String tip) {
    return IconButton(
      icon: Icon(icon, color: Colors.grey[400]),
      onPressed: () {
        onTap();
      },
      splashRadius: 24,
      tooltip: tip,
    );
  }
}
