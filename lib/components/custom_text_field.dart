import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';

class CustomTextFields extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool secret;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  const CustomTextFields({
    Key? key,
    required this.icon,
    required this.label,
    this.secret = false,
    this.controller,
    this.keyboardType,
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
          fillColor: ConstantsColors.whiteShade900,
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
        ),
      ),
    );
  }
}
