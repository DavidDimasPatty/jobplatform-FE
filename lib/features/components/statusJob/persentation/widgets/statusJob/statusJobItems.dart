import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class statusjobitems extends StatelessWidget {
  final String? url;
  final String? namaPerusahaan;
  final String? posisi;
  final String? jabatan;
  final String? tipeKerja;
  final String? status;
  final VoidCallback? onTap;

  statusjobitems({
    this.url,
    this.namaPerusahaan,
    this.onTap,
    this.jabatan,
    this.posisi,
    this.status,
    this.tipeKerja,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return InkWell(
      onTap: onTap,
      child: Container(
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: ListTile(
            onTap: onTap,
            leading: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: ClipOval(
                child: Image.network(
                  url!,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  color: Colors.cyan,
                ),
              ),
            ),
            title: Text(namaPerusahaan ?? ""),
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
                        '${posisi ?? ''}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '${jabatan ?? ''} - ${tipeKerja ?? ''}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            trailing: Text(
              status ?? "",
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
                fontSize: 17,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
