import 'package:flutter/material.dart';
import 'package:job_platform/features/components/chat/domain/entities/ChatDetailItems.dart';

class Candidateheader extends StatefulWidget {
  // final Chatdetailitems dataChat;
  Candidateheader({super.key});

  @override
  State<Candidateheader> createState() => _Candidateheader();
}

class _Candidateheader extends State<Candidateheader> {
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
            Container(
              margin: EdgeInsets.only(left: 20, top: 20),
              child: Text(
                "Find Candidate",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
