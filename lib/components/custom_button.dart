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
        child: Text(
          widget.text,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: ConstantsColors.LetterColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
