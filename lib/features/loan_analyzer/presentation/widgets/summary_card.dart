import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final List<SummaryItem> items;

  const SummaryCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.map((item) => _buildItem(item)).toList(),
        ),
      ),
    );
  }

  Widget _buildItem(SummaryItem item) {
    return Column(
      children: [
        Text(
          item.label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          item.value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class SummaryItem {
  final String label;
  final String value;

  const SummaryItem({required this.label, required this.value});
}
