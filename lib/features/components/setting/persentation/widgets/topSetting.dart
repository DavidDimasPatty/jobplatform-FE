import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class topSetting extends StatelessWidget {
  final String nama;
  final String loginAs;
  final bool isPremium;
  final String? url;
  final int? profileComplete;
  topSetting({
    required this.nama,
    required this.loginAs,
    required this.isPremium,
    this.url,
    this.profileComplete,
  });

  Widget build(BuildContext context) {
    var mediaQueryHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => {
        if (loginAs == "company")
          {context.go("/profileCompany")}
        else
          {context.go("/profile")},
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20, top: 10),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: -300,
              left: -300,
              child: Container(
                width: 1000,
                height: 1000,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.shade600,
                ),
              ),
            ),

            Positioned(
              bottom: -150,
              left: -150,
              child: Container(
                width: 600,
                height: 600,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.shade700,
                ),
              ),
            ),

            Positioned(
              bottom: -50,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.shade800,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // User profile
                      Container(
                        margin: EdgeInsets.only(
                          bottom: 10,
                          top: 30,
                          left: 30,
                          right: 30,
                        ),
                        child: Center(
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              ClipOval(
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
                                        child: const Icon(
                                          Icons.person,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "${nama.isEmpty ? "Unknown" : nama}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: mediaQueryHeight / 30,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () {},
                              icon: Icon(Icons.star, color: Colors.white),
                              label: Text(
                                "${loginAs == "user" ? "Job Seeker".tr() : "Company".tr()} | ${isPremium ? "Premium Account".tr() : "Regular Account".tr()}",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: mediaQueryHeight / 60,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 30, bottom: 0),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: ListTile(
                        //onTap: onTap,
                        leading: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.all(5),
                          child: profileComplete != 100
                              ? Icon(
                                  Icons.priority_high_rounded,
                                  size: 20,
                                  color: Colors.white,
                                )
                              : Icon(
                                  Icons.check,
                                  size: 20,
                                  color: Colors.white,
                                ),
                        ),

                        title: Text(
                          "${profileComplete == 100 ? "Profile Complete".tr() : "${profileComplete}%"}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 3,
                          //overflow: titleMaxLine != null ? overflow : null,
                        ),
                        subtitle: Text(
                          "${profileComplete == 100 ? "Profile Anda Sudah Lengkap!".tr() : "Lengkapi Profile Anda".tr()}",
                          style: TextStyle(color: Colors.white),
                          maxLines: 3,
                          // overflow:
                          //     subtitleMaxLine != null ? TextOverflow.ellipsis : null,
                        ),
                        trailing: Icon(Icons.navigate_next),
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: ListTile(
                        //onTap: onTap,
                        leading: Container(
                          decoration: BoxDecoration(
                            color: isPremium
                                ? Colors.yellowAccent
                                : Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.all(5),
                          child: isPremium
                              ? Icon(Icons.star, size: 20, color: Colors.white)
                              : Icon(
                                  Icons.upgrade,
                                  size: 20,
                                  color: Colors.white,
                                ),
                        ),

                        title: Text(
                          "${!isPremium ? "Upgrade Account".tr() : "Premium Account".tr()}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 3,
                          //overflow: titleMaxLine != null ? overflow : null,
                        ),

                        trailing: Icon(Icons.navigate_next),
                      ),
                    ),
                  ),
                  //),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
