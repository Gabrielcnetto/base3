import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../classes/promocao.dart';

class PromotionBannerComponents extends StatelessWidget {
  final double widhtTela;
  const PromotionBannerComponents({
    super.key,
    required this.widhtTela,
  });

  @override
  Widget build(BuildContext context) {
    final List<PromocaoBanner> BannerList = promoBanner;
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Promoções do Mês",
            style: GoogleFonts.openSans(
              textStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: promoBanner.map((banner) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    width: widhtTela * 0.92,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(17),
                      child: Image.network(
                        banner.AssetUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
