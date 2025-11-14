import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_platform/features/components/chat/data/models/partnerModel.dart';

class Chatitems extends StatelessWidget {
  final PartnerModel partner;

  Chatitems({
    super.key,
    required this.partner,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go("/chatDetail", extra: partner);
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
              backgroundImage: NetworkImage(partner.partnerPhotoUrl),
              backgroundColor: Colors.blueGrey,
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
          trailing: Icon(Icons.navigate_next),
        ),
      ),
    );
  }
}
