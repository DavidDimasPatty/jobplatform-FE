import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:job_platform/features/shared/Notification/NotificationItem.dart';

class Notificationbody extends StatefulWidget {
  // final CandidateItems item;
  List<Notificationitem> data;
  VoidCallback toggleNotification;
  
  Notificationbody({
    super.key,
    required this.toggleNotification,
    required this.data,
  });

  @override
  State<Notificationbody> createState() => _Notificationbody();
}

class _Notificationbody extends State<Notificationbody>
    with SingleTickerProviderStateMixin {
  // final CandidateItems item;
  // _Listjobreceive(this.item);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 40,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.topRight,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(12),
            color: Colors.black26,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // header notif
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Notifikasi",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: widget.toggleNotification,
                      ),
                    ],
                  ),

                  // list notif
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 300),
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: widget.data.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1, color: Colors.white24),
                      itemBuilder: (context, index) => widget.data[index],
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        widget.toggleNotification();
                        context.go("/notificationDetail");
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(color: Colors.black38),
                        child: Text(
                          "See More Notifications",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
