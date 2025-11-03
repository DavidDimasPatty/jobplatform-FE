import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_platform/features/components/login/persentation/pages/login.dart';
import 'package:job_platform/features/components/setting/persentation/widgets/settingGroup.dart';
import 'package:job_platform/features/components/setting/persentation/widgets/settingItem.dart';
import 'package:url_launcher/url_launcher.dart';

class bodySetting extends StatelessWidget {
  final String? packageName;
  bodySetting(this.packageName);

  Future<void> openPlayStore(String packageName) async {
    final Uri androidUri = Uri.parse('market://details?id=$packageName');
    final Uri webUri = Uri.parse(
      'https://play.google.com/store/apps/details?id=$packageName',
    );

    try {
      if (await canLaunchUrl(androidUri)) {
        await launchUrl(androidUri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }

  Widget build(BuildContext context) {
    var mediaQueryHeight = MediaQuery.of(context).size.height;
    return Column(
      //onTap: onTap,
      children: [
        SettingsGroup(
          settingsGroupTitle: "App Configuration",
          backgroundColor: Colors.grey.shade100,
          items: [
            SettingsItem(
              onTap: () {},
              icons: CupertinoIcons.pencil_outline,
              title: 'Appearance',
              colorBGIcon: Colors.orangeAccent,
            ),
            SettingsItem(
              onTap: () {},
              icons: Icons.dark_mode_rounded,
              title: 'Dark mode',
              subtitle: "Automatic",
              colorBGIcon: Colors.black,
              trailing: Switch.adaptive(value: false, onChanged: (value) {}),
            ),
            SettingsItem(
              onTap: () {},
              icons: Icons.notifications_active_sharp,
              colorBGIcon: Colors.green,
              title: 'Setting Notification',
            ),
          ],
        ),

        SettingsGroup(
          settingsGroupTitle: "Account Configuration",
          backgroundColor: Colors.grey.shade100,
          items: [
            SettingsItem(
              onTap: () {},
              icons: Icons.star,
              colorBGIcon: Colors.yellow.shade700,
              title: 'Upgrade Account',
              subtitle: "Upgrade to premium",
            ),
            SettingsItem(
              onTap: () {},
              icons: Icons.attach_email,
              title: 'Setting Email',
              colorBGIcon: Colors.red,
              subtitle: "Change account email",
            ),

            SettingsItem(
              onTap: () {},
              icons: Icons.security,
              title: '2FA',
              colorBGIcon: Colors.indigo,
              subtitle: "Add 2 Factor Authentication",
            ),
          ],
        ),

        SettingsGroup(
          settingsGroupTitle: "Information Center",
          backgroundColor: Colors.grey.shade100,
          items: [
            SettingsItem(
              onTap: () => context.go("/aboutUs"),
              icons: Icons.info_rounded,
              colorBGIcon: Colors.blue.shade400,
              title: 'About',
              subtitle: "Learn more about Skillen",
            ),
            SettingsItem(
              onTap: () => context.go("/faq"),
              icons: Icons.question_answer,
              colorBGIcon: Colors.blue.shade400,
              title: 'FAQ',
              subtitle: "Frequent Asked Questions",
            ),
            SettingsItem(
              onTap: () => context.go("/tos"),
              icons: Icons.design_services_rounded,
              colorBGIcon: Colors.blue.shade400,
              title: 'Terms Of Service',
              subtitle: "See our guidelines",
            ),
          ],
        ),

        SettingsGroup(
          backgroundColor: Colors.grey.shade100,
          items: [
            SettingsItem(
              onTap: () => openPlayStore(packageName!),
              icons: Icons.insert_chart,
              title: 'Send Feedback',
              colorBGIcon: Colors.orange,
              subtitle: "Help us improve Skillen",
            ),
            SettingsItem(
              onTap: () => openPlayStore(packageName!),
              icons: Icons.favorite_outlined,
              colorIcon: Colors.red,
              colorBGIcon: Colors.white,
              title: 'Rate Us',
            ),
          ],
        ),
        SettingsGroup(
          backgroundColor: Colors.grey.shade100,
          items: [
            SettingsItem(
              onTap: () {
                context.pushReplacement("/login");
              },
              icons: Icons.exit_to_app_rounded,
              colorBGIcon: Colors.redAccent,
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

  //FAQ
  //Upgrade plan
  //Setting notif
  //2FA
  //Setting email