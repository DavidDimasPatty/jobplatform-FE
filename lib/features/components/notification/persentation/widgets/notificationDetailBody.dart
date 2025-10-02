import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_platform/features/components/cart/persentation/widgets/cartItems.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chat/chatItems.dart';
import 'package:job_platform/features/components/notification/persentation/widgets/notificationDetailItems.dart';
import 'package:responsive_framework/responsive_framework.dart';

class NotificationDetailbody extends StatefulWidget {
  final List<NotificationDetailitems> items;
  NotificationDetailbody({super.key, required this.items});

  @override
  State<NotificationDetailbody> createState() => _NotificationDetailbody();
}

class _NotificationDetailbody extends State<NotificationDetailbody> {
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
              "Notifications",
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
                labelText: 'Cari Notifications Candidate',
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
