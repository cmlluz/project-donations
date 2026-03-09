import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';

class CampaignDataPage extends StatelessWidget {
  final String title;
  final String startDate;
  final String endDate;
  final List<String> interestedPeople;

  const CampaignDataPage({
    super.key,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.interestedPeople,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).pop(),
        ),
        title: Text(
          'Dados da Campanha',
          style: TextStylesConstants.kformularyTitle,
        ),
        backgroundColor: ConstantsColors.blueShade900,
        foregroundColor: ConstantsColors.whiteShade900,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: ConstantsColors.blueShade900,
      body: Container(
        decoration: const BoxDecoration(
          color: ConstantsColors.whiteShade700,
          borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
        ),
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Text(
                "Título da Campanha:",
                style: TextStylesConstants.kpoppinsSemiBold.merge(
                  const TextStyle(
                    fontSize: 16,
                    color: ConstantsColors.blueShade900,
                  ),
                ),
              ),
              const SizedBox(height: 6),

              Text(
                title,
                style: TextStylesConstants.kpoppinsMedium.merge(
                  const TextStyle(
                    fontSize: 15,
                    color: ConstantsColors.greyShade600,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Text(
                "Período da Campanha:",
                style: TextStylesConstants.kpoppinsSemiBold.merge(
                  const TextStyle(
                    fontSize: 16,
                    color: ConstantsColors.blueShade900,
                  ),
                ),
              ),
              const SizedBox(height: 6),

              Text(
                "$startDate  →  $endDate",
                style: TextStylesConstants.kpoppinsMedium.merge(
                  const TextStyle(
                    fontSize: 15,
                    color: ConstantsColors.greyShade600,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Text(
                "Pessoas interessadas:",
                style: TextStylesConstants.kpoppinsSemiBold.merge(
                  const TextStyle(
                    fontSize: 16,
                    color: ConstantsColors.blueShade900,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              if (interestedPeople.isEmpty)
                Text(
                  "Nenhuma pessoa demonstrou interesse ainda.",
                  style: TextStylesConstants.kpoppinsMedium.merge(
                    const TextStyle(
                      fontSize: 15,
                      color: ConstantsColors.greyShade600,
                    ),
                  ),
                )
              else
                Column(
                  children: interestedPeople.map((name) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 15),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: ConstantsColors.whiteShade900,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        name,
                        style: TextStylesConstants.kpoppinsMedium.merge(
                          const TextStyle(
                            fontSize: 15,
                            color: ConstantsColors.greyShade800,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
