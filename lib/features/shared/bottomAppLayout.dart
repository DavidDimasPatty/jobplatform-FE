import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomApplayout extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final String loginAs;

  BottomApplayout({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    required this.loginAs,
  });

  @override
  Widget build(BuildContext context) {
    final currentState = GoRouterState.of(context);
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
                      color: currentState.uri.toString().contains("home")
                          ? Colors.lightBlueAccent
                          : Colors.white,
                    ),
                    Text(
                      "Home",
                      style: TextStyle(
                        color: currentState.uri.toString().contains("home")
                            ? Colors.lightBlueAccent
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (loginAs.isNotEmpty && loginAs == "userHRD" ?? false)
              Expanded(
                child: InkWell(
                  onTap: () => onTabSelected(1),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_bag,
                        color: currentState.uri.toString() == "/candidate"
                            ? Colors.lightBlueAccent
                            : Colors.white,
                      ),
                      Text(
                        "Candidate",
                        style: TextStyle(
                          color: currentState.uri.toString() == "/candidate"
                              ? Colors.lightBlueAccent
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            if (loginAs.isNotEmpty && loginAs == "user" ?? false)
              Expanded(
                child: InkWell(
                  onTap: () => onTabSelected(6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.group_work,
                        color: currentState.uri.toString() == "/statusJob"
                            ? Colors.lightBlueAccent
                            : Colors.white,
                      ),
                      Text(
                        "Status",
                        style: TextStyle(
                          color: currentState.uri.toString() == "/statusJob"
                              ? Colors.lightBlueAccent
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            if (loginAs.isNotEmpty && loginAs == "userHRD" ?? false)
              Expanded(
                child: InkWell(
                  onTap: () => onTabSelected(7),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.work_history,
                        color: currentState.uri.toString() == "/progress"
                            ? Colors.lightBlueAccent
                            : Colors.white,
                      ),
                      Text(
                        "Progress",
                        style: TextStyle(
                          color: currentState.uri.toString() == "/progress"
                              ? Colors.lightBlueAccent
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            if (loginAs.isNotEmpty && loginAs == "company" ?? false)
              Expanded(
                child: InkWell(
                  onTap: () => onTabSelected(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home_work,
                        color: currentState.uri.toString() == "/vacancy"
                            ? Colors.lightBlueAccent
                            : Colors.white,
                      ),
                      Text(
                        "Vacancy",
                        style: TextStyle(
                          color: currentState.uri.toString() == "/vacancy"
                              ? Colors.lightBlueAccent
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            if (loginAs.isNotEmpty && loginAs == "company" ?? false)
              Expanded(
                child: InkWell(
                  onTap: () => onTabSelected(9),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people,
                        color: currentState.uri.toString() == "/manageHRD"
                            ? Colors.lightBlueAccent
                            : Colors.white,
                      ),
                      Text(
                        "Manage HRD",
                        style: TextStyle(
                          color: currentState.uri.toString() == "/manageHRD"
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
                onTap: () {
                  if (loginAs == "user")
                    onTabSelected(2);
                  else if (loginAs == "company")
                    onTabSelected(10);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_circle,
                      color: currentState.uri.toString().contains("profile")
                          ? Colors.lightBlueAccent
                          : Colors.white,
                    ),
                    Text(
                      "Profile",
                      style: TextStyle(
                        color: currentState.uri.toString().contains("profile")
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
