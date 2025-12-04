import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:job_platform/core/utils/storage/storage_service.dart';

class Graficprofil extends StatefulWidget {
  final double? profileComplete;
  final String? username;
  final String? photoURL;
  const Graficprofil({
    super.key,
    this.profileComplete,
    this.username,
    this.photoURL,
  });

  @override
  State<Graficprofil> createState() => _Graficprofil();
}

class _Graficprofil extends State<Graficprofil> {
  final storage = StorageService();
  double? header, subHeader, body, icon;

  Future<void> _initializeFontSize() async {
    header = await storage.get("fontSizeHead") as double;
    subHeader = await storage.get("fontSizeSubHead") as double;
    body = await storage.get("fontSizeBody") as double;
    icon = await storage.get("fontSizeIcon") as double;
  }

  @override
  void initState() {
    super.initState();
    _initializeFontSize();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 200),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                  bottom: 10,
                  top: 10,
                  left: 30,
                  right: 30,
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      ClipOval(
                        child: widget.photoURL!.isNotEmpty
                            ? Image.network(
                                widget.photoURL!,
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
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${widget.username}, ${"textProfileComplete".tr()}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: subHeader,
                    ),
                    textAlign: TextAlign.start,
                    maxLines: null,
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                ),
              ),
            ],
          ),

          Container(
            margin: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "${"Kelengkapan Profile".tr()} : ${widget.profileComplete ?? 0}%",
                    style: TextStyle(
                      fontSize: body,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                SizedBox(height: 8),

                Center(
                  child: Container(
                    width:
                        MediaQuery.of(context).size.width *
                        (widget.profileComplete ?? 1) /
                        100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: 0.85,
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blueGrey,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
