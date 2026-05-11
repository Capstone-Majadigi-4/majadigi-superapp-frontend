import 'package:flutter/material.dart';

class ServiceModule {
  final String id;
  final String title;
  final String emoji;
  final Color bgColor;
  final String category;
  final String description;
  final List<String> features;
  final Widget destinationScreen;

  const ServiceModule({
    required this.id,
    required this.title,
    required this.emoji,
    required this.bgColor,
    required this.category,
    required this.description,
    required this.features,
    required this.destinationScreen,
  });
}
