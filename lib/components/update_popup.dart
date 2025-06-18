import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';

class UpdatePopup extends StatefulWidget {
  final bool? reminderButton;

  const UpdatePopup({
    super.key,
    this.reminderButton,
  });

  @override
  State<UpdatePopup> createState() => _UpdatePopupState();
}

class _UpdatePopupState extends State<UpdatePopup> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400.0,
      height: 180.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 12.0,
          ),
          Text(
            "Seus dados estão desatualizados",
            style: TextStylesConstants.kpoppinsSemiBold.merge(const TextStyle(
                fontSize: 18.0, color: ConstantsColors.greyShade900)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 12.0,
          ),
          Text(
            "Complete as suas informações e utilize todas as funcionalidades que <nome do app> tem para lhe oferecer!",
            style: TextStylesConstants.kpoppinsRegular.merge(const TextStyle(
                fontSize: 15.0, color: ConstantsColors.blackShade900)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 18.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: ConstantsColors.blueShade900,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 8.0),
                  minimumSize: const Size(130, 35),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  GoRouter.of(context).go('/editProfilePage');
                },
                child: Text(
                  "Atualizar agora",
                  style: TextStylesConstants.kpoppinsBold.merge(
                    const TextStyle(
                        fontSize: 12.0, color: ConstantsColors.whiteShade900),
                  ),
                ),
              ),
              if (widget.reminderButton ?? true)
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: ConstantsColors.greyShade300,
                    minimumSize: const Size(130, 35),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Me lembre mais tarde",
                    style: TextStylesConstants.kpoppinsRegular.merge(
                      const TextStyle(
                          fontSize: 12.0, color: ConstantsColors.blackShade900),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
