import 'package:flutter/material.dart';

class Benchmarkitem extends StatelessWidget {
  final String? url;
  final String? title;
  final String? subtitle;

  Benchmarkitem({this.url, required this.title, this.subtitle});

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
            child: ClipOval(
              child: url!.isNotEmpty
                  ? Image.network(
                      url!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
            ),
          ),
          title: Text(
            title ?? "Unknown",
            // style: titleStyle ?? TextStyle(fontWeight: FontWeight.bold),
            // maxLines: titleMaxLine,
            // overflow: titleMaxLine != null ? overflow : null,
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subtitle ?? "Unknown",
                // style:
                //     subtitleStyle ??
                //     Theme.of(context).textTheme.bodyMedium!,
                // maxLines: subtitleMaxLine,
                // overflow: subtitleMaxLine != null
                //     ? TextOverflow.ellipsis
                //     : null,
              ),
              // Row(
              //   children: skill!.asMap().entries.map((entry) {
              //     return Container(
              //       padding: EdgeInsets.all(5),
              //       margin: EdgeInsets.all(5),
              //       decoration: BoxDecoration(
              //         color: Colors.blue,
              //         borderRadius: BorderRadius.all(Radius.circular(10)),
              //       ),
              //       child: Text(
              //         entry.value,
              //         style: TextStyle(color: Colors.white),
              //       ),
              //     );
              //   }).toList(),
              // ),
            ],
          ),
          //trailing: (trailing != null) ? trailing : Icon(Icons.navigate_next),
        ),
      ),
    );
  }
}
