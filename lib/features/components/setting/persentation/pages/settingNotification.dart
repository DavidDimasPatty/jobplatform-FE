import 'package:flutter/widgets.dart';

class Settingnotification extends StatefulWidget {
  final Future<void> Function()? changeNotifApp;
  final Future<void> Function()? changeExternalNotifApp;
  final bool? isNotifInternal;
  final bool? isNotifExternal;
  const Settingnotification({
    super.key,
    this.changeNotifApp,
    this.changeExternalNotifApp,
    this.isNotifInternal,
    this.isNotifExternal,
  });

  @override
  State<Settingnotification> createState() => _Settingnotification();
}

class _Settingnotification extends State<Settingnotification> {}
