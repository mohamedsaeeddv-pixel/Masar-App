import 'package:flutter/material.dart';
class InfoTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const InfoTile({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title),
      subtitle: Text(value),
    );
  }
}
