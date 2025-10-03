import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// --- Data Models ---
class EducationItem {
  final String degree;
  final String university;
  final String duration;
  final String linkUni;
  final String linkDegree;

  const EducationItem({
    required this.degree,
    required this.university,
    required this.duration,
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

// --- Custom Tile for Education Timeline ---
class EducationTile extends StatelessWidget {
  final EducationItem item;
  final bool isFirst;
  final bool isLast;
  final bool isLeftAligned;
  final Function onTapLinkUni, onTapLinkDegree;

  const EducationTile({
    super.key,
    required this.item,
    required this.isFirst,
    required this.isLast,
    required this.isLeftAligned,
    required this.onTapLinkUni,
    required this.onTapLinkDegree,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isDesktop = screenSize.width > 800;

    // For mobile, always use left alignment
    if (!isDesktop) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TimelineNode(isFirst: isFirst, isLast: isLast),
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
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
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
                              color: Color(0xFFBB86FC),
                            ),
                          ),
                          const Icon(
                            Icons.open_in_new,
                            color: Color(0xFFBB86FC),
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(item.duration,
                        style:
                            TextStyle(color: Colors.grey[400], fontSize: 13)),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    // For desktop, use zigzag layout
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left side content
          if (isLeftAligned) ...[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40.0, right: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
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
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    const SizedBox(height: 4),
                    InkWell(
                      onTap: () {
                        onTapLinkUni();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            item.university,
                            style: const TextStyle(
                              color: Color(0xFFBB86FC),
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
                    const SizedBox(height: 4),
                    Text(item.duration,
                        style: TextStyle(color: Colors.grey[400], fontSize: 13),
                        textAlign: TextAlign.right),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 24),
          ] else ...[
            // Empty space when content is on right
            Expanded(child: Container()),
            const SizedBox(width: 24),
          ],

          // Center timeline - always in the middle
          TimelineNode(isFirst: isFirst, isLast: isLast),

          // Right side content
          if (!isLeftAligned) ...[
            const SizedBox(width: 24),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40.0, left: 24.0),
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
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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
                              color: Color(0xFFBB86FC),
                            ),
                          ),
                          const Icon(
                            Icons.open_in_new,
                            color: Color(0xFFBB86FC),
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(item.duration,
                        style:
                            TextStyle(color: Colors.grey[400], fontSize: 13)),
                  ],
                ),
              ),
            ),
          ] else ...[
            // Empty space when content is on left
            const SizedBox(width: 24),
            Expanded(child: Container()),
          ],
        ],
      ),
    );
  }
}

// --- Timeline Graphic (Dot and Lines) ---
class TimelineNode extends StatelessWidget {
  final bool isFirst;
  final bool isLast;

  const TimelineNode({super.key, required this.isFirst, required this.isLast});

  @override
  Widget build(BuildContext context) {
    const timelineColor = Color(0xFFBB86FC);
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
            decoration: const BoxDecoration(
                color: timelineColor, shape: BoxShape.circle),
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
class CertificationCard extends StatelessWidget {
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

  const CertificationCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade700),
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
                color: const Color(0xFFBB86FC).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                item.icon,
                color: const Color(0xFFBB86FC),
                size: 20,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              item.name,
              style: const TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
