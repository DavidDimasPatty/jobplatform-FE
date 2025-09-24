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
    return Container(
      decoration: BoxDecoration(color: Colors.blue),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            widget.dataChat.nama.toString(),
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
