import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:flutter/services.dart';

class CustomTextFields extends StatefulWidget {
  final IconData icon;
  final String? label;
  final bool secret;
  final Color? labelColor;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? maxLines;
  final int? maxLength;
  final double? height;
  final String? hintText;
  final InputBorder? border;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextFields({
    super.key,
    required this.icon,
    this.label,
    this.secret = false,
    this.labelColor,
    this.controller,
    this.keyboardType,
    this.validator,
    this.maxLines,
    this.maxLength,
    this.height,
    this.hintText,
    this.border,
    this.inputFormatters,
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
        height: widget.height,
        child: TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: hide,
          validator: widget.validator,
          maxLines: widget.maxLines ?? 1,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          style: TextStylesConstants.kcustomTextField,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                width: 1.5,
                color: ConstantsColors.blueShade900,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                width: 2,
                color: ConstantsColors.blueShade900,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                width: 2,
                color: ConstantsColors.redShade900,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                width: 2.5,
                color: ConstantsColors.redShade900,
              ),
            ),
            filled: true,
            fillColor: widget.labelColor ?? ConstantsColors.whiteShade700,
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
            hintStyle: const TextStyle(
              fontSize: 16,
              color: ConstantsColors.blackShade700,
            ),
          ),
        ),
      ),
    );
  }
}