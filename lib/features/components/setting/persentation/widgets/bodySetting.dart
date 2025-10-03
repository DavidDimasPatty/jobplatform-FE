import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:job_platform/features/components/setting/persentation/widgets/settingGroup.dart';
import 'package:job_platform/features/components/setting/persentation/widgets/settingItem.dart';

class bodySetting extends StatelessWidget {
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
    return Column(
      //onTap: onTap,
      children: [
        SettingsGroup(
          settingsGroupTitle: "Pengaturan Aplikasi",
          backgroundColor: Colors.grey.shade100,
          items: [
            SettingsItem(
              onTap: () {},
              icons: CupertinoIcons.pencil_outline,
              //iconStyle: IconStyle(),
              title: 'Appearance',
              //subtitle: "",
            ),
            SettingsItem(
              onTap: () {},
              icons: Icons.dark_mode_rounded,
              //iconStyle: IconStyle(
              //   iconsColor: Colors.white,
              //   withBackground: true,
              //   backgroundColor: Colors.red,
              // ),
              title: 'Dark mode',
              subtitle: "Automatic",
              trailing: Switch.adaptive(value: false, onChanged: (value) {}),
            ),
          ],
        ),
        SettingsGroup(
          // settingsGroupTitle: "Pengaturan Aplikasi",
          backgroundColor: Colors.grey.shade100,
          items: [
            SettingsItem(
              onTap: () {},
              icons: Icons.info_rounded,
              title: 'About',
              subtitle: "Learn more about Skillen",
            ),
          ],
        ),

        SettingsGroup(
          // settingsGroupTitle: "Pengaturan Aplikasi",
          backgroundColor: Colors.grey.shade100,
          items: [
            SettingsItem(
              onTap: () {},
              icons: Icons.terminal,
              title: 'Terms Of Service',
            ),
          ],
        ),
        SettingsGroup(
          // settingsGroupTitle: "Pengaturan Aplikasi",
          backgroundColor: Colors.grey.shade100,
          items: [
            SettingsItem(
              onTap: () {},
              icons: Icons.insert_chart,
              title: 'Send Feedback',
              subtitle: "Help us improve Skillen",
            ),
            SettingsItem(
              onTap: () {},
              icons: Icons.star,
              title: 'Rate Us',
              //subtitle: "Help us improve Skillen",
            ),
          ],
        ),
        SettingsGroup(
          backgroundColor: Colors.grey.shade100,
          settingsGroupTitle: "Account",
          items: [
            SettingsItem(
              onTap: () {},
              icons: Icons.exit_to_app_rounded,
              title: "Sign Out",
            ),
            SettingsItem(
              onTap: () {},
              icons: CupertinoIcons.delete_solid,
              title: "Delete account",
              colorBGIcon: Colors.red,
              titleStyle: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
