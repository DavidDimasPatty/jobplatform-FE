import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:job_platform/core/utils/storage/storage_service.dart';

class Cartitems extends StatefulWidget {
  final String? url;
  final List<String>? skill;
  final String title;
  final TextStyle? titleStyle;
  final String? subtitle;
  final TextStyle? subtitleStyle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final int? titleMaxLine;
  final int? subtitleMaxLine;
  final TextOverflow? overflow;
  final Color? colorIcon;
  final Color? colorBGIcon;

  Cartitems({
    this.url,
    required this.title,
    this.titleStyle,
    this.subtitle,
    this.subtitleStyle,
    this.trailing,
    this.onTap,
    this.titleMaxLine,
    this.subtitleMaxLine,
    this.overflow = TextOverflow.ellipsis,
    this.colorIcon,
    this.colorBGIcon,
    this.skill,
  });

  @override
  State<Cartitems> createState() => _CartitemsState();
}

class _CartitemsState extends State<Cartitems> {
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ListTile(
          onTap: widget.onTap,
          leading: Container(
            decoration: BoxDecoration(
              // color: (colorBGIcon != null ? colorBGIcon : Colors.lightBlueAccent),
              borderRadius: BorderRadius.circular(8),
            ),
            // padding: EdgeInsets.all(5),
            child: ClipOval(
              child: Image.asset(
                "assets/images/BG_Pelamar.png",
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            widget.title,
            style: widget.titleStyle ?? TextStyle(fontWeight: FontWeight.bold),
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
                            "Bandung, Jawa Barat",
                            style: TextStyle(
                              fontSize: icon,
                              fontWeight: FontWeight.normal,
                              color: Colors.black54,
                            ),
                          ),
                          // Text(
                          //   "Match Score : 80%",
                          //   style: TextStyle(
                          //     fontSize: body,
                          //     fontWeight: FontWeight.bold,
                          //     color: Colors.blueAccent,
                          //   ),
                          // ),
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
                                  onPressed: () {},
                                  label: Text("See Profile".tr()),
                                  icon: const Icon(Icons.visibility),
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
                                  onPressed: () {},
                                  label: Text("Delete".tr()),
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                  onPressed: () {},
                                  label: Text("See Profile".tr()),
                                  icon: const Icon(Icons.visibility),
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
    );
  }
}
