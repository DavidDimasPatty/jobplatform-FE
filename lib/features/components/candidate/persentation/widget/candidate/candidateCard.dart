import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_platform/features/components/candidate/domain/entities/candidate.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chat/chatItems.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Candidatecard extends StatefulWidget {
  final CandidateItems item;
  GlobalKey<NavigatorState> navigatorKeys;
  Candidatecard({super.key, required this.item, required this.navigatorKeys});

  @override
  State<Candidatecard> createState() => _Candidatecard(this.item);
}

class _Candidatecard extends State<Candidatecard> {
  final CandidateItems item;
  _Candidatecard(this.item);

  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueAccent.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(widget.item.photoUrl ?? ""),
          ),
          const SizedBox(height: 8),
          Text(
            widget.item.nama ?? "",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            widget.item.umur ?? "0",
            style: const TextStyle(fontSize: 12, color: Colors.black54),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4),
          Text(
            widget.item.domisili ?? "Unknown",
            style: const TextStyle(fontSize: 12, color: Colors.black54),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4),
          Text(
            widget.item.score ?? "0",
            style: const TextStyle(fontSize: 12, color: Colors.black54),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
