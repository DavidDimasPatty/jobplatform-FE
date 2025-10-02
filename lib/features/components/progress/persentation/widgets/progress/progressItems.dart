import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Progressitems extends StatelessWidget {
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

  Progressitems({
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
      onTap: () {},
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
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
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(fontSize: 14),
                              children: [
                                const TextSpan(
                                  text: "Status : ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: "Interview",
                                  style: TextStyle(
                                    color: Colors.yellow,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      fit: FlexFit.loose,
                      child: isSmallScreen
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    context.go("/progressDetail", extra: "tes");
                                  },
                                  label: Text("Validasi"),
                                  icon: Icon(Icons.skip_next),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Status : ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Interview",
                                  style: TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(width: 20),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    context.go("/progressDetail", extra: "tes");
                                  },
                                  label: Text("Validasi"),
                                  icon: Icon(Icons.skip_next),
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
