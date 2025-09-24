import 'package:flutter/material.dart';
import 'package:job_platform/features/components/chat/domain/entities/ChatDetailItems.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chatDetail/chatDetailBubble.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chatDetail/chatDetailTop.dart';

class Chatdetailbottom extends StatefulWidget {
  Chatdetailbottom({super.key});
  @override
  State<Chatdetailbottom> createState() => _Chatdetailbody();
}

class _Chatdetailbody extends State<Chatdetailbottom> {
  List<Chatdetailitems> dataChat = [];
  final TextEditingController _controller = TextEditingController();
  void _handleSend() {
    // if (_controller.text.trim().isNotEmpty) {
    //   widget.onSend(_controller.text.trim());
    //   _controller.clear();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: const Offset(0, -1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon emoji
          IconButton(
            icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
            onPressed: () {},
          ),

          // Text input
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 5, // bisa auto-expand kayak WA
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Type a message",
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Icon attach
          IconButton(
            icon: const Icon(Icons.attach_file, color: Colors.grey),
            onPressed: () {},
          ),

          // Icon kamera
          IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.grey),
            onPressed: () {},
          ),

          // Tombol kirim / mic
          GestureDetector(
            onTap: _handleSend,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
