import 'package:flutter/widgets.dart';

class Validate2fa extends StatefulWidget {
  final Future<void> Function(bool isActive, String OTP)? validate2FA;
  final bool? isActive;
  const Validate2fa({super.key, this.isActive, this.validate2FA});

  @override
  State<Validate2fa> createState() => _Validate2fa();
}

class _Validate2fa extends State<Validate2fa> {}
