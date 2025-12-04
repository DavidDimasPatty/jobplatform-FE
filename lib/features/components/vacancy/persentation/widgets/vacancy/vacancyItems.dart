import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_platform/core/utils/storage/storage_service.dart';
import 'package:job_platform/features/components/vacancy/domain/entities/vacancyData.dart';

class Vacancyitems extends StatefulWidget {
  final String? url;
  final List<String>? skill;
  final String? index;
  final String title;
  final TextStyle? titleStyle;
  final String? subtitle;
  final TextStyle? subtitleStyle;
  final VacancyData vacancy;
  final Widget? trailing;
  final VoidCallback? onTap;
  final int? titleMaxLine;
  final int? subtitleMaxLine;
  final TextOverflow? overflow;
  final Color? colorIcon;
  final Color? colorBGIcon;
  final Future<void> Function()? onDelete;

  Vacancyitems({
    this.url,
    required this.title,
    this.titleStyle,
    this.index,
    this.subtitle,
    this.subtitleStyle,
    required this.vacancy,
    this.trailing,
    this.onTap,
    this.titleMaxLine,
    this.subtitleMaxLine,
    this.overflow = TextOverflow.ellipsis,
    this.colorIcon,
    this.colorBGIcon,
    this.skill,
    this.onDelete,
  });

  @override
  State<Vacancyitems> createState() => _VacancyItemsState();
}

class _VacancyItemsState extends State<Vacancyitems> {
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
      onTap: () {
        context.go("/vacancyDetail", extra: widget.vacancy);
      },
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
            onTap: widget.onTap,
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
                    widget.index.toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              widget.title,
              style:
                  widget.titleStyle ?? TextStyle(fontWeight: FontWeight.bold),
              maxLines: widget.titleMaxLine,
              overflow: widget.titleMaxLine != null ? widget.overflow : null,
            ),
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
                            Text(
                              widget.vacancy.tipeKerja ?? "Full Time".tr(),
                              style: TextStyle(
                                fontSize: icon,
                                fontWeight: FontWeight.normal,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              widget.vacancy.sistemKerja ?? "WFO".tr(),
                              style: TextStyle(
                                fontSize: body,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
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
                                    onPressed: () {
                                      context.go(
                                        "/vacancyEdit",
                                        extra: widget.vacancy,
                                      );
                                    },
                                    label: Text("Edit".tr()),
                                    icon: const Icon(Icons.edit),
                                  ),
                                  const SizedBox(height: 8),
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
                                    icon: Icon(Icons.delete),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                    onPressed: () {
                                      context.go(
                                        "/vacancyEdit",
                                        extra: widget.vacancy,
                                      );
                                    },
                                    label: Text("Edit".tr()),
                                    icon: const Icon(Icons.edit),
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
