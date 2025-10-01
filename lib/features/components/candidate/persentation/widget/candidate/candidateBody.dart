import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_platform/features/components/candidate/domain/entities/candidate.dart';
import 'package:job_platform/features/components/candidate/persentation/widget/candidate/candidateCard.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chat/chatItems.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Candidatebody extends StatefulWidget {
  final List<CandidateItems> items;
  Candidatebody({super.key, required this.items});

  @override
  State<Candidatebody> createState() => _Candidatebody(this.items);
}

int getCrossAxisCount(BuildContext context) {
  double width = MediaQuery.of(context).size.width;

  if (width < 600) {
    return 2;
  } else if (width < 900) {
    return 3;
  } else {
    return 4;
  }
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
            shrinkWrap: true,
            physics: ScrollPhysics(),
            padding: EdgeInsets.all(10),
            itemCount: widget.items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: getCrossAxisCount(context),
              crossAxisSpacing: 4,
              mainAxisSpacing: 20,
              childAspectRatio: 1 / 2,
            ),
            itemBuilder: (BuildContext context, int index) {
              final candidate = widget.items[index];
              return Candidatecard(item: candidate);
            },
          ),
        ],
      ),
    );
  }
}
