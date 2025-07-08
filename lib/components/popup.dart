import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';

class Popup extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? confirmText;
  final String? cancelText;
  final String? confirmRoute;
  final bool reminderButton;

  const Popup({
    super.key,
    this.title,
    this.subtitle,
    this.confirmText,
    this.cancelText,
    this.confirmRoute,
    this.reminderButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400.0,
      height: 180.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (title != null) ...[
            const SizedBox(height: 12.0),
            Text(
              title!,
              style: TextStylesConstants.kpoppinsSemiBold.merge(
                const TextStyle(
                    fontSize: 18.0, color: ConstantsColors.greyShade900),
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (subtitle != null) ...[
            const SizedBox(height: 12.0),
            Text(
              subtitle!,
              style: TextStylesConstants.kpoppinsRegular.merge(
                const TextStyle(
                    fontSize: 15.0, color: ConstantsColors.blackShade900),
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 18.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (confirmText != null && confirmRoute != null)
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
                    GoRouter.of(context).go(confirmRoute!);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    confirmText!,
                    style: TextStylesConstants.kpoppinsBold.merge(
                      const TextStyle(
                          fontSize: 12.0, color: ConstantsColors.whiteShade900),
                    ),
                  ),
                ),
              if (reminderButton && cancelText != null)
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
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    cancelText!,
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
