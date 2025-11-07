import 'package:flutter/material.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chat/chatItems.dart';

class Chatbody extends StatefulWidget {
  final List<Chatitems> items;
  Chatbody({super.key, required this.items});

  @override
  State<Chatbody> createState() => _Chatbody(this.items);
}

class _Chatbody extends State<Chatbody> {
  final List<Chatitems> items;
  _Chatbody(this.items);

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
          Container(
            margin: EdgeInsets.only(left: 20, top: 20),
            child: Text(
              "Chats",
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            // height: 90,
            margin: EdgeInsets.all(20),
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari Chat',
                hintText: 'Masukan Chat',
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
                  value == null || value.isEmpty ? 'Wajib diisi' : null,
            ),
          ),
          ListView.separated(
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return items[index];
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
