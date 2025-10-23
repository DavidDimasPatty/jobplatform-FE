import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Progressitems extends StatelessWidget {
  final String? url;
  final String? namaKandidat;
  final String? namaPosisi;
  final String? jabatan;
  final String? tipeKerja;
  final String? umur;
  final VoidCallback? onTap;
  final String? status;

  Progressitems({
    this.url,
    this.namaKandidat,
    this.namaPosisi,
    this.jabatan,
    this.tipeKerja,
    this.umur,
    this.onTap,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(7),
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            onTap: onTap,
            leading: Container(
              decoration: BoxDecoration(
                // color: (colorBGIcon != null ? colorBGIcon : Colors.lightBlueAccent),
                borderRadius: BorderRadius.circular(8),
              ),
              // padding: EdgeInsets.all(5),
              child: ClipOval(
                child: Image.asset(
                  "assets/images/BG_Pelamar.png",
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text("${namaKandidat ?? ""} ({${umur ?? "0"}})"),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        " ${namaPosisi ?? ""} - ${jabatan ?? ""} - ${tipeKerja ?? ""} ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87,
                        ),
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(fontSize: 14),
                          children: [
                            TextSpan(
                              text: "Status : ",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: status ?? "",
                              style: TextStyle(
                                color: status == "Review"
                                    ? Colors.orange
                                    : status == "Interview"
                                    ? Colors.blue
                                    : status == "Offering"
                                    ? Colors.pink
                                    : status == "Menunggu Konfirmasi"
                                    ? Colors.indigo
                                    : status == "Close"
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 3,
                  fit: FlexFit.loose,
                  child: isSmallScreen
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: onTap,
                              label: Text("Validasi"),
                              icon: Icon(Icons.skip_next),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: onTap,
                              label: Text("Validasi"),
                              icon: Icon(Icons.skip_next),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
