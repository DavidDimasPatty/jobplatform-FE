import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  final IconData icons;
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

  SettingsItem({
    required this.icons,
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
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          decoration: BoxDecoration(
            color: (colorBGIcon != null ? colorBGIcon : Colors.lightBlueAccent),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(5),
          child: Icon(
            icons,
            //size: SettingsScreenUtils.settingsGroupIconSize,
            color: (colorIcon != null ? colorIcon : Colors.white),
          ),
        ),
        title: Text(
          title,
          style: titleStyle ?? TextStyle(fontWeight: FontWeight.bold),
          maxLines: titleMaxLine,
          overflow: titleMaxLine != null ? overflow : null,
        ),
        subtitle: (subtitle != null)
            ? Text(
                subtitle!,
                style: subtitleStyle ?? Theme.of(context).textTheme.bodyMedium!,
                maxLines: subtitleMaxLine,
                overflow: subtitleMaxLine != null
                    ? TextOverflow.ellipsis
                    : null,
              )
            : null,
        trailing: (trailing != null) ? trailing : Icon(Icons.navigate_next),
      ),
    );
  }
}
