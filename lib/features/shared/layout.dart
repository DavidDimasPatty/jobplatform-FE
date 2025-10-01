import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_platform/features/shared/Notification/Notification.dart';
import 'package:job_platform/features/shared/Notification/NotificationItem.dart';
import 'package:job_platform/features/shared/TopAppLayout.dart';
import 'package:job_platform/features/shared/bottomAppLayout.dart';

class Layout extends StatefulWidget {
  final Widget child;
  const Layout({super.key, required this.child});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int selectedIndex = 0;
  bool _showNotification = false;
  List<Notificationitem>? dataNotif;

  toggleNotification() {
    setState(() {
      _showNotification = !_showNotification;
    });
  }

  final List<String> _routes = [
    '/home',
    '/candidate',
    '/profile',
    '/setting',
    '/chat',
    '/cart',
  ];

  void _onTabSelected(int index) {
    if (selectedIndex != index) {
      setState(() => selectedIndex = index);
      context.go(_routes[index]);
    }
  }

  @override
  void initState() {
    super.initState();
    dataNotif = [
      Notificationitem(
        icon: Icons.warning,
        iconColor: Colors.yellowAccent,
        title: "HRD has seen your profile!🤗",
        subtitle: "Let's we hope for the best!😇",
        bgColor: Colors.yellow.shade200,
      ),
      Notificationitem(
        icon: Icons.dangerous,
        iconColor: Colors.redAccent,
        title: "You have been rejected from PT. Indomarco Prismatama!🥺🥺",
        subtitle:
            "We are really sorry to inform you, that you have been rejected at Interview Proses in PT. Indomarco Prismatama",
        bgColor: Colors.red.shade200,
      ),
      Notificationitem(
        icon: Icons.dangerous,
        iconColor: Colors.redAccent,
        title: "You have been rejected from PT. Inti Dunia Sukses!🥺🥺",
        subtitle:
            "We are really sorry to inform you, that you have been rejected at Interview Proses in PT. Inti Dunia Sukses",
        bgColor: Colors.red.shade200,
      ),
      Notificationitem(
        icon: Icons.tag_faces_rounded,
        iconColor: Colors.greenAccent,
        title: "You are selected! 🥳🥳",
        subtitle: "Let's continue to next progress!💪✊",
        bgColor: Colors.green.shade200,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            appBar: TopApplayout(
              onToggleNotification: toggleNotification,
              currentIndex: selectedIndex,
              onTabSelected: _onTabSelected,
            ),
            body: widget.child,
            bottomNavigationBar: BottomApplayout(
              currentIndex: selectedIndex,
              onTabSelected: _onTabSelected,
            ),
          ),

          if (_showNotification)
            Notificationbody(
              toggleNotification: toggleNotification,
              data: dataNotif!,
            ),
        ],
      ),
    );
  }
}
