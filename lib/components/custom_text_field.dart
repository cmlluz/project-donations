import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';

class CustomTextFields extends StatefulWidget {
  final IconData icon;
  final String? label;
  final bool secret;
  final Color? labelColor;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? maxLength; // NOVO
  final double? height; // NOVO
  final String? hintText;
  final InputBorder? border; // NOVO

  const CustomTextFields({
    super.key,
    required this.icon,
    this.label,
    this.secret = false,
    this.labelColor,
    this.controller,
    this.keyboardType,
    this.maxLines,
    this.maxLength,
    this.height,
    this.hintText,
    this.border,
  });

  @override
  State<CustomTextFields> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextFields> {
  bool hide = false;

  @override
  void initState() {
    super.initState();
    hide = widget.secret;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: SizedBox(
        height: widget.height, // aplica altura se fornecida
        child: TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: hide,
          maxLines: widget.maxLines ?? 1,
          maxLength: widget.maxLength,
          style: TextStylesConstants.kcustomTextField,
          decoration: InputDecoration(
            filled: true,
            fillColor: widget.labelColor ?? ConstantsColors.whiteShade900,
            prefixIcon: Icon(widget.icon),
            suffixIcon: widget.secret
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        hide = !hide;
                      });
                    },
                    icon: Icon(hide ? Icons.visibility : Icons.visibility_off),
                  )
                : null,
            labelText: widget.label,
            isDense: true,
            hintText: widget.hintText,
            border: widget.border ?? OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(width: 0, style: BorderStyle.none),
            ),
            hintStyle: const TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 150, 150, 150),
            ),
          ),
        ),
      ),
    );
  }
}
