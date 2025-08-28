import 'package:flutter/material.dart';
import 'package:job_platform/features/components/login/persentation/pages/login.dart';
import 'package:job_platform/features/shared/TopAppLayout.dart';
import 'package:job_platform/features/shared/bottomAppLayout.dart';

class Layout extends StatefulWidget {
  final Widget body;
  const Layout({super.key, required this.body});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  bool _showNotification = false;

  void toggleNotification() {
    print(_showNotification);
    setState(() {
      _showNotification = !_showNotification;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopApplayout(
        onToggleNotification: toggleNotification, // kasih callback
      ),
      body: Stack(
        children: [
          widget.body,
          if (_showNotification)
            Positioned(
              top: 0, // di atas body, langsung di bawah appbar
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
        ],
      ),
      bottomNavigationBar: BottomApplayout(),
    );
  }
}
