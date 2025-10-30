import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';

class Popup extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? confirmText;
  final String? cancelText;
  final bool reminderButton;
  final Color? confirmButtonColor;

  const Popup({
    super.key,
    this.title,
    this.subtitle,
    this.confirmText,
    this.cancelText,
    this.reminderButton = true,
    this.confirmButtonColor,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: ConstantsColors.blueShade400,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          width: size.width * 0.8,
          constraints: const BoxConstraints(
            maxWidth: 500,
            minHeight: 180,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (title != null) ...[
                const SizedBox(height: 12.0),
                Text(
                  title!,
                  style: TextStylesConstants.kpoppinsSemiBold.merge(
                    const TextStyle(
                      fontSize: 18.0,
                      color: ConstantsColors.greyShade900,
                    ),
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
                      fontSize: 15.0,
                      color: ConstantsColors.blackShade900,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 18.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (confirmText != null)
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: confirmButtonColor ??
                              ConstantsColors.blueShade900,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 10.0,
                          ),
                          minimumSize: const Size(0, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          overlayColor: Colors.transparent,
                          foregroundColor: Colors.transparent,
                        ).copyWith(
                          side: WidgetStateProperty.all(BorderSide.none),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text(
                          confirmText!,
                          style: TextStylesConstants.kpoppinsBold.merge(
                            const TextStyle(
                              fontSize: 13.0,
                              color: ConstantsColors.whiteShade900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (reminderButton && cancelText != null) ...[
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: ConstantsColors.greyShade300,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 10.0,
                          ),
                          minimumSize: const Size(0, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          foregroundColor: ConstantsColors.blackShade900,
                          overlayColor: Colors.transparent,
                        ),
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(
                          cancelText!,
                          style: TextStylesConstants.kpoppinsRegular.merge(
                            const TextStyle(
                              fontSize: 13.0,
                              color: ConstantsColors.blackShade900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
