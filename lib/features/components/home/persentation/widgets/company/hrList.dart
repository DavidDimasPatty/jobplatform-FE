import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:job_platform/features/components/home/persentation/widgets/company/hrListitem.dart';

class hrList extends StatefulWidget {
  List<hrListitem>? items;
  hrList({super.key, this.items});
  @override
  State<hrList> createState() => _hrList();
}

class _hrList extends State<hrList> {
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
                "HRD Terdaftar".tr(),
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
                      "Data Tidak Ditemukan..".tr(),
                      style: TextStyle(fontSize: 20),
                    ),
                  )),
          ),
        ],
      ),
    );
  }
}
