import 'package:flavory/auth.dart';
import 'package:flavory/pages/dashboard.dart';
import 'package:flavory/pages/details.dart';
import 'package:flavory/pages/home_page.dart';
import 'package:flavory/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:flavory/pages/landing_page.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Dashboard();
          } else {
            return OnboardingPage1();
          }
        });
  }
}