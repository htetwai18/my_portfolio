import 'package:flutter/material.dart';
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
              color: isFirst ? Colors.transparent : Colors.grey[600],
            ),
          ),
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Color(0xFFBB86FC),
              shape: BoxShape.circle,
            ),
          ),
          Flexible(
            child: Container(
              width: 2,
              color: isLast ? Colors.transparent : Colors.grey[600],
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

  const _ExperienceCard({super.key, required this.experience});

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
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
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
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                experience.duration,
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
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
                    color: const Color(0xFFBB86FC),
                    fontWeight: FontWeight.w600,
                    // decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.open_in_new,
                  color: Color(0xFFBB86FC),
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
                    const Icon(Icons.check_circle,
                        color: Color(0xFFBB86FC), size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(resp,
                            style: TextStyle(
                                height: 1.4, color: Colors.grey[300]))),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
