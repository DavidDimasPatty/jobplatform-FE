import 'package:flutter/material.dart';

class BottomApplayout extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const BottomApplayout({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => onTabSelected(0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home,
                      color: currentIndex == 0
                          ? Colors.lightBlueAccent
                          : Colors.white,
                    ),
                    Text(
                      "Home",
                      style: TextStyle(
                        color: currentIndex == 0
                            ? Colors.lightBlueAccent
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () => onTabSelected(1),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag,
                      color: currentIndex == 1
                          ? Colors.lightBlueAccent
                          : Colors.white,
                    ),
                    Text(
                      "Candidate",
                      style: TextStyle(
                        color: currentIndex == 1
                            ? Colors.lightBlueAccent
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () => onTabSelected(2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_circle,
                      color: currentIndex == 2
                          ? Colors.lightBlueAccent
                          : Colors.white,
                    ),
                    Text(
                      "Profile",
                      style: TextStyle(
                        color: currentIndex == 2
                            ? Colors.lightBlueAccent
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
