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
    return InkWell(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ListTile(
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
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          title: Text(title),
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
