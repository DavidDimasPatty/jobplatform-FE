import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Managehrditems extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
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
                    : Image.asset(
                        "assets/images/BG_HRD.png",
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: (subtitle != null
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
                              subtitle ?? "",
                              style: const TextStyle(
                                fontSize: 16,
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
                                        status == "Active"
                                            ? FontAwesomeIcons.peopleGroup
                                            : status == "Inactive"
                                            ? FontAwesomeIcons.timeline
                                            : status == "Reject"
                                            ? FontAwesomeIcons.x
                                            : FontAwesomeIcons.circleQuestion,
                                        color: status == "Active"
                                            ? Colors.blue
                                            : status == "Inactive"
                                            ? Colors.orange
                                            : status == "Reject"
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        status,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: status == "Active"
                                              ? Colors.blue
                                              : status == "Inactive"
                                              ? Colors.orange
                                              : status == "Reject"
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
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: onDelete,
                                    label: const Text("Delete"),
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
                                        status == "Active"
                                            ? FontAwesomeIcons.peopleGroup
                                            : status == "Inactive"
                                            ? FontAwesomeIcons.timeline
                                            : status == "Reject"
                                            ? FontAwesomeIcons.x
                                            : FontAwesomeIcons.circleQuestion,
                                        color: status == "Active"
                                            ? Colors.blue
                                            : status == "Inactive"
                                            ? Colors.orange
                                            : status == "Reject"
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        status,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: status == "Active"
                                              ? Colors.blue
                                              : status == "Inactive"
                                              ? Colors.orange
                                              : status == "Reject"
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
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: onDelete,
                                    label: const Text("Delete"),
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
