import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:flutter/material.dart';

class CustomDropDownButtonComponent extends StatelessWidget {
  // DEPOIS EXTRAIR PARA OUTRO FILE
  final String? selected;
  final List<String?> items;
  final String? hint;
  final Color? color;
  final void Function(String?)? onChanged;

  const CustomDropDownButtonComponent({
    // DEPOIS EXTRAIR PARA OUTRO FILE
    super.key,
    required this.selected,
    required this.items,
    required this.onChanged,
    this.hint,
    this.color = ConstantsColors.greyShade200,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ConstantsColors.blueShade900)),
      child: DropdownButton<String?>(
        icon: const Icon(
          Icons.keyboard_arrow_down_sharp,
          color: ConstantsColors.blueShade900,
        ),
        value: selected,
        hint: hint != null
            ? Text(hint!,
                style: const TextStyle(
                    fontSize: 16, color: ConstantsColors.blueShade900))
            : null,
        borderRadius: BorderRadius.circular(12),
        dropdownColor: ConstantsColors.whiteShade700,
        items: items
            .map((item) => DropdownMenuItem<String?>(
                  value: item,
                  child: Text(
                    item!,
                    style: const TextStyle(
                        fontSize: 18, color: ConstantsColors.blueShade900),
                  ),
                ))
            .toList(),
        onChanged: onChanged,
        underline: Container(),
      ),
    );
  }
}
