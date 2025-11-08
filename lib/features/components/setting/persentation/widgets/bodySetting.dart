import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_platform/features/components/setting/persentation/widgets/settingGroup.dart';
import 'package:job_platform/features/components/setting/persentation/widgets/settingItem.dart';

class bodySetting extends StatefulWidget {
  final Future<void> Function()? deleteAccount;
  final Future<void> Function()? openPlayStore;
  final Future<void> Function()? logOut;
  final Future<void> Function(bool value)? changeThemeMode;
  final Future<void> Function(String oldEmail, String newEmail)?
  changeEmailAccount;
  final bool? isDarkMode;
  const bodySetting({
    super.key,
    this.deleteAccount,
    this.openPlayStore,
    this.logOut,
    this.changeThemeMode,
    this.changeEmailAccount,
    this.isDarkMode,
  });

  @override
  State<bodySetting> createState() => _bodySetting();
}

class _bodySetting extends State<bodySetting> {
  late bool? isDarkMode;

  void initState() {
    super.initState();
    setState(() {
      isDarkMode = widget.isDarkMode!;
    });
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingsGroup(
          settingsGroupTitle: "App Configuration",
          backgroundColor: Colors.grey.shade100,
          items: [
            SettingsItem(
              onTap: () => context.go("/appearance"),
              icons: CupertinoIcons.pencil_outline,
              title: 'Appearance',
              colorBGIcon: Colors.orangeAccent,
            ),
            SettingsItem(
              icons: Icons.dark_mode_rounded,
              title: 'Dark mode',
              subtitle: "Change theme color application",
              colorBGIcon: Colors.black,
              trailing: Switch.adaptive(
                activeColor: Colors.blue,
                value: isDarkMode!,
                onChanged: (value) async {
                  setState(() {
                    isDarkMode = value;
                  });
                  await widget!.changeThemeMode!(value);
                },
              ),
            ),
            SettingsItem(
              onTap: () => context.go("/setNotification"),
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
              onTap: () => context.go("/upgradeAccount"),
              icons: Icons.star,
              colorBGIcon: Colors.yellow.shade700,
              title: 'Upgrade Account',
              subtitle: "Upgrade to premium",
            ),
            SettingsItem(
              onTap: () => context.go("/settingEmail"),
              icons: Icons.attach_email,
              title: 'Setting Email',
              colorBGIcon: Colors.red,
              subtitle: "Change account email",
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
              onTap: widget.openPlayStore!,
              icons: Icons.insert_chart,
              title: 'Send Feedback',
              colorBGIcon: Colors.orange,
              subtitle: "Help us improve Skillen",
            ),
            SettingsItem(
              onTap: widget.openPlayStore!,
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
              onTap: widget.logOut,
              icons: Icons.exit_to_app_rounded,
              colorBGIcon: Colors.redAccent,
              title: "Sign Out",
            ),
            SettingsItem(
              onTap: widget.deleteAccount,
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
