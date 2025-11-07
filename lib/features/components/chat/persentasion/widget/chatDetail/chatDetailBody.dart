import 'package:flutter/material.dart';
import 'package:job_platform/features/components/chat/domain/entities/ChatDetailItems.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chatDetail/chatDetailBubble.dart';

class Chatdetailbody extends StatefulWidget {
  final List<Chatdetailitems> dataChat;
  Chatdetailbody({super.key, required this.dataChat});
  @override
  State<Chatdetailbody> createState() => _Chatdetailbody();
}

class _Chatdetailbody extends State<Chatdetailbody> {
  // Loading state
  bool isLoading = true;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    //var mediaQueryHeight = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              // reverse: true,
              padding: const EdgeInsets.all(10),
              itemCount: widget.dataChat.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (BuildContext context, int index) {
                return Chatdetailbubble(data: widget.dataChat[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
