import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationDetailitems extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color bgColor;
  final Color iconColor;
  final String about;
  String? route;
  bool isRead;

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
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
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
                            style: const TextStyle(
                              fontSize: 16,
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
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {},
                                label: const Text("Accept"),
                                icon: const Icon(Icons.check),
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {},
                                label: const Text("Reject"),
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
                    // style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                )),
        ),
      ),
    );
  }
}
