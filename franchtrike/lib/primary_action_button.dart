import 'package:flutter/material.dart';

class PrimaryActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;
  final bool selected;

  const PrimaryActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.filled = true,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color mainColor = const Color(0xFF1D2761);
    final Color accentColor = const Color(0xFF5B2C6F);
    final Color textColor = filled ? Colors.white : mainColor;
    final Color bgColor = filled
        ? (selected ? accentColor : mainColor)
        : Colors.white;
    final Color borderColor = filled ? Colors.transparent : mainColor;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(12),
      elevation: filled ? 4 : 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: textColor, size: 22),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 