import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:job_platform/core/utils/storage/storage_service.dart';

class Managehrditems extends StatefulWidget {
  final String? url;
  final String title;
  final String? subtitle;
  final String status;
  final Future<void> Function()? onDelete;

  Managehrditems({
    this.url,
    required this.title,
    this.subtitle,
    required this.status,
    required this.onDelete,
  });

  @override
  State<Managehrditems> createState() => _ManagehrditemsState();
}

class _ManagehrditemsState extends State<Managehrditems> {
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
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: ListTile(
            onTap: () {},
            leading: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              // padding: EdgeInsets.all(5),
              child: ClipOval(
                child: widget.url!.isNotEmpty
                    ? Image.network(
                        widget.url!,
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
                          color: Theme.of(context).colorScheme.primary,
                          size: 24,
                        ),
                      ),
              ),
            ),
            title: Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: (widget.subtitle != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.subtitle ?? "",
                              style: TextStyle(
                                fontSize: subHeader,
                                fontWeight: FontWeight.normal,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: isSmallScreen
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FaIcon(
                                        widget.status == "Active".tr()
                                            ? FontAwesomeIcons.peopleGroup
                                            : widget.status == "Inactive".tr()
                                            ? FontAwesomeIcons.timeline
                                            : widget.status == "Reject".tr()
                                            ? FontAwesomeIcons.x
                                            : FontAwesomeIcons.circleQuestion,
                                        color: widget.status == "Active".tr()
                                            ? Colors.blue
                                            : widget.status == "Inactive".tr()
                                            ? Colors.orange
                                            : widget.status == "Reject".tr()
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        widget.status,
                                        style: TextStyle(
                                          fontSize: subHeader,
                                          color: widget.status == "Active".tr()
                                              ? Colors.blue
                                              : widget.status == "Inactive".tr()
                                              ? Colors.orange
                                              : widget.status == "Reject".tr()
                                              ? Colors.red
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 8),
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
                                    onPressed: widget.onDelete,
                                    label: Text("Delete".tr()),
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      FaIcon(
                                        widget.status == "Active".tr()
                                            ? FontAwesomeIcons.peopleGroup
                                            : widget.status == "Inactive".tr()
                                            ? FontAwesomeIcons.timeline
                                            : widget.status == "Reject".tr()
                                            ? FontAwesomeIcons.x
                                            : FontAwesomeIcons.circleQuestion,
                                        color: widget.status == "Active".tr()
                                            ? Colors.blue
                                            : widget.status == "Inactive".tr()
                                            ? Colors.orange
                                            : widget.status == "Reject".tr()
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        widget.status,
                                        style: TextStyle(
                                          fontSize: subHeader,
                                          color: widget.status == "Active".tr()
                                              ? Colors.blue
                                              : widget.status == "Inactive".tr()
                                              ? Colors.orange
                                              : widget.status == "Reject".tr()
                                              ? Colors.red
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 8),
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
                                    onPressed: widget.onDelete,
                                    label: Text("Delete".tr()),
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  )
                : null),
          ),
        ),
      ),
    );
  }
}
