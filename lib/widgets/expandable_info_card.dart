import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/utils/app_colors.dart';

class ExpandableInfoCard extends StatefulWidget {
  final String title;
  final String? content;
  final Widget? child;
  final bool isInitiallyExpanded;

  const ExpandableInfoCard({
    super.key,
    required this.title,
    this.content,
    this.child,
    this.isInitiallyExpanded = false,
  });

  @override
  State<ExpandableInfoCard> createState() => _ExpandableInfoCardState();
}

class _ExpandableInfoCardState extends State<ExpandableInfoCard> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isInitiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              color: Colors.transparent, // Ensures the whole area is clickable
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Color(0xFF101828),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.remove : Icons.add,
                    color: const Color(0xFF64748B),
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          
          // Content
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: widget.child ?? Text(
                widget.content ?? '',
                style: const TextStyle(
                  color: Color(0xFF364153),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.63,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
