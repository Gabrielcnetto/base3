import 'package:easebase/rotas/Approutes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easebase/usuarioDeslogado/screen/home/homeScreen01.dart';

class VerificationLoginScreen01 extends StatelessWidget {
  const VerificationLoginScreen01({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, snpshot) {
        if (snpshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snpshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushNamed(AppRoutesApp.HomeScreen01);
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            //Navigator.of(context).pushNamed(AppRoutesApp.InitialScreenApp);
            Navigator.of(context).push(
              DialogRoute(
                context: context,
                builder: (ctx) => const HomeScreen01Deslogado(
                  selectedIndex: 0,
                ),
              ),
            );
          });
        }
        return Container();
      },
    );
  }
}
