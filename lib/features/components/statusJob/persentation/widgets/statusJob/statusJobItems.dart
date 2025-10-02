import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class statusjobitems extends StatelessWidget {
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

  statusjobitems({
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
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return InkWell(
      onTap: () {
        context.go("/statusJobDetail");
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ListTile(
          onTap: onTap,
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
                color: Colors.cyan,
              ),
            ),
          ),
          title: Text(
            title,
            style: titleStyle ?? TextStyle(fontWeight: FontWeight.bold),
            maxLines: titleMaxLine,
            overflow: titleMaxLine != null ? overflow : null,
          ),
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
                          const Text(
                            "Bandung, Jawa Barat",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : null),
          trailing: Text(
            "Need Action",
            style: TextStyle(color: Colors.orange.shade600, fontSize: 17),
          ),
        ),
      ),
    );
  }
}
