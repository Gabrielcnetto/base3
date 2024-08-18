import 'package:flutter/material.dart';

import 'profilescreencomponents/ScreenMyProfileConfigs.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(child: ScreenComponentsMyProfile());
  }
}
