import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chat/chatItems.dart';

class Chatbody extends StatefulWidget {
  final List<Chatitems> items;
  final VoidCallback onSearchChanged;
  final TextEditingController searchController;

  const Chatbody({
    super.key,
    required this.items,
    required this.onSearchChanged,
    required this.searchController,
  });

  @override
  State<Chatbody> createState() => _Chatbody();
}

class _Chatbody extends State<Chatbody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      margin: EdgeInsets.all(20),
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
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 20, top: 20),
            child: Text(
              "Chats".tr(),
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            // height: 90,
            margin: EdgeInsets.all(20),
            child: TextFormField(
              onChanged: (value) => widget.onSearchChanged(),
              controller: widget.searchController,
              decoration: InputDecoration(
                labelText: 'Cari Chat'.tr(),
                hintText: 'Masukan Chat'.tr(),
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
              validator: (value) =>
                  value == null || value.isEmpty ? 'Wajib diisi'.tr() : null,
            ),
          ),
          ListView.separated(
            separatorBuilder: (context, index) {
              return Divider();
            },
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
