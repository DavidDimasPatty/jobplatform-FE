import 'package:flutter/material.dart';
import 'package:job_platform/core/utils/storage/storage_service.dart';

class Vacancytableitem extends StatefulWidget {
  final String? url;
  final List<String>? skill;
  final String? index;
  final String title;
  final String? subtitle;

  Vacancytableitem({
    this.url,
    required this.title,
    this.index,
    this.subtitle,
    this.skill,
  });

  @override
  State<Vacancytableitem> createState() => _VacancytableitemState();
}

class _VacancytableitemState extends State<Vacancytableitem> {
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ListTile(
          leading: SizedBox(
            width: 40,
            height: 40,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.blue.shade300,
              ),
              child: Center(
                child: Text(
                  (int.parse(widget.index!) + 1).toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: header,
                  ),
                ),
              ),
            ),
          ),
          title: Text(widget.title),
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
                  ],
                )
              : null),
        ),
      ),
    );
  }
}
