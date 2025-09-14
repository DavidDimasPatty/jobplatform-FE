import 'package:flutter/material.dart';
import 'package:job_platform/features/components/cart/persentation/pages/cart.dart';
import 'package:job_platform/features/components/home/persentation/pages/home_page.dart';
import 'package:job_platform/features/components/login/persentation/pages/login.dart';
import 'package:job_platform/features/components/profile/persentation/pages/profile.dart';
import 'package:job_platform/features/components/setting/persentation/pages/setting.dart';
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
  final List<Widget> _pages = [const HomePage(), const Cart(), const Profile()];

  void toggleNotification() {
    print(_showNotification);
    setState(() {
      _showNotification = !_showNotification;
      if (_showMessages == true) {
        _showMessages = !_showMessages;
      }
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void toggleMessages() {
    setState(() {
      _showMessages = !_showMessages;
      if (_showNotification == true) {
        _showNotification = !_showNotification;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopApplayout(
        onToggleNotification: toggleNotification,
        onToggleMessages: toggleMessages,
      ),
      body: Stack(
        children: [
          //IndexedStack(index: _selectedIndex, children: _pages),
          _pages[_selectedIndex],
          if (_showNotification)
            Positioned(
              top: 0,
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
              top: 0,
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

      bottomNavigationBar: BottomApplayout(
        currentIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
