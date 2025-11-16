import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
          color: Theme.of(context).colorScheme.secondary,
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
                child: url!.isNotEmpty
                    ? Image.network(
                        url!,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 40,
                        height: 40,
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.person,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24,
                        ),
                      ),
              ),
            ),
            title: Text("${namaKandidat ?? ""} (${umur ?? "0"})"),
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
                              text: "Status : ".tr(),
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: status ?? "",
                              style: TextStyle(
                                color: status == "Review".tr()
                                    ? Colors.orange
                                    : status == "Interview".tr()
                                    ? Colors.blue
                                    : status == "Offering".tr()
                                    ? Colors.pink
                                    : status == "Menunggu Konfirmasi".tr()
                                    ? Colors.indigo
                                    : status == "Close".tr()
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
                            if (status != "Close".tr() &&
                                !status!.contains("Reject".tr()))
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                  foregroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: onTap,
                                label: Text("Validasi".tr()),
                                icon: Icon(Icons.skip_next),
                              ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.secondary,
                                foregroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: onTap,
                              label: Text("Validasi".tr()),
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
