import 'package:flutter/material.dart';
import 'package:job_platform/features/components/chat/domain/entities/ChatDetailItems.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chatDetail/chatDetailBubble.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chatDetail/chatDetailTop.dart';

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
    return Container(
      child: Column(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemCount: widget.dataChat.length,
              itemBuilder: (BuildContext context, int index) {
                return Chatdetailbubble(data: widget.dataChat[index]);
              },
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: ScrollPhysics(),
            ),
          ),
        ],
      ),
    );
  }
}
