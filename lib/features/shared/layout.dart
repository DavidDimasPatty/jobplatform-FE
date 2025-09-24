import 'package:flutter/material.dart';
import 'package:job_platform/features/components/cart/persentation/pages/cart.dart';
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
  // late List<Widget> _pages;

  final _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

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
    setState(() {
      if (_selectedIndex == index) {
        // If user taps the same tab again, pop to first route in that tab
        _navigatorKeys[index].currentState!.popUntil((r) => r.isFirst);
      } else {
        setState(() => _selectedIndex = index);
      }
    });
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
    // _pages = [
    //   const HomePage(),
    //   const Cart(),
    //   Profile(onTabSelected: _onTabSelected),
    //   Personalinfo(),
    //   ExperienceAdd(),
    //   ExperienceEdit(),
    //   EducationalAdd(),
    //   EducationalEdit(),
    //   OrganizationAdd(),
    //   OrganizationEdit(),
    //   CertificateAdd(),
    //   CertificateEdit(),
    // ];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        final currentNavigator = _navigatorKeys[_selectedIndex].currentState!;
        if (didPop) return; // system already handled back

        if (currentNavigator.canPop()) {
          currentNavigator.pop();
        } else {
          // allow system/app to close
          Navigator.of(context).maybePop();
        }
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            appBar: TopApplayout(
              onToggleNotification: toggleNotification,
              onToggleMessages: toggleMessages,
            ),
            body: IndexedStack(
              index: _selectedIndex,
              children: [
                Navigator(
                  key: _navigatorKeys[0],
                  onGenerateRoute: (settings) =>
                      MaterialPageRoute(builder: (_) => const HomePage()),
                ),
                Navigator(
                  key: _navigatorKeys[1],
                  onGenerateRoute: (settings) =>
                      MaterialPageRoute(builder: (_) => const Cart()),
                ),
                Navigator(
                  key: _navigatorKeys[2],
                  onGenerateRoute: (settings) => MaterialPageRoute(
                    builder: (_) => const ProfileNav(),
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
            Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 0,
              right: 0,
              child: Material(
                elevation: 6,
                child: Container(
                  color: Colors.amber.shade100,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.info, color: Colors.orange),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text("Ada notifikasi baru untukmu!"),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: toggleNotification,
                      ),
                    ],
                  ),
                ),
              ),
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
