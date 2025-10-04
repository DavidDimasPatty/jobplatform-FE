import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_platform/features/components/cart/persentation/widgets/cartItems.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chat/chatItems.dart';
import 'package:job_platform/features/components/progress/persentation/widgets/progress/progressItems.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Progressbody extends StatefulWidget {
  final List<Progressitems> items;
  Progressbody({super.key, required this.items});

  @override
  State<Progressbody> createState() => _Progressbody();
}

class _Progressbody extends State<Progressbody> {
  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      margin: EdgeInsets.all(10),
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
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20, top: 20),
              child: Text(
                "Progress Candidate",
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
                  labelText: 'Cari Progress Candidate',
                  hintText: 'Masukan Nama Candidate',
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
      ),
    );
  }
}
