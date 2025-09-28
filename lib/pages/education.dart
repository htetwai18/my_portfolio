import 'package:flutter/material.dart';
import 'package:hwl_portforlio/pages/contact.dart';
import 'package:hwl_portforlio/pages/experience.dart';
import 'package:hwl_portforlio/pages/hero_section.dart';
import 'package:hwl_portforlio/pages/project.dart';
import 'package:url_launcher/url_launcher.dart';

// --- Data Models ---
class EducationItem {
  final String degree;
  final String university;
  final String duration;
  final String description;
  final String linkUni;
  final String linkDegree;

  const EducationItem({
    required this.degree,
    required this.university,
    required this.duration,
    required this.description,
    required this.linkUni,
    required this.linkDegree,
  });
}

class CertificationItem {
  final IconData icon;
  final String name;
  final String link;

  const CertificationItem({
    required this.icon,
    required this.name,
    required this.link,
  });
}

// --- Main Page Widget ---
class EducationPage extends StatefulWidget {
  final String page;
  const EducationPage({
    super.key,
    required this.page,
  });

  @override
  State<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _navbarFadeAnimation;
  // --- Data ---
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
                          constraints: const BoxConstraints(maxWidth: 800),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Color(0xFF6B4EEA),
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
        return _EducationTile(
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
            (item) => _CertificationCard(item: item),
          )
          .toList(),
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
          if (title == 'Home') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HeroSection(
                          page: 'Home',
                        )));
          }

          if (title == 'Projects') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const ProjectsPage(page: 'Projects')));
          }

          if (title == 'Contact') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ContactPage(
                          page: 'Contact',
                        )));
          }

          if (title == 'Experiences') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const ExperiencePage(page: 'Experiences')));
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

// --- Custom Tile for Education Timeline ---
class _EducationTile extends StatelessWidget {
  final EducationItem item;
  final bool isFirst;
  final bool isLast;
  final Function onTapLinkUni, onTapLinkDegree;

  const _EducationTile({
    Key? key,
    required this.item,
    required this.isFirst,
    required this.isLast,
    required this.onTapLinkUni,
    required this.onTapLinkDegree,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TimelineNode(isFirst: isFirst, isLast: isLast),
          const SizedBox(width: 24),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      onTapLinkDegree();
                    },
                    child: Text(
                      item.degree,
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: () {
                      onTapLinkUni();
                    },
                    child: Row(
                      children: [
                        Text(
                          item.university,
                          style: const TextStyle(
                            color: Color(0xFF6B4EEA),
                          ),
                        ),
                        const Icon(
                          Icons.open_in_new,
                          color: Color(0xFF6B4EEA),
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(item.duration,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  const SizedBox(height: 8),
                  Text(item.description,
                      style: TextStyle(color: Colors.grey[800])),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Timeline Graphic (Dot and Lines) ---
class _TimelineNode extends StatelessWidget {
  final bool isFirst;
  final bool isLast;

  const _TimelineNode({Key? key, required this.isFirst, required this.isLast})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timelineColor = Colors.deepPurple[400];
    return SizedBox(
      width: 20,
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: 2,
              color: isFirst ? Colors.transparent : timelineColor,
            ),
          ),
          Container(
            width: 10,
            height: 10,
            decoration:
                BoxDecoration(color: timelineColor, shape: BoxShape.circle),
          ),
          Expanded(
            child: Container(
              width: 2,
              color: isLast ? Colors.transparent : timelineColor,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Custom Card for Certification ---
class _CertificationCard extends StatelessWidget {
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw "Cannot launch url";
    }
  }

  final CertificationItem item;

  const _CertificationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () async {
          await _launchUrl(item.link);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.deepPurple[100]?.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                item.icon,
                color: Colors.deepPurple[600],
                size: 20,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              item.name,
              style: const TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333A65),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
