import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Vacancytableitem extends StatelessWidget {
  final String? url;
  final List<String>? skill;
  final String? index;
  final String title;
  final String? subtitle;

  Vacancytableitem({
    this.url,
    required this.title,
    this.index,
    this.subtitle,
    this.skill,
  });

  @override
  Widget build(BuildContext context) {
    //final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return InkWell(
      // onTap: () {
      //   context.go("/progress");
      // },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ListTile(
          //onTap: onTap,
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
                  (int.parse(index!) + 1).toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
          title: Text(
            title,
            // style: titleStyle ?? TextStyle(fontWeight: FontWeight.bold),
            // maxLines: titleMaxLine,
            // overflow: titleMaxLine != null ? overflow : null,
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
                          // const Text(
                          //   "Full Time",
                          //   style: TextStyle(
                          //     fontSize: 12,
                          //     fontWeight: FontWeight.normal,
                          //     color: Colors.black54,
                          //   ),
                          // ),
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
