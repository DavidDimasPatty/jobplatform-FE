import 'package:flutter/material.dart';

class topSetting extends StatelessWidget {
  // final Color? cardColor;
  // final double? cardRadius;
  // final Color? backgroundMotifColor;
  // final VoidCallback? onTap;
  // final String? userName;
  // final Widget? userMoreInfo;
  // final ImageProvider userProfilePic;

  // topSetting({
  // required this.cardColor,
  // this.cardRadius = 30,
  // required this.userName,
  // this.backgroundMotifColor = Colors.white,
  // this.userMoreInfo,
  // required this.userProfilePic,
  // required this.onTap,
  // });
  Widget build(BuildContext context) {
    var mediaQueryHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      //onTap: onTap,
      child: Container(
        // height: mediaQueryHeight / 3,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Alexander Nando Regex",
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
                                "Job Seeker | Regular Account",
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
                          child: Icon(
                            Icons.priority_high_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),

                        title: Text(
                          "Profile Complete",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 3,
                          //overflow: titleMaxLine != null ? overflow : null,
                        ),
                        subtitle: Text(
                          "Profile Anda Sudah Lengkap!",
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
                            color: Colors.yellowAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            Icons.star,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),

                        title: Text(
                          "Upgrade Account",
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
