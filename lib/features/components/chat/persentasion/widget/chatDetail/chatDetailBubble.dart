import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_platform/features/components/chat/domain/entities/ChatDetailItems.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chat/chatBody.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chat/chatItems.dart';
import 'package:job_platform/features/components/login/persentation/widgets/loginForm.dart';
import 'package:job_platform/features/components/setting/persentation/widgets/bodySetting.dart';
import 'package:job_platform/features/components/setting/persentation/widgets/settingGroup.dart'
    show SettingsGroup;
import 'package:job_platform/features/components/setting/persentation/widgets/settingItem.dart';
import 'package:job_platform/features/components/setting/persentation/widgets/topSetting.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Chatdetailbubble extends StatefulWidget {
  final Chatdetailitems data;
  const Chatdetailbubble({super.key, required this.data});

  @override
  State<Chatdetailbubble> createState() => _Chatdetailbubble();
}

class _Chatdetailbubble extends State<Chatdetailbubble> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.data.nama == "David"
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7, // batas lebar 70%
        ),
        decoration: BoxDecoration(
          color: widget.data.nama == "David"
              ? Colors.blue[300]
              : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: widget.data.nama == "David"
                ? const Radius.circular(16)
                : const Radius.circular(0),
            bottomRight: widget.data.nama == "David"
                ? const Radius.circular(0)
                : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(widget.data.message!, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 4),
            Text(
              DateFormat('HH:mm').format(widget.data.addDate!),
              style: TextStyle(fontSize: 11, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}
