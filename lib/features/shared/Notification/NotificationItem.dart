import 'package:flutter/material.dart';
import 'package:job_platform/features/components/chat/persentasion/pages/chatNav.dart';

class Notificationitem extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color bgColor;
  final Color iconColor;
  //final List<GlobalKey<NavigatorState>> navigatorKeys;
  Notificationitem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    //required this.navigatorKeys,
    required this.bgColor,
  });

  @override
  State<Notificationitem> createState() => _Notificationitem();
}

class _Notificationitem extends State<Notificationitem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // widget.navigatorKeys.currentState!.pushNamed(
        //   'detail-chat',
        //   //arguments: {"navigatorKeys": widget.navigatorKeys},
        // );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ListTile(
          tileColor: widget.bgColor,
          style: ListTileStyle.drawer,
          //onTap: onTap,
          leading: Container(
            child: Icon(widget.icon, size: 20, color: widget.iconColor),
          ),

          title: Text(
            widget.title,
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Container(
            child: Text(
              widget.subtitle,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          trailing: Icon(Icons.navigate_next),
        ),
      ),
    );
  }
}
