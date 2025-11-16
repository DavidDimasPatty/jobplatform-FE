import 'package:flutter/material.dart';
import 'package:job_platform/features/components/chat/domain/entities/ChatDetailItems.dart';

class Chatdetailtop extends StatefulWidget {
  final Chatdetailitems dataChat;
  Chatdetailtop({super.key, required this.dataChat});

  @override
  State<Chatdetailtop> createState() => _Chatdetailtop();
}

class _Chatdetailtop extends State<Chatdetailtop> {
  @override
  Widget build(BuildContext context) {
    var mediaQueryHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      height: mediaQueryHeight / 10,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Container(
        margin: EdgeInsets.only(left: 20),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 24, // ✅ lebih kecil & proporsional
              backgroundImage: const AssetImage("assets/images/BG_HRD.png"),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.dataChat.nama ?? "Unknown",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    "Online",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            IconButton(
              icon: const Icon(Icons.call, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
