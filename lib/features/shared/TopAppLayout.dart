import 'package:flutter/material.dart';
import 'package:job_platform/features/components/setting/persentation/pages/setting.dart';

class TopApplayout extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onToggleNotification;
  final String loginAs;
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const TopApplayout({
    super.key,
    required this.onToggleNotification,
    required this.loginAs,
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
            if (loginAs.isNotEmpty && loginAs == "userHRD" ?? false)
              IconButton(
                onPressed: () => onTabSelected(5),
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
              ),
            if (loginAs.isNotEmpty && loginAs != "company" ?? false)
              IconButton(
                onPressed: () => onTabSelected(4),
                icon: const Icon(Icons.chat, color: Colors.white),
              ),
            SizedBox(width: 10),
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
