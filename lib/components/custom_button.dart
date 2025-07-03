import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:go_router/go_router.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final String route;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final bool? hasMensage;
  final String? mensage;
  const CustomButton(
      {super.key,
      required this.text,
      required this.route,
      this.color,
      this.textColor,
      this.width,
      this.height,
      this.fontSize,
      this.hasMensage = false,
      this.mensage});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: ElevatedButton(
        onPressed: () {
          if (widget.route.isNotEmpty && widget.hasMensage == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  backgroundColor: ConstantsColors.blueShade900,
                  behavior: SnackBarBehavior.floating,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  content: Text(widget.mensage ?? '')),
            );
            GoRouter.of(context).go(widget.route);
          } else if (widget.route.isNotEmpty && widget.hasMensage == false) {
            GoRouter.of(context).go(widget.route);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No route provided')),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.color ?? ConstantsColors.blueShade900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        child: Text(
          widget.text,
          style: TextStyle(
            color: widget.textColor ?? Colors.white,
            fontSize: widget.fontSize ?? 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
