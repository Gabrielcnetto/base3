import 'package:flutter/material.dart';
import 'package:easebase/normalUsersHome/screen/profile/profilescreencomponents/ScreenMyProfileConfigs.dart';


class ProfileScreenManagerWithScafol extends StatelessWidget {
  const ProfileScreenManagerWithScafol({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: ScreenComponentsMyProfile(),
      ),
    );
  }
}
