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
  // Loading state
  bool isLoading = true;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
