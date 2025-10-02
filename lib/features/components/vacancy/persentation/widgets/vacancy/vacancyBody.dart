import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:job_platform/features/components/cart/persentation/widgets/cartItems.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chat/chatItems.dart';
import 'package:job_platform/features/components/vacancy/persentation/widgets/vacancy/vacancyItems.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Vacancybody extends StatefulWidget {
  final List<Vacancyitems> items;
  Vacancybody({super.key, required this.items});

  @override
  State<Vacancybody> createState() => _Vacancybody();
}

class _Vacancybody extends State<Vacancybody> {
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
              "Vacancies",
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
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Cari Vacancy',
                      hintText: 'Masukan Vacancy',
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
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    context.go("/vacancyAdd");
                  },
                  label: const Text("Add"),
                  icon: const Icon(Icons.add),
                ),
              ],
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
