import 'package:flutter/material.dart';

class TopApplayout extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onToggleNotification;
  final String loginAs;
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final int notificationCount;

  const TopApplayout({
    super.key,
    required this.onToggleNotification,
    required this.loginAs,
    required this.currentIndex,
    required this.onTabSelected,
    required this.notificationCount,
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
            Stack(
              children: [
                IconButton(
                  onPressed: onToggleNotification,
                  icon: const Icon(Icons.notifications, color: Colors.white),
                ),
                if (notificationCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        notificationCount > 99 ? '99+' : '$notificationCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            if (loginAs.isNotEmpty && loginAs == "userHRD")
              IconButton(
                onPressed: () => onTabSelected(5),
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
              ),
            if (loginAs.isNotEmpty && loginAs != "company")
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
