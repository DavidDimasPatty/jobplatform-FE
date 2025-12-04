import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:job_platform/core/utils/storage/storage_service.dart';

class statusjobitems extends StatefulWidget {
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
  State<statusjobitems> createState() => _StatusJobItemState();
}

class _StatusJobItemState extends State<statusjobitems> {
  final storage = StorageService();
  double? header, subHeader, body, icon;

  Future<void> _initializeFontSize() async {
    header = await storage.get("fontSizeHead") as double;
    subHeader = await storage.get("fontSizeSubHead") as double;
    body = await storage.get("fontSizeBody") as double;
    icon = await storage.get("fontSizeIcon") as double;
  }

  @override
  void initState() {
    super.initState();
    _initializeFontSize();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.all(10),
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
            onTap: widget.onTap,
            leading: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: ClipOval(
                child: widget.url!.isNotEmpty
                    ? Image.network(
                        widget.url!,
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
            title: Text(widget.namaPerusahaan ?? ""),
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
                        '${widget.posisi ?? ''}',
                        style: TextStyle(
                          fontSize: subHeader,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '${widget.jabatan ?? ''} - ${widget.tipeKerja ?? ''}',
                        style: TextStyle(
                          fontSize: icon,
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
              widget.status ?? "",
              style: TextStyle(
                color: widget.status == "Review".tr()
                    ? Colors.orange
                    : widget.status == "Interview".tr()
                    ? Colors.blue
                    : widget.status == "Offering".tr()
                    ? Colors.pink
                    : widget.status == "Menunggu Konfirmasi".tr()
                    ? Colors.indigo
                    : widget.status == "Close".tr()
                    ? Colors.green
                    : Colors.red,
                fontSize: subHeader,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
