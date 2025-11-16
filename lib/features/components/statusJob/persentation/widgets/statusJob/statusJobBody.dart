import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:job_platform/features/components/statusJob/persentation/widgets/statusJob/statusJobItems.dart';

class Statusjobbody extends StatefulWidget {
  final List<statusjobitems> items;
  final VoidCallback onSearchChanged;
  final TextEditingController searchController;
  Statusjobbody({
    super.key,
    required this.items,
    required this.onSearchChanged,
    required this.searchController,
  });

  @override
  State<Statusjobbody> createState() => _Statusjobbody();
}

class _Statusjobbody extends State<Statusjobbody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(3, 3),
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 20, top: 20),
            child: Text(
              "Status Pekerjaan".tr(),
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            // height: 90,
            margin: EdgeInsets.all(20),
            child: TextFormField(
              controller: widget.searchController,
              decoration: InputDecoration(
                labelText: 'Cari Pekerjaan'.tr(),
                hintText: 'Masukan Nama Pekerjaan'.tr(),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: Colors.white60),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 11,
                ),
              ),
              // initialValue: email,
              onChanged: (value) {
                widget.onSearchChanged();
              },
            ),
          ),
          ListView.builder(
            // separatorBuilder: (context, index) {
            //   return Divider();
            // },
            itemCount: widget.items.length,
            itemBuilder: (BuildContext context, int index) {
              return widget.items[index];
            },
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: ScrollPhysics(),
          ),
        ],
      ),
    );
  }
}
