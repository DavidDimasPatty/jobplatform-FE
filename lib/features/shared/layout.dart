import 'package:flutter/material.dart';
import 'package:job_platform/features/components/candidate/persentation/pages/candidateNav.dart';
import 'package:job_platform/features/components/cart/persentation/pages/cart.dart';
import 'package:job_platform/features/components/cart/persentation/pages/cartNav.dart';
import 'package:job_platform/features/components/chat/persentasion/pages/chatNav.dart';
import 'package:job_platform/features/components/home/persentation/pages/homeNav.dart';
import 'package:job_platform/features/components/home/persentation/pages/home_page.dart';
import 'package:job_platform/features/components/profile/persentation/pages/personalInfo.dart';
import 'package:job_platform/features/components/profile/persentation/pages/profile.dart';
import 'package:job_platform/features/components/profile/persentation/pages/profile/certificateAdd.dart';
import 'package:job_platform/features/components/profile/persentation/pages/profile/certificateEdit.dart';
import 'package:job_platform/features/components/profile/persentation/pages/profile/educationalAdd.dart';
import 'package:job_platform/features/components/profile/persentation/pages/profile/educationalEdit.dart';
import 'package:job_platform/features/components/profile/persentation/pages/profile/experienceAdd.dart';
import 'package:job_platform/features/components/profile/persentation/pages/profile/experienceEdit.dart';
import 'package:job_platform/features/components/profile/persentation/pages/profile/organizationAdd.dart';
import 'package:job_platform/features/components/profile/persentation/pages/profile/organizationEdit.dart';
import 'package:job_platform/features/components/profile/persentation/pages/profileNav.dart';
import 'package:job_platform/features/components/setting/persentation/settingNav.dart';
import 'package:job_platform/features/shared/Notification/Notification.dart';
import 'package:job_platform/features/shared/Notification/NotificationItem.dart';
import 'package:job_platform/features/shared/TopAppLayout.dart';
import 'package:job_platform/features/shared/bottomAppLayout.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  bool _showNotification = false;
  bool _showMessages = false;
  int _selectedIndex = 0;
  List<Notificationitem>? dataNotif;
  List<GlobalKey<NavigatorState>>? _navigatorKeys;

  toggleNotification() {
    print(_showNotification);
    setState(() {
      _showNotification = !_showNotification;
      if (_showMessages == true) {
        _showMessages = !_showMessages;
      }
    });
  }

  _onTabSelected(int index) {
    if (_selectedIndex == index) {
      // If user taps the same tab again, pop to first route in that tab
      final navigator = _navigatorKeys![index].currentState;
      if (navigator != null) {
        navigator.pushNamedAndRemoveUntil('/', (route) => false);
      }
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  toggleMessages() {
    setState(() {
      _showMessages = !_showMessages;
      if (_showNotification == true) {
        _showNotification = !_showNotification;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _navigatorKeys = [
      GlobalKey<NavigatorState>(),
      GlobalKey<NavigatorState>(),
      GlobalKey<NavigatorState>(),
      GlobalKey<NavigatorState>(),
      GlobalKey<NavigatorState>(),
      GlobalKey<NavigatorState>(),
      GlobalKey<NavigatorState>(),
    ];
    dataNotif = [
      Notificationitem(
        icon: Icons.warning,
        iconColor: Colors.yellowAccent,
        title: "HRD has seen your profile!🤗",
        subtitle: "Let's we hope for the best!😇",
        navigatorKeys: _navigatorKeys!,
        bgColor: Colors.yellow.shade200,
      ),
      Notificationitem(
        icon: Icons.dangerous,
        iconColor: Colors.redAccent,
        title: "You have been rejected from PT. Indomarco Prismatama!🥺🥺",
        subtitle:
            "We are really sorry to inform you, that you have been rejected at Interview Proses in PT. Indomarco Prismatama",
        navigatorKeys: _navigatorKeys!,
        bgColor: Colors.red.shade200,
      ),
      Notificationitem(
        icon: Icons.dangerous,
        iconColor: Colors.redAccent,
        title: "You have been rejected from PT. Inti Dunia Sukses!🥺🥺",
        subtitle:
            "We are really sorry to inform you, that you have been rejected at Interview Proses in PT. Inti Dunia Sukses",
        navigatorKeys: _navigatorKeys!,
        bgColor: Colors.red.shade200,
      ),
      Notificationitem(
        icon: Icons.tag_faces_rounded,
        iconColor: Colors.greenAccent,
        title: "You are selected! 🥳🥳",
        subtitle: "Let's continue to next progress!💪✊",
        navigatorKeys: _navigatorKeys!,
        bgColor: Colors.green.shade200,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        final currentNavigator = _navigatorKeys![_selectedIndex].currentState!;
        if (didPop) return; // system already handled back

        if (currentNavigator.canPop()) {
          currentNavigator.pop();
        } else {
          // allow system/app to close
          // Navigator.of(context).maybePop();

          // Switch to Home Page
          if (_selectedIndex != 0) {
            setState(() {
              _selectedIndex = 0;
            });
          }
        }
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            appBar: TopApplayout(
              onToggleNotification: toggleNotification,
              onToggleMessages: toggleMessages,
              currentIndex: _selectedIndex,
              onTabSelected: _onTabSelected,
            ),
            body: IndexedStack(
              index: _selectedIndex,
              children: [
                Navigator(
                  onGenerateRoute: (settings) => MaterialPageRoute(
                    builder: (_) => Homenav(navigatorKey: _navigatorKeys![0]),
                  ),
                ),
                Navigator(
                  onGenerateRoute: (settings) => MaterialPageRoute(
                    builder: (_) =>
                        Candidatenav(navigatorKey: _navigatorKeys![1]),
                  ),
                ),
                Navigator(
                  key: _navigatorKeys![2],
                  onGenerateRoute: (settings) =>
                      MaterialPageRoute(builder: (_) => const ProfileNav()),
                ),
                Navigator(
                  key: _navigatorKeys![3],
                  onGenerateRoute: (settings) =>
                      MaterialPageRoute(builder: (_) => const Settingnav()),
                ),
                Navigator(
                  onGenerateRoute: (settings) => MaterialPageRoute(
                    builder: (_) => Chatnav(navigatorKey: _navigatorKeys![4]),
                  ),
                ),
                Navigator(
                  onGenerateRoute: (settings) => MaterialPageRoute(
                    builder: (_) => Cartnav(navigatorKey: _navigatorKeys![5]),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: BottomApplayout(
              currentIndex: _selectedIndex,
              onTabSelected: _onTabSelected,
            ),
          ),

          if (_showNotification)
            Notificationbody(
              toggleNotification: toggleNotification,
              navigatorKeys: _navigatorKeys!,
              data: dataNotif!,
            ),

          /// Overlay messages
          if (_showMessages)
            Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 0,
              right: 0,
              child: Material(
                elevation: 6,
                child: Container(
                  color: Colors.blueGrey,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      const Expanded(child: Text("Belum ada Notifikasi!")),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: toggleMessages,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
