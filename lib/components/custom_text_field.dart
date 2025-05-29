import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';

class CustomTextFields extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool secret;
  final Color? labelColor;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? maxLines;
  final String? hintText;

  const CustomTextFields({
    Key? key,
    required this.icon,
    required this.label,
    this.secret = false,
    this.labelColor,
    this.controller,
    this.keyboardType,
    this.maxLines,
    this.hintText,
  }) : super(key: key);

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

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: hide,
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none),
          ),
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            fontSize: 16,
            color: Color.fromARGB(255, 150, 150, 150),
          ),
        ),
      ),
    );
  }
}
