import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:go_router/go_router.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final String route;
  const CustomButton({super.key, required this.text, required this.route});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 300,
      child: ElevatedButton(
        onPressed: () {
          if (widget.route != null) {
            GoRouter.of(context).go(widget.route);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No route provided')),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ConstantsColors.blueShade900,
          foregroundColor: ConstantsColors.whiteShade900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Text(
          widget.text,
          style: TextStylesConstants.kcustomButtonText,
        ),
      ),
    );
  }
}
