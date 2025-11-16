import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:job_platform/features/components/manageHRD/persentation/widgets/manageHRD/manageHRDItems.dart';

class Managehrdbody extends StatefulWidget {
  final List<Managehrditems> items;
  final VoidCallback popup;
  final VoidCallback onSearchChanged;
  TextEditingController searchController;
  Managehrdbody({
    super.key,
    required this.items,
    required this.popup,
    required this.onSearchChanged,
    required this.searchController,
  });

  @override
  State<Managehrdbody> createState() => _Managehrdbody();
}

class _Managehrdbody extends State<Managehrdbody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
              "Manage HRD".tr(),
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            // height: 90,
            margin: EdgeInsets.all(20),
            child: Row(
              spacing: 20,
              children: [
                Expanded(
                  child: TextFormField(
                    onChanged: (value) {
                      widget.onSearchChanged();
                    },
                    controller: widget.searchController,
                    decoration: InputDecoration(
                      labelText: 'Cari HRD'.tr(),
                      hintText: 'Masukan Nama HRD'.tr(),
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
                    validator: (value) => value == null || value.isEmpty
                        ? 'Wajib diisi'.tr()
                        : null,
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: widget.popup,
                  label: Text("Add".tr()),
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          ),
          ListView.builder(
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
