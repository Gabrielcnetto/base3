import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easebase/functions/cupomProvider.dart';
import 'package:easebase/normalUsersHome/screen/home/points_rewards/components/componentsRewards.dart';

class GeralViewRewardsUser extends StatelessWidget {
  const GeralViewRewardsUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
      child: Container(
        width: MediaQuery.of(context).size.width * 1,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.black),
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.73,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.73,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Opacity(
                  opacity: 0.2,
                  child: Image.asset(
                    "imagesOfApp/bannerInitital.jpeg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // CONTAINER DAS INFORMAÇOES - INICIO
            Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.73,
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: const ComponentDataRewards(),
            ),
            // CONTAINER DAS INFORMAÇOES - FIM
          ],
        ),
      ),
    );
  }
}
