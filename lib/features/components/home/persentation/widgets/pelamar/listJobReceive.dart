import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:job_platform/features/components/home/data/models/TawaranPekerjaan.dart';

class Listjobreceive extends StatefulWidget {
  final List<TawaranPekerjaan>? dataTawaran;
  Listjobreceive({super.key, this.dataTawaran});

  @override
  State<Listjobreceive> createState() => _Listjobreceive();
}

class _Listjobreceive extends State<Listjobreceive> {
  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 200),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
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
                "Daftar Tawaran Pekerjaan".tr(),
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
                      hintText: "Cari Penawaran...".tr(),
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
                    //color:Theme.of(context).colorScheme.secondary,
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
                      Tab(
                        text:
                            "Semua Tawaran ${widget.dataTawaran!.length.toString()}",
                      ),
                      Tab(
                        text:
                            "Butuh Konfirmasi ${widget.dataTawaran!.where((x) => x.status == "Konfirmasi User").length.toString()}",
                      ),
                      Tab(
                        text:
                            "Proses ${widget.dataTawaran!.where((x) => x.status == "Review" || x.status == "Interview" || x.status == "Offering").length.toString()}",
                      ),
                      Tab(
                        text:
                            "Close ${widget.dataTawaran!.where((x) => x.status == "Close").length.toString()}",
                      ),
                      Tab(
                        text:
                            "Reject ${widget.dataTawaran!.where((x) => x.status == "Reject HRD" || x.status == "User Menolak").length.toString()}",
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: TabBarView(
                    children: [
                      Center(
                        child: Column(
                          children: widget.dataTawaran!.asMap().entries.map((
                            entry,
                          ) {
                            //int idx = entry.key + 1;
                            var data = entry.value;
                            return InkWell(
                              //onTap: () => onEditPressed(data),
                              // onTap: () {},
                              child: Container(
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: ClipOval(
                                        child: data.urlPhoto!.isNotEmpty
                                            ? Image.network(
                                                data.urlPhoto!,
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.cover,
                                              )
                                            : Container(
                                                width: 60,
                                                height: 60,
                                                color: Colors.grey[300],
                                                child: Icon(
                                                  Icons.person,
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                                  size: 24,
                                                ),
                                              ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          data.namaPerusahaan!,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "${data.namaPosisi} - ${data.jabatan} - ${data.tipeKerja}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),

                                    Flexible(
                                      flex: 2,
                                      child: Text(
                                        softWrap: true,
                                        textAlign: TextAlign.center,
                                        data.status!,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      Center(
                        child: Column(
                          children: widget.dataTawaran!
                              .where((x) => x.status == "Konfirmasi User")
                              .map((entry) {
                                //int idx = entry.key + 1;
                                var data = entry;
                                return InkWell(
                                  //onTap: () => onEditPressed(data),
                                  // onTap: () {},
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                          ),
                                          child: ClipOval(
                                            child: data.urlPhoto!.isNotEmpty
                                                ? Image.network(
                                                    data.urlPhoto!,
                                                    width: 60,
                                                    height: 60,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Container(
                                                    width: 60,
                                                    height: 60,
                                                    color: Colors.grey[300],
                                                    child: Icon(
                                                      Icons.person,
                                                      color: Theme.of(
                                                        context,
                                                      ).colorScheme.primary,
                                                      size: 24,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              data.namaPerusahaan!,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "${data.namaPosisi} - ${data.jabatan} - ${data.tipeKerja}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),

                                        Flexible(
                                          flex: 2,
                                          child: Text(
                                            softWrap: true,
                                            textAlign: TextAlign.center,
                                            data.status!,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })
                              .toList(),
                        ),
                      ),

                      Center(
                        child: Column(
                          children: widget.dataTawaran!
                              .where(
                                (x) =>
                                    x.status == "Review" ||
                                    x.status == "Interview" ||
                                    x.status == "Offering",
                              )
                              .map((entry) {
                                //int idx = entry.key + 1;
                                var data = entry;
                                return InkWell(
                                  //onTap: () => onEditPressed(data),
                                  // onTap: () {},
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                          ),
                                          child: ClipOval(
                                            child: data.urlPhoto!.isNotEmpty
                                                ? Image.network(
                                                    data.urlPhoto!,
                                                    width: 60,
                                                    height: 60,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Container(
                                                    width: 60,
                                                    height: 60,
                                                    color: Colors.grey[300],
                                                    child: Icon(
                                                      Icons.person,
                                                      color: Theme.of(
                                                        context,
                                                      ).colorScheme.primary,
                                                      size: 24,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              data.namaPerusahaan!,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "${data.namaPosisi} - ${data.jabatan} - ${data.tipeKerja}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),

                                        Flexible(
                                          flex: 2,
                                          child: Text(
                                            softWrap: true,
                                            textAlign: TextAlign.center,
                                            data.status!,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })
                              .toList(),
                        ),
                      ),

                      Center(
                        child: Column(
                          children: widget.dataTawaran!
                              .where((x) => x.status == "Close")
                              .map((entry) {
                                //int idx = entry.key + 1;
                                var data = entry;
                                return InkWell(
                                  //onTap: () => onEditPressed(data),
                                  // onTap: () {},
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                          ),
                                          child: ClipOval(
                                            child: data.urlPhoto!.isNotEmpty
                                                ? Image.network(
                                                    data.urlPhoto!,
                                                    width: 60,
                                                    height: 60,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Container(
                                                    width: 60,
                                                    height: 60,
                                                    color: Colors.grey[300],
                                                    child: Icon(
                                                      Icons.person,
                                                      color: Theme.of(
                                                        context,
                                                      ).colorScheme.primary,
                                                      size: 24,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              data.namaPerusahaan!,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "${data.namaPosisi} - ${data.jabatan} - ${data.tipeKerja}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),

                                        Flexible(
                                          flex: 2,
                                          child: Text(
                                            softWrap: true,
                                            textAlign: TextAlign.center,
                                            data.status!,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })
                              .toList(),
                        ),
                      ),

                      Center(
                        child: Column(
                          children: widget.dataTawaran!
                              .where(
                                (x) =>
                                    x.status == "Reject HRD" ||
                                    x.status == "User Menolak",
                              )
                              .map((entry) {
                                //int idx = entry.key + 1;
                                var data = entry;
                                return InkWell(
                                  //onTap: () => onEditPressed(data),
                                  // onTap: () {},
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                          ),
                                          child: ClipOval(
                                            child: data.urlPhoto!.isNotEmpty
                                                ? Image.network(
                                                    data.urlPhoto!,
                                                    width: 60,
                                                    height: 60,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Container(
                                                    width: 60,
                                                    height: 60,
                                                    color: Colors.grey[300],
                                                    child: Icon(
                                                      Icons.person,
                                                      color: Theme.of(
                                                        context,
                                                      ).colorScheme.primary,
                                                      size: 24,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              data.namaPerusahaan!,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "${data.namaPosisi} - ${data.jabatan} - ${data.tipeKerja}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),

                                        Flexible(
                                          flex: 2,
                                          child: Text(
                                            softWrap: true,
                                            textAlign: TextAlign.center,
                                            data.status!,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })
                              .toList(),
                        ),
                      ),
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
