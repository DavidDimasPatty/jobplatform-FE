import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_platform/features/components/candidate/domain/entities/candidate.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chat/chatItems.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Listjobreceive extends StatefulWidget {
  // final CandidateItems item;
  Listjobreceive({super.key});

  @override
  State<Listjobreceive> createState() => _Listjobreceive();
}

onSearchChanged() {}

class _Listjobreceive extends State<Listjobreceive> {
  // final CandidateItems item;
  // _Listjobreceive(this.item);

  final _searchController = TextEditingController();
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
        mainAxisSize: MainAxisSize.max,
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
                "Daftar Tawaran Pekerjaan",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 6,
                  child: TextField(
                    controller: _searchController,
                    //onChanged: onSearchChanged,
                    decoration: InputDecoration(
                      hintText: "Search Penawaran...",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 4,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.sort, size: 20),
                    label: Text("Urutkan : Tanggal"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          DefaultTabController(
            length: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  //padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // border: Border.all(color: Colors.black),
                  ),
                  child: TabBar(
                    tabAlignment: TabAlignment.start,
                    isScrollable: true,
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.black,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    indicatorColor: Colors.blue,
                    indicatorWeight: 3,
                    tabs: [
                      Tab(text: "Semua Loker 0"),
                      Tab(text: "Aktif 0"),
                      Tab(text: "Nonaktif 0"),
                      Tab(text: "Dalam Review 0"),
                      Tab(text: "Semua Draft 0"),
                    ],
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: TabBarView(
                    children: [
                      Center(child: Text("Belum Ada Item")),
                      Center(child: Text("Belum Ada Item")),
                      Center(child: Text("Belum Ada Item")),
                      Center(child: Text("Belum Ada Item")),
                      Center(child: Text("Belum Ada Item")),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
