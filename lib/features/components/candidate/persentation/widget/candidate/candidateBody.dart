import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_platform/features/components/candidate/domain/entities/candidate.dart';
import 'package:job_platform/features/components/candidate/persentation/widget/candidate/candidateCard.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chat/chatItems.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Candidatebody extends StatefulWidget {
  final List<CandidateItems> items;
  GlobalKey<NavigatorState> navigatorKeys;
  Candidatebody({super.key, required this.items, required this.navigatorKeys});

  @override
  State<Candidatebody> createState() => _Candidatebody(this.items);
}

class _Candidatebody extends State<Candidatebody> {
  final List<CandidateItems> items;
  _Candidatebody(this.items);

  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
            shrinkWrap: true, // biar bisa ditaruh di column
            physics: const ScrollPhysics(),
            padding: const EdgeInsets.all(10),
            itemCount: widget.items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // jumlah kolom (2 kotak per baris)
              crossAxisSpacing: 10, // jarak horizontal antar kotak
              mainAxisSpacing: 10, // jarak vertikal antar kotak
              childAspectRatio: 3 / 4, // rasio kotak (lebar : tinggi)
            ),
            itemBuilder: (BuildContext context, int index) {
              final candidate = widget.items[index];
              return Candidatecard(
                item: candidate,
                navigatorKeys: widget.navigatorKeys,
              );
            },
          ),
        ],
      ),
    );
  }
}
