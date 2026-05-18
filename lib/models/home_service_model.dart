import 'package:flutter/material.dart';

class HomeServiceModel {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  HomeServiceModel({
    required this.title,
    required this.icon,
    required this.onTap,
    this.enabled = true,
  });
}