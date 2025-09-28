import 'package:flutter/material.dart';
import 'package:hwl_portforlio/pages/contact.dart';
import 'package:hwl_portforlio/pages/education.dart';
import 'package:hwl_portforlio/pages/hero_section.dart';
import 'package:hwl_portforlio/pages/project.dart';
import 'package:url_launcher/url_launcher.dart';

// --- Data Model ---
class Experience {
  final String title;
  final String company;
  final String duration;
  final String link;
  final List<String> responsibilities;

  const Experience({
    required this.title,
    required this.company,
    required this.duration,
    required this.link,
    required this.responsibilities,
  });
}

// --- Main Page Widget ---
class ExperiencePage extends StatefulWidget {
  final String page;
  const ExperiencePage({
    super.key,
    required this.page,
  });

  @override
  State<ExperiencePage> createState() => _ExperiencePageState();
}

class _ExperiencePageState extends State<ExperiencePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _navbarFadeAnimation;

  // --- Experience Data ---
  final List<Experience> _experiences = const [
    Experience(
      title: 'Flutter & Laravel Developer',
      company: 'Whatif Solutions Sdn Bhd',
      duration: 'May 2025 - Sep 2025',
      responsibilities: [
        'Digicraft Smart Home App: Performed maintenance, code refactoring, and on-spot bug fixes for legacy Flutter codebase.',
        'Tiger Online Casino Backoffice: Conducted requirement analysis with clients, designed backend architecture under senior guidance, developed modules for banking, transactions, settings, and logs.',
        'Infinity 688 Casino Backoffice: Conducted requirement analysis with clients, designed backend architecture under senior guidance, developed modules for banking, transactions, settings, and logs.',
      ],
      link: 'https://www.whatifsolutions.my/',
    ),
    Experience(
      title: 'Part-time Flutter Developer',
      company: 'My Day Thu Kywal',
      duration: 'Sep 2024 - Jan 2025',
      responsibilities: [
        'Weday App: Built features for comments, replies, nested replies, and reactions.',
        'Integrated live streaming service with Agora.',
        'Communicated directly with Agora engineers for documentation and technical flow.',
      ],
      link: 'https://myday.com.mm/',
    ),
    Experience(
      title: 'Flutter Developer',
      company: 'Kwin Technologies',
      duration: 'Sep 2022 - Apr 2025',
      responsibilities: [
        'ARFI Ecommerce App: Met with brand owners for requirements, implemented UI codes and API integration under senior guidance.',
        'Dr Rejvue Aesthetic Clinic Membership App: Worked with system analyst, implemented UI codes and API integration, setup offline data storage (Hive, SharedPreferences), and managed real-time status with socket.io.',
        'Kwin HR Management App: Conducted system analysis, created draft UI/UX, developed the entire app, designed backend architecture with backend developers, handled most mobile-side logic to prevent memory leaks and crashes.',
        'Yankin Bubble Tea POS App: Migrated from legacy Kotlin to Flutter, redesigned UI/UX, implemented offline data storage (Hive, SharedPreferences), and developed the app independently.',
        'Kwin Client Management App: Analyzed flow with management, created UI without designer, implemented subscription expiry handling and customer access control.',
        'Suzuki Smart Order App: Led mobile team, met with Suzuki management for system analysis, helped backend developers with admin panel, integrated APIs, set up socket services for notifications, and implemented Google Sign-In.',
      ],
      link: 'http://kwintechnologies.com/',
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
      // Light blue-purple background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFEFF1F8), // Light, neutral grey-blue
              Color(0xFFFDFDFE), // Fading to nearly white
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: isDesktop ? 40 : 20, // Adjust padding for desktop/mobile
              right: isDesktop ? 60 : 12,
              left: isDesktop? null: 12,
              child: FadeTransition(
                opacity: _navbarFadeAnimation,
                child: SizedBox(
                  height: 50,
                  child: ListView(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildNavLink(context, 'Home', widget.page),
                      _buildNavLink(context, 'Projects', widget.page),
                      _buildNavLink(context, 'Experiences', widget.page),
                      _buildNavLink(context, 'Education', widget.page),
                      _buildNavLink(context, 'Contact', widget.page),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 50),
                padding: EdgeInsets.only(
                  top: isDesktop ? 40 : 20,
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
                          constraints: const BoxConstraints(maxWidth: 1000),
                          child: Column(
                            children: [
                              _buildHeader(),
                              const SizedBox(height: 48),
                              _buildTimeline(),
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
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E2A5D),
              fontFamily:
                  'YourFontFamily', // Make sure to add a font if you have one
            ),
            children: [
              const TextSpan(text: 'My Professional '),
              TextSpan(
                text: 'Experience',
                style: TextStyle(color: Colors.deepPurple[400]),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'A timeline of my journey as a Flutter Developer, contributing to innovative mobile applications.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildTimeline() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use a single-column layout on narrow screens
        bool isNarrow = constraints.maxWidth < 760;

        return Column(
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
        );
      },
    );
  }

  Widget _buildNavLink(BuildContext context, String title, String page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextButton(
        style:  const ButtonStyle(
          overlayColor: WidgetStatePropertyAll(Colors.transparent),
          padding: WidgetStatePropertyAll(EdgeInsets.zero),
        ),
        onPressed: () {
          if (title == 'Education') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const EducationPage(page: 'Education')));
          }
          if (title == 'Home') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HeroSection(
                          page: 'Home',
                        )));
          }
          if (title == 'Contact') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ContactPage(page: 'Contact')));
          }
          if (title == 'Projects') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const ProjectsPage(page: 'Projects')));
          }
        },
        child: Text(
          title,
          style: TextStyle(
            color: (page == title) ? const Color(0xFF6B4EEA) : Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// --- Timeline Tile Widget ---
class TimelineTile extends StatelessWidget {
  final Experience experience;
  final bool isFirst;
  final bool isLast;
  final bool isLeftAligned;
  final bool isNarrow;

  const TimelineTile({
    super.key,
    required this.experience,
    required this.isFirst,
    required this.isLast,
    required this.isLeftAligned,
    required this.isNarrow,
  });

  @override
  Widget build(BuildContext context) {
    // On narrow screens, force right alignment content
    final content = Flexible(child: _ExperienceCard(experience: experience));
    final emptyContent = Flexible(child: Container());

    final Widget leftContent;
    final Widget rightContent;

    if (isLeftAligned) {
      leftContent = content;
      rightContent = emptyContent;
    } else {
      leftContent = emptyContent;
      rightContent = content;
    }

    // Build the row for wide screens
    if (!isNarrow) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            leftContent,
            _TimelineCenterNode(isFirst: isFirst, isLast: isLast),
            rightContent,
          ],
        ),
      );
    }
    // Build the row for narrow screens (timeline on the left)
    else {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TimelineCenterNode(isFirst: isFirst, isLast: isLast),
            Flexible(child: _ExperienceCard(experience: experience)),
          ],
        ),
      );
    }
  }
}

// --- Timeline Center Node (Dot and Line) ---
class _TimelineCenterNode extends StatelessWidget {
  final bool isFirst;
  final bool isLast;

  const _TimelineCenterNode(
      {Key? key, required this.isFirst, required this.isLast})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Container(
              width: 2,
              color: isFirst ? Colors.transparent : Colors.grey[300],
            ),
          ),
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.deepPurple[400],
              shape: BoxShape.circle,
            ),
          ),
          Flexible(
            child: Container(
              width: 2,
              color: isLast ? Colors.transparent : Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Experience Card Widget ---
class _ExperienceCard extends StatelessWidget {
  final Experience experience;

  const _ExperienceCard({Key? key, required this.experience}) : super(key: key);

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw "Cannot launch url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  experience.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                experience.duration,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 4),
          InkWell(
            onTap: () async {
              await _launchUrl(experience.link);
            },
            child: Row(
              children: [
                Text(
                  experience.company,
                  style: TextStyle(
                    color: Colors.deepPurple[400],
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.open_in_new,
                  color: Color(0xFF6B4EEA),
                  size: 14,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...experience.responsibilities.map((resp) => Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle,
                        color: Colors.deepPurple[400], size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(resp, style: const TextStyle(height: 1.4))),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
