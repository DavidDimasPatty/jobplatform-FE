import 'package:flutter/widgets.dart';

class Settingemail extends StatefulWidget {
  final Future<void> Function(String newEmail)? changeEmailAccount;
  const Settingemail({super.key, this.changeEmailAccount});

  @override
  State<Settingemail> createState() => _Settingemail();
}

class _Settingemail extends State<Settingemail> {}
