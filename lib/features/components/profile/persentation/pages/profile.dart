import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_platform/features/components/login/persentation/widgets/loginForm.dart';
import 'package:job_platform/features/components/profile/persentation/widgets/profile/workExperience.dart';
import 'package:job_platform/features/shared/layout.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _Profile();
}

class _Profile extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: ResponsiveRowColumn(
        columnCrossAxisAlignment: CrossAxisAlignment.center,
        rowMainAxisAlignment: MainAxisAlignment.center,
        columnMainAxisAlignment: MainAxisAlignment.center,
        rowCrossAxisAlignment: CrossAxisAlignment.center,
        // layout: ResponsiveBreakpoints.of(context).smallerThan(TABLET)
        //     ? ResponsiveRowColumnType.COLUMN
        //     : ResponsiveRowColumnType.ROW,
        layout: ResponsiveRowColumnType.COLUMN,
        rowSpacing: 100,
        columnSpacing: 20,
        children: [
          ResponsiveRowColumnItem(
            rowFlex: 2,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // image: DecorationImage(
                    //   image: AssetImage("assets/images/BG_Login.png"),
                    //   fit: BoxFit.cover,
                    // ),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blueAccent,
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 0,
                  child: Container(
                    child: IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
                Column(
                  children: [
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: const CircleAvatar(
                              radius: 46,
                              //backgroundImage: AssetImage("assets/profile.jpg"),
                              backgroundColor: Colors.blueGrey,
                            ),
                          ),

                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey,
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  print("Ganti foto profil diklik");
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      child: Text(
                        "Nama",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ptSerif(
                          textStyle: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),

                    Container(
                      child: Text(
                        "Headline1|Headline2|Headline3",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ptSerif(
                          textStyle: TextStyle(
                            color: Colors.white,
                            //letterSpacing: 2,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ResponsiveRowColumnItem(child: Workexperience()),
        ],
      ),
    );
  }
}
