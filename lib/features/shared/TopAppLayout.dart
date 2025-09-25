import 'package:flutter/material.dart';
import 'package:job_platform/features/components/setting/persentation/pages/setting.dart';

class TopApplayout extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onToggleNotification;
  final VoidCallback onToggleMessages;
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const TopApplayout({
    super.key,
    required this.onToggleNotification,
    required this.onToggleMessages,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blueAccent,
      title: const Text(
        "Skillen",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
      ),
      actions: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: onToggleNotification,
              icon: const Icon(Icons.notifications, color: Colors.white),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: () => onTabSelected(4),
              icon: const Icon(Icons.chat, color: Colors.white),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: () => onTabSelected(3),
              icon: const Icon(Icons.settings, color: Colors.white),
            ),
            const SizedBox(width: 25),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
