import 'package:easebase/classes/Estabelecimento.dart';
import 'package:flutter/material.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
        final widhScren = MediaQuery.of(context).size.width;
    final heighScreen = MediaQuery.of(context).size.height;
    return Container(
      width: widhScren,
      height: heighScreen,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            child: Container(
              width: widhScren,
              height: 180,
              child: Image.asset(
                Estabelecimento.bannerAgendamento,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(50, 50),
                  topRight: Radius.elliptical(50, 50),
                ),
              ),
              width: widhScren,
              height: heighScreen / 1.35,
              child: const SingleChildScrollView(
                child: Column(
                  children: [],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}