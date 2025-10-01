import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_platform/features/components/candidate/domain/entities/candidate.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chat/chatItems.dart';
import 'package:job_platform/features/components/home/persentation/widgets/benchmarkItem.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Benchmarkapplicant extends StatefulWidget {
  // final CandidateItems item;
  List<Benchmarkitem>? items;
  Benchmarkapplicant({super.key, this.items});
  @override
  State<Benchmarkapplicant> createState() => _Benchmarkapplicant();
}

class _Benchmarkapplicant extends State<Benchmarkapplicant> {
  // final CandidateItems item;
  // _Listjobreceive(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            width: double.infinity,
            child: Center(
              child: Text(
                "Benchmark Profile Serupa",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: (widget.items != null
                ? ListView.separated(
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: widget.items!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return widget.items![index];
                    },
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: ScrollPhysics(),
                  )
                : Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.2,
                    alignment: Alignment.center,
                    child: Text(
                      "Data Tidak Ditemukan..",
                      style: TextStyle(fontSize: 20),
                    ),
                  )),
          ),
        ],
      ),
    );
  }
}
