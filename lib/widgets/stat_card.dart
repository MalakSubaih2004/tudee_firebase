import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String count;
  final String label;
  final Color backgroundColor;

  const StatCard({
    super.key,
    required this.count,
    required this.label,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
