import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_platform/features/components/candidate/domain/entities/candidate.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chat/chatItems.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Graficprofil extends StatefulWidget {
  // final CandidateItems item;
  GlobalKey<NavigatorState> navigatorKeys;
  Graficprofil({super.key, required this.navigatorKeys});

  @override
  State<Graficprofil> createState() => _Graficprofil();
}

class _Graficprofil extends State<Graficprofil> {
  // final CandidateItems item;
  // _Listjobreceive(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 200),
      decoration: BoxDecoration(
        color: Colors.white,
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
                      CircleAvatar(
                        radius: 64,
                        backgroundColor: Colors.white,
                        child: const CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage(
                            "assets/images/BG_Pelamar.png",
                          ),
                          backgroundColor: Colors.blueGrey,
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
                    "David Dimas Patty, ayo lengkapi profile anda untuk 3.7x dilihat oleh recruiter!",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
                    "Kelengkapan Profile : 85%",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.65,
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
