import 'package:flutter/material.dart';
import 'package:job_platform/features/components/home/persentation/widgets/company/vacancyTableItem.dart';

class Vacancytable extends StatefulWidget {
  // final CandidateItems item;
  List<Vacancytableitem>? items;
  Vacancytable({super.key, this.items});
  @override
  State<Vacancytable> createState() => _Vacancytable();
}

class _Vacancytable extends State<Vacancytable> {
  // final CandidateItems item;
  // _Listjobreceive(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 200),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
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
                "Lowongan Terbuka",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
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
