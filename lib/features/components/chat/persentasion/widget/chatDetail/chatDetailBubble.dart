import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:job_platform/features/components/chat/domain/entities/ChatDetailItems.dart';

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
