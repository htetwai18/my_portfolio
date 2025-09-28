import 'dart:async'; // Import async library for Timer
import 'package:flutter/material.dart';

// --- Converted to a StatefulWidget ---
class ProjectDetailPage extends StatefulWidget {
  const ProjectDetailPage({super.key});

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  // --- State variables for auto-scrolling ---
  late final FixedExtentScrollController _scrollController;
  Timer? _timer;
  int _currentItemIndex = 0;

  // Replace these with your actual screenshot assets
  final List<String> screenshotImages = [
    'assets/screenshot1.png',
    'assets/screenshot2.png',
    'assets/screenshot3.png',
    'assets/screenshot4.png',
    'assets/screenshot5.png',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController();
    // Start auto-scrolling after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    // Ensure there are images to scroll and timer isn't already active
    if (screenshotImages.length > 1 && _timer == null) {
      _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        _currentItemIndex++;
        _scrollController.animateToItem(
          _currentItemIndex,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void _stopAutoScroll() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    // --- Clean up resources ---
    _stopAutoScroll();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isDesktop = screenSize.width > 800; // Arbitrary breakpoint
    return WillPopScope(
      onWillPop: ()async{
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: (isDesktop) ? 60 : 24.0,
                vertical: (isDesktop) ? 40.0 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 24,
                    )),
                // --- Header Section ---
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Project: TaskMaster',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B4EEA),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'A productivity app for managing daily tasks and goals.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.center,
                  child: const Text(
                    'Role: Lead Developer',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // --- Animated Curved HORIZONTAL Image Carousel ---
                SizedBox(
                  height: 300,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      // Stop auto-scroll on user interaction
                      if (notification is ScrollStartNotification) {
                        _stopAutoScroll();
                      }
                      // Resume auto-scroll when user stops scrolling
                      else if (notification is ScrollEndNotification) {
                        _startAutoScroll();
                      }
                      return true;
                    },
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: ListWheelScrollView.useDelegate(
                        controller: _scrollController, // Attach controller
                        itemExtent: 250,
                        offAxisFraction: 0.4,
                        diameterRatio: 2.0,
                        perspective: 0.004,
                        physics: const FixedExtentScrollPhysics(),
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            if (screenshotImages.isEmpty) {
                              return const RotatedBox(
                                quarterTurns: 1,
                                child: _ImagePlaceholder(),
                              );
                            }
                            return RotatedBox(
                              quarterTurns: 1,
                              child: _ScreenshotItem(
                                imagePath: screenshotImages[
                                    index % screenshotImages.length],
                              ),
                            );
                          },
                          childCount: screenshotImages.isNotEmpty ? null : 1,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // --- Action Buttons ---
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.visibility),
                    label: const Text('View Live App'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B4EEA),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // --- Technical Sections ---
                _buildSectionTitle('Technical Deep Dive'),
                _buildTechnicalGrid(),
                const SizedBox(height: 20),
                _buildSectionTitle('Problem Solved & Key Features'),
                _buildFeatureList(),
                const SizedBox(height: 20),
                _buildSectionTitle('Technical Challenges & Solutions'),
                // _buildChallengeExpansion(),
                _buildFeatureList(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1a2533),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _buildTechnicalGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 600;
        return isWide
            ? GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 6,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: _getTechInfoCards(),
              )
            : Column(
                children: _getTechInfoCards()
                    .map((card) => Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: card,
                        ))
                    .toList(),
              );
      },
    );
  }

  List<Widget> _getTechInfoCards() {
    return const [
      TechInfoCard(title: 'Language/Framework', value: 'SwiftUI'),
      TechInfoCard(title: 'Architecture Pattern', value: 'MVVM'),
      TechInfoCard(title: 'State Management', value: 'Combine'),
      TechInfoCard(title: 'Database/Backend', value: 'Firebase'),
    ];
  }

  Widget _buildFeatureList() {
    return const Column(
      children: [
        FeatureListItem(text: 'Intuitive task creation and management'),
        FeatureListItem(text: 'Seamless synchronization across devices'),
        FeatureListItem(
            text: 'Personalized goal setting and progress tracking'),
        FeatureListItem(text: 'Gamified rewards system for task completion'),
      ],
    );
  }

  Widget _buildChallengeExpansion() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: const ExpansionTile(
        title: Text(
          'Challenge Faced: Real-time Data Synchronization',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1a2533),
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Solution: Leveraged Firebase Firestore\'s real-time listeners to subscribe to data changes. Implemented Combine publishers to efficiently propagate updates throughout the app\'s UI, ensuring a reactive and consistent state across all connected devices with minimal latency.',
              style: TextStyle(color: Colors.black87, height: 1.5),
            ),
          )
        ],
      ),
    );
  }
}

class _ScreenshotItem extends StatelessWidget {
  final String imagePath;
  const _ScreenshotItem({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const _ImagePlaceholder();
          },
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      width: 140,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: const Center(
        child: Text(
          'Add image to\nassets/ folder',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}

class TechInfoCard extends StatelessWidget {
  final String title;
  final String value;

  const TechInfoCard({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF1a2533),
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureListItem extends StatelessWidget {
  final String text;

  const FeatureListItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: Color(0xFF007BFF),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
