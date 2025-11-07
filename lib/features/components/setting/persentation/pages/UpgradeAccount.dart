import 'package:flutter/widgets.dart';

class Upgradeaccount extends StatefulWidget {
  final Future<void> Function()? upgradePlan;
  final bool? isPremium;
  const Upgradeaccount({super.key, this.upgradePlan, this.isPremium});

  @override
  State<Upgradeaccount> createState() => _Upgradeaccount();
}

class _Upgradeaccount extends State<Upgradeaccount> {}
