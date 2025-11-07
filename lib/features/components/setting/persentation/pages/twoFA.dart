import 'package:flutter/widgets.dart';

class Twofa extends StatefulWidget {
  final Future<void> Function(bool isActive)? change2FA;
  final Future<void> Function(bool isActive, String OTP)? validate2FA;
  final bool? is2FA;
  const Twofa({super.key, this.change2FA, this.is2FA, this.validate2FA});

  @override
  State<Twofa> createState() => _Twofa();
}

class _Twofa extends State<Twofa> {}
