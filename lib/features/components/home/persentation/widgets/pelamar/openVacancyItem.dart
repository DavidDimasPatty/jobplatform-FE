import 'package:flutter/material.dart';

class OpenVacancyItem extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? idx;

  OpenVacancyItem({required this.title, this.subtitle, this.idx});

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
                  (int.parse(idx!) + 1).toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          title: Text(title!),
          subtitle: (subtitle != null)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(subtitle!)],
                )
              : null,
        ),
      ),
    );
  }
}
