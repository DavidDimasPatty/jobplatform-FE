import 'package:flutter/material.dart';

class Benchmarkitem extends StatelessWidget {
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

  Benchmarkitem({
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
    return InkWell(
      onTap: () {},
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
              ),
            ),
          ),
          title: Text(
            title,
            style: titleStyle ?? TextStyle(fontWeight: FontWeight.bold),
            maxLines: titleMaxLine,
            overflow: titleMaxLine != null ? overflow : null,
          ),
          subtitle: (subtitle != null)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subtitle!,
                      style:
                          subtitleStyle ??
                          Theme.of(context).textTheme.bodyMedium!,
                      maxLines: subtitleMaxLine,
                      overflow: subtitleMaxLine != null
                          ? TextOverflow.ellipsis
                          : null,
                    ),
                    Row(
                      children: skill!.asMap().entries.map((entry) {
                        //String data = skill[entry.value];
                        return Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Text(
                            entry.value,
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                )
              : null,
          trailing: (trailing != null) ? trailing : Icon(Icons.navigate_next),
        ),
      ),
    );
  }
}
