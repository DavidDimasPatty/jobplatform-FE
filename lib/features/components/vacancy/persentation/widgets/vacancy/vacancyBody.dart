import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_platform/features/components/vacancy/persentation/widgets/vacancy/vacancyItems.dart';

class Vacancybody extends StatefulWidget {
  final List<Vacancyitems> items;
  final VoidCallback onSearchChanged;
  TextEditingController searchController;

  Vacancybody({
    super.key,
    required this.items,
    required this.onSearchChanged,
    required this.searchController,
  });

  @override
  State<Vacancybody> createState() => _Vacancybody();
}

class _Vacancybody extends State<Vacancybody> {
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
                      onChanged: (value) {
                        widget.onSearchChanged();
                      },
                      controller: widget.searchController,
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
      ),
    );
  }
}
