import 'package:flutter/material.dart';

class ServiceDetailTile extends StatelessWidget {
  final String title;
  final String? iconUrl;
  final IconData? fallbackIcon;
  final VoidCallback? onTap;

  const ServiceDetailTile({
    super.key,
    required this.title,
    this.iconUrl,
    this.fallbackIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 72,
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              // Icon Container
              Container(
                width: 48,
                height: 48,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: iconUrl != null
                      ? Image.network(
                          iconUrl!,
                          width: 32,
                          height: 32,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(fallbackIcon ?? Icons.description, color: const Color(0xFF0065FF)),
                        )
                      : Icon(fallbackIcon ?? Icons.description, color: const Color(0xFF0065FF)),
                ),
              ),
              const SizedBox(width: 16),
              // Title
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF101828),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF94A3B8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
