import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_platform/features/components/profile/domain/entities/PreferenceMV.dart';

class Vacancytableitem extends StatelessWidget {
  final String? url;
  final List<String>? skill;
  final String? index;
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

  Vacancytableitem({
    this.url,
    required this.title,
    this.titleStyle,
    this.index,
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
        context.go("/progress");
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ListTile(
          onTap: onTap,
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
                  index.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
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
                            "Full Time",
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
        ),
      ),
    );
  }
}
