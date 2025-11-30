import 'package:flutter/material.dart';

class StrategyCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final bool isEnabled;
  final ValueChanged<bool?> onChanged;

  const StrategyCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    this.isEnabled = true,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 1,
      child: CheckboxListTile(
        value: isSelected,
        onChanged: isEnabled ? onChanged : null,
        secondary: Icon(icon, size: 32),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isEnabled ? null : Colors.grey,
          ),
        ),
        subtitle: Text(description),
      ),
    );
  }
}
