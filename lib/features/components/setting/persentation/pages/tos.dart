import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Tos extends StatefulWidget {
  Tos({super.key});

  State<Tos> createState() => _Tos();
}

class _Tos extends State<Tos> {
  List<String> Judul = [
    "Acceptance of Terms",
    "Description of Service",
    "User Responsibilites",
    "Intellectual Property",
    "Privacy Policy",
    "Limitation of Liability",
    "Changes to Terms",
    "Contact Us",
  ];
  List<String> Desc = [
    "By using Skillen’s services, you confirm that you have read, understood, and agreed to these Terms of Service. If you do not agree, please discontinue use of our platform immediately.",
    "Skillen provides IT solutions and related digital services for individuals and businesses. We may update, modify, or discontinue any part of our services without prior notice.",
    "You agree to: Provide accurate and up-to-date information when using our platform. Not misuse or attempt to gain unauthorized access to our systems. Comply with all applicable local and international laws. We reserve the right to suspend or terminate accounts that violate these terms.",
    "All content, including logos, text, graphics, and software on Skillen, are the property of Skillen or its licensors. You may not reproduce, modify, or distribute any part of our materials without written permission.",
    "Your privacy is important to us. Please refer to our Privacy Policy for information on how we collect, use, and protect your data.",
    "Skillen shall not be liable for any indirect, incidental, or consequential damages arising from the use or inability to use our services.",
    "We may update these Terms of Service periodically. Any changes will be posted on this page, and continued use of our services means you accept the updated terms.",
    "If you have any questions about these Terms, please contact us at: 📧 support@skillen.com",
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                spreadRadius: 2,
                offset: Offset(3, 3),
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          width: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
              ? double.infinity
              : MediaQuery.of(context).size.width * 0.45,
          alignment: Alignment.center,
          child: ResponsiveRowColumn(
            columnCrossAxisAlignment: CrossAxisAlignment.center,
            rowMainAxisAlignment: MainAxisAlignment.center,
            columnMainAxisAlignment: MainAxisAlignment.center,
            rowCrossAxisAlignment: CrossAxisAlignment.center,
            layout: ResponsiveRowColumnType.COLUMN,
            rowSpacing: 100,
            columnSpacing: 20,
            children: [
              ResponsiveRowColumnItem(
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "Terms of Service",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Last Updated : ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            TextSpan(
                              text: "26 Oktober 2025",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              ResponsiveRowColumnItem(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 15,
                  children: [
                    for (var i = 0; i < Judul.length; i++)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${i + 1}. ${Judul[i]}",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(Desc[i], overflow: TextOverflow.clip),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
