import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  final String title;
  final String date;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  const ActivityCard({
    super.key,
    required this.title,
    required this.date,
    required this.description,
    required this.icon,
    required this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: _buildCard(context),
    );
  }

  // Main card UI
  Widget _buildCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          _buildIcon(),
          const SizedBox(width: 15),
          _buildTextColumn(),
          _buildDateText(),
        ],
      ),
    );
  }

  // Card decoration
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // Icon with circle background
  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  // Text column for title and description
  Widget _buildTextColumn() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleText(),
          const SizedBox(height: 5),
          _buildDescriptionText(),
        ],
      ),
    );
  }

  // Title text style
  Widget _buildTitleText() {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  // Description text style
  Widget _buildDescriptionText() {
    return Text(
      description,
      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
    );
  }

  // Date text style
  Widget _buildDateText() {
    return Text(
      date,
      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
    );
  }
}
