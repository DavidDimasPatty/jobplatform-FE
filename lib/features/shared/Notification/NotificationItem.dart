import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_platform/core/utils/storage/storage_service.dart';

class Notificationitem extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color bgColor;
  final Color iconColor;
  final String? routeName;
  final bool isRead;

  Notificationitem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.bgColor,
    this.routeName,
    this.isRead = false,
  });

  @override
  State<Notificationitem> createState() => _Notificationitem();
}

class _Notificationitem extends State<Notificationitem> {
  final storage = StorageService();
  double? header, subHeader, body, icon;

  Future<void> _initialize() async {
    header = await storage.get("fontSizeHead") as double;
    subHeader = await storage.get("fontSizeSubHead") as double;
    body = await storage.get("fontSizeBody") as double;
    icon = await storage.get("fontSizeIcon") as double;
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.routeName != null) {
          context.go(widget.routeName!);
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ListTile(
          tileColor: widget.bgColor,
          style: ListTileStyle.drawer,
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
          subtitle: Container(
            child: Text(
              widget.subtitle,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: body,
              ),
            ),
          ),
          trailing: Icon(Icons.navigate_next),
        ),
      ),
    );
  }
}
