import 'package:flutter/material.dart';

class OpenVacancyItem extends StatelessWidget {
  final List<String>? skill;
  final String? title;
  final String? subtitle;
  final String? idx;

  OpenVacancyItem({required this.title, this.subtitle, this.skill, this.idx});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ListTile(
          // onTap: onTap,
          leading: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Text(
                  idx.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          title: Text(
            title!,
            // style: titleStyle ?? TextStyle(fontWeight: FontWeight.bold),
            // maxLines: titleMaxLine,
            // overflow: titleMaxLine != null ? overflow : null,
          ),
          subtitle: (subtitle != null)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subtitle!,
                      // style:
                      //     subtitleStyle ??
                      //     Theme.of(context).textTheme.bodyMedium!,
                      // maxLines: subtitleMaxLine,
                      // overflow: subtitleMaxLine != null
                      //     ? TextOverflow.ellipsis
                      //     : null,
                    ),
                    Row(
                      children: skill!.asMap().entries.map((entry) {
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
          // trailing: (trailing != null) ? trailing : Icon(Icons.navigate_next),
        ),
      ),
    );
  }
}
