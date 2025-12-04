import 'package:easy_localization/easy_localization.dart';
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
                      child: Icon(
                        Icons.person,
                        color: Theme.of(context).colorScheme.primary,
                        size: 24,
                      ),
                    ),
            ),
          ),
          title: Text(title ?? "Unknown".tr()),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(subtitle ?? "Unknown".tr())],
          ),
        ),
      ),
    );
  }
}
