import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_platform/features/components/chat/data/models/partnerModel.dart';

class Chatitems extends StatelessWidget {
  final PartnerModel partner;

  Chatitems({super.key, required this.partner});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go("/chatDetail", extra: partner);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ListTile(
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(partner.partnerPhotoUrl),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
          ),

          title: Text(
            partner.partnerName,
            style: TextStyle(fontWeight: FontWeight.normal),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            partner.lastMessage,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Row(
            children: [
              if (partner.unreadCount > 0)
                Container(
                  margin: EdgeInsets.only(left: 4),
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    partner.unreadCount.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              Icon(Icons.navigate_next),
            ],
          ),
        ),
      ),
    );
  }
}
