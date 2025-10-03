import 'dart:async'; // Import async library for Timer
import 'package:flutter/material.dart';
import 'package:device_frame_plus/device_frame_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hwl_portforlio/pages/project.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';

// --- Converted to a StatefulWidget ---
class ProjectDetailPage extends StatefulWidget {
  final Project project;
  const ProjectDetailPage({
    super.key,
    required this.project,
  });

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  // --- State variables for auto-scrolling ---
  late final FixedExtentScrollController _scrollController;
  Timer? _timer;
  int _currentItemIndex = 0;

  bool _areImagesPrecached = false;

  // Use project's images instead of hardcoded screenshots
  List<String> get screenshotImages => widget.project.images;

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
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Call our new async function to handle loading
      _precacheImagesAndStartScroll();
    });
  }

  // --- NEW: Async function to handle pre-caching ---
  Future<void> _precacheImagesAndStartScroll() async {
    if (screenshotImages.isEmpty || !mounted) return;

    // Create a list of futures for all the precaching operations
    final List<Future<void>> precacheFutures = screenshotImages
        .map((imagePath) => precacheImage(AssetImage(imagePath), context))
        .toList();

    // Wait for all images to be loaded into the cache
    await Future.wait(precacheFutures);
    await Future.delayed(const Duration(microseconds: 1500));

    // Once loading is complete, update the state and start the scroll
    if (mounted) {
      setState(() {
        _areImagesPrecached = true;
      });
      _startAutoScroll();
    }
  }

  // void _precacheImages() {
  //   for (final imagePath in screenshotImages) {
  //     precacheImage(AssetImage(imagePath), context);
  //   }
  // }

  void _startAutoScroll() {
    if (screenshotImages.length > 1 && _timer == null) {
      // Add a short delay before starting the auto-scroll
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          // Check if the widget is still in the tree
          _timer = Timer.periodic(const Duration(microseconds: 2000), (timer) {
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
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: (isDesktop) ? 60 : 24.0,
              vertical: (isDesktop) ? 40.0 : 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
                    )),
                // --- Header Section ---
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.project.title,
                    style: GoogleFonts.oxanium(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFBB86FC),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.project.description,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[400],
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Role: ${widget.project.role}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widget.project.status == "Internal use application")
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          FontAwesomeIcons.lock,
                          color: Colors.brown,
                          size: 20,
                        ),
                      ),
                    if (widget.project.status == "Archive Project")
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          FontAwesomeIcons.box,
                          color: Colors.brown,
                          size: 20,
                        ),
                      ),
                    Text(
                      "${widget.project.status}",
                      style: GoogleFonts.oxanium(
                        color: Colors.white,
                        fontSize: 18,
                        textStyle: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
                // const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widget.project.androidLink != "")
                      InkWell(
                        onTap: () async {
                          await _launchUrl(widget.project.androidLink);
                        },
                        child: const _HoverTechIcon(
                            iconData: FontAwesomeIcons.googlePlay),
                      ),
                    if (widget.project.iosLink != "")
                      InkWell(
                        onTap: () async {
                          await _launchUrl(widget.project.iosLink);
                        },
                        child: const _HoverTechIcon(
                            iconData: FontAwesomeIcons.appStoreIos),
                      ),
                    if (widget.project.webLink != "")
                      InkWell(
                        onTap: () async {
                          await _launchUrl(widget.project.webLink);
                        },
                        child: const _HoverTechIcon(
                            iconData: FontAwesomeIcons.desktop),
                      ),
                  ],
                ),
                const SizedBox(height: 60),
                // --- Animated Curved HORIZONTAL Image Carousel ---
                SizedBox(
                  height: 300,
                  // --- NEW: Conditional builder ---
                  child: _areImagesPrecached
                      ? NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            if (notification is ScrollStartNotification) {
                              _stopAutoScroll();
                            } else if (notification is ScrollEndNotification) {
                              _startAutoScroll();
                            }
                            return true;
                          },
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: ListWheelScrollView.useDelegate(
                              controller: _scrollController,
                              itemExtent: 250,
                              offAxisFraction: 0.4,
                              diameterRatio: 2.0,
                              perspective: 0.004,
                              physics: const NeverScrollableScrollPhysics(),
                              childDelegate: ListWheelChildBuilderDelegate(
                                builder: (context, index) {
                                  // No need for an empty check here anymore, but it's safe to keep
                                  if (screenshotImages.isEmpty) {
                                    return const RotatedBox(
                                      quarterTurns: 1,
                                      child: _ImagePlaceholder(),
                                    );
                                  }
                                  return RotatedBox(
                                    quarterTurns: 1,
                                    child: _ScreenshotItem(
                                      platform: widget.project.platform,
                                      imagePath: screenshotImages[
                                          index % screenshotImages.length],
                                    ),
                                  );
                                },
                                childCount:
                                    screenshotImages.isNotEmpty ? null : 1,
                              ),
                            ),
                          ),
                        )
                      : Center(
                          // Show a loading indicator while pre-caching
                          child: LoadingAnimationWidget.twistingDots(
                            leftDotColor: const Color(0xFF1A1A3F),
                            rightDotColor: const Color(0xFFEA3799),
                            size: 50,
                          ),
                        ),
                ),

                // --- Action Buttons ---

                SizedBox(height: (isDesktop) ? 120 : 60),

                // --- Technical Sections ---
                Center(child: _buildSectionTitle('Technical Deep Dive')),
                Align(
                  alignment: Alignment.center,
                  child: _buildTechnicalGrid(),
                ),
                const SizedBox(height: 60),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 40 : 16,
                      vertical: isDesktop ? 40 : 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey[700]!),
                  ),
                  width: MediaQuery.sizeOf(context).width,
                  child: (MediaQuery.sizeOf(context).width > 800)
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle(
                                    'Problem Solved & Key Features'),
                                _buildFeatureList(),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle(
                                    'Technical Challenges & Solutions'),
                                _buildChallengesList(),
                              ],
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle('Problem Solved & Key Features'),
                            _buildFeatureList(),
                            const SizedBox(height: 30),
                            _buildSectionTitle(
                                'Technical Challenges & Solutions'),
                            _buildChallengesList(),
                          ],
                        ),
                ),

                const SizedBox(height: 20),
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
          style: GoogleFonts.oxanium(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFBB86FC),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  // Removed random-color tech icon helper in favor of a hover-reactive widget below

  Widget _buildTechnicalGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final Size screenSize = MediaQuery.of(context).size;
        final bool isDesktop = screenSize.width > 800;
        return isDesktop
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
    return widget.project.techStacks
        .map((techMap) => TechInfoCard(
            title: techMap.keys.first, value: techMap.values.first))
        .toList();
  }

  Widget _buildFeatureList() {
    return Column(
      children: widget.project.psAndKf
          .map((feature) => FeatureListItem(text: feature))
          .toList(),
    );
  }

  Widget _buildChallengesList() {
    return Column(
      children: widget.project.challenges
          .map((challenge) => FeatureListItem(text: challenge))
          .toList(),
    );
  }
}

class _ScreenshotItem extends StatelessWidget {
  final String platform;
  final String imagePath;
  const _ScreenshotItem({
    required this.imagePath,
    required this.platform,
  });

  @override
  Widget build(BuildContext context) {
    return DeviceFrame(
      device: (platform == 'mobile')
          ? Devices.ios.iPhone13
          : Devices.macOS.macBookPro, // You can choose other iPhone models
      isFrameVisible: (platform == 'mobile'),
      screen: ClipRRect(
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
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: const Center(
        child: Text(
          'Error loading image',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
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
    final Size screenSize = MediaQuery.of(context).size;
    final bool isDesktop = screenSize.width > 800;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment:
            (!isDesktop) ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.oxanium(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.oxanium(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.white,
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
    final Size screenSize = MediaQuery.of(context).size;
    final bool isDesktop = screenSize.width > 800;
    return Container(
      width: (isDesktop) ? screenSize.width / 3.2 : screenSize.width,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Color(0xFFBB86FC),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

// Hover-reactive tech icon (matches project.dart behavior but localized)
class _HoverTechIcon extends StatefulWidget {
  final IconData iconData;
  const _HoverTechIcon({required this.iconData});

  @override
  State<_HoverTechIcon> createState() => _HoverTechIconState();
}

class _HoverTechIconState extends State<_HoverTechIcon> {
  bool _isHovered = false;
  bool isPlayStore() {
    if (widget.iconData == FontAwesomeIcons.googlePlay) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Color baseColor = (isPlayStore()) ? Colors.green : Colors.blue;
    final Color fg = !_isHovered
        ? baseColor
        : (isPlayStore())
            ? Colors.greenAccent
            : Colors.blueAccent;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: baseColor.withOpacity(0.35),
                    blurRadius: 16,
                    spreadRadius: 1,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Center(child: Icon(widget.iconData, color: fg, size: 30)),
      ),
    );
  }
}
