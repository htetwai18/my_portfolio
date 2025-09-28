import 'package:flutter/material.dart';
import 'package:hwl_portforlio/main.dart';
import 'package:hwl_portforlio/pages/education.dart';
import 'dart:html' as html;
import 'package:hwl_portforlio/pages/experience.dart';
import 'package:url_launcher/url_launcher.dart';

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
      description:
          'Skills: Project Management · Software Development · Enterprise Software · Software Documentation',
      linkUni: 'https://www.gre.ac.uk/',
      linkDegree: '',
    ),
    EducationItem(
      degree: 'Level-5 Higher Diploma, Computing',
      university: 'NCC Education',
      duration: 'Dec 2023 - Oct 2024',
      description:
          'Skills: Requirements Analysis · Risk Management · Risk Assessment',
      linkUni: 'https://www.nccedu.com/',
      linkDegree:
          'https://drive.google.com/file/d/17Arr6LxB79z-KRWQOodM7-jT2C9dT1Md/view?usp=sharing',
    ),
    EducationItem(
      degree: 'Level-4 Higher Diploma, Computing',
      university: 'NCC Education',
      duration: 'Jan 2023 - Dec 2023',
      description:
          'Focus on computer science fundamentals and software practices.',
      linkUni: 'https://www.nccedu.com/',
      linkDegree:
          'https://drive.google.com/file/d/1JpU3znVEIstXyJopNBdGqJ8ysAgDo4jA/view?usp=sharing',
    ),
    EducationItem(
      degree: 'Final Part II - MBBS',
      university: 'University of Medicine 2, Yangon',
      duration: 'Dec 2014 - Jan 2020',
      description: 'Completed foundational studies in medicine and surgery.',
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
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

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
    super.dispose();
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
      body: Container(
        // --- FIX #1: REMOVE PINK/PURPLE TINT FROM GRADIENT ---
        // Replaced the previous colors with a cleaner, more neutral gradient.
        decoration: const BoxDecoration(
          color: Color(0xFF121212),
        ),
        child: SingleChildScrollView(
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
                  ),
                  height: 50,
                  child: FadeTransition(
                    opacity: _navbarFadeAnimation,
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
                                  fontSize: isDesktop ? 64 : 48,
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
                                    fontSize: isDesktop ? 28 : 22,
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
                                    fontSize: isDesktop ? 20 : 16,
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
                                ? 350
                                : 200, // Slightly larger on desktop
                            height: isDesktop ? 350 : 200,
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
              _buildHeader(),
              const SizedBox(height: 48),
              _buildTimeline(),
              const SizedBox(height: 100),
              _buildSectionHeader('Education'),
              const SizedBox(height: 24),
              _buildEducationTimeline(),
              const SizedBox(height: 48),
              _buildSectionHeader('Certifications'),
              const SizedBox(height: 24),
              _buildCertificationsGrid(),
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
          padding: EdgeInsets.symmetric(horizontal: (isNarrow) ? 14 : 60),
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
        return EducationTile(
          onTapLinkDegree: () async {
            if (_educationItems[index].linkDegree != '') {
              await _launchUrl(_educationItems[index].linkDegree);
            }
          },
          item: _educationItems[index],
          isFirst: index == 0,
          isLast: index == _educationItems.length - 1,
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
}
