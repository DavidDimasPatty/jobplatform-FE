import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Chatitems extends StatefulWidget {
  final String photoUrl;
  final String name;
  final String? lastChat;
  Chatitems({
    super.key,
    required this.photoUrl,
    required this.name,
    this.lastChat,
  });

  @override
  State<Chatitems> createState() => _Chatitems();
}

class _Chatitems extends State<Chatitems> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go("/chatDetail");
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ListTile(
          //onTap: onTap,
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(widget.photoUrl),
              backgroundColor: Colors.blueGrey,
            ),
          ),

          title: Text(
            widget.name,
            style: TextStyle(fontWeight: FontWeight.normal),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: (widget.lastChat != null)
              ? Text(
                  widget.lastChat!,
                  //style: subtitleStyle ?? Theme.of(context).textTheme.bodyMedium!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          trailing: Icon(Icons.navigate_next),
        ),
      ),
    );
  }
}
