import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_platform/core/utils/storage/storage_service.dart';

class NotificationDetailitems extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color bgColor;
  final Color iconColor;
  final String about;
  final String? route;
  final bool isRead;

  NotificationDetailitems({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.bgColor,
    required this.about,
    this.route,
    this.isRead = false,
  });

  @override
  State<NotificationDetailitems> createState() => _NotificationDetailitems();
}

class _NotificationDetailitems extends State<NotificationDetailitems> {
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
    return GestureDetector(
      onTap: () {
        if (widget.route != null) {
          context.go(widget.route!);
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ListTile(
          tileColor: widget.isRead ? Colors.white : Colors.blue.shade50,
          style: ListTileStyle.list,
          //onTap: onTap,
          leading: Container(
            child: Icon(widget.icon, size: 20, color: widget.iconColor),
          ),

          title: Text(
            widget.title,
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: header),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: (widget.about == "offer"
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.subtitle,
                            style: TextStyle(
                              fontSize: subHeader,
                              fontWeight: FontWeight.normal,
                              color: Colors.black87,
                            ),
                          ),
                          Row(
                            spacing: 20,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {},
                                label: Text("Accept".tr()),
                                icon: const Icon(Icons.check),
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {},
                                label: Text("Reject".tr()),
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Container(
                  child: Text(
                    widget.subtitle,
                    // style: TextStyle(color:Theme.of(context).colorScheme.secondary, fontSize: 12),
                  ),
                )),
        ),
      ),
    );
  }
}
