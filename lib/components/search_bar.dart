import 'package:flutter/material.dart';
import '../resources/constant_colors.dart';

class Searchbar extends StatelessWidget {
  const Searchbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE0E0E0), width: 2.0),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'O que você busca?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color.fromARGB(17, 238, 238, 238),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                suffixIcon: const Icon(
                  Icons.search,
                  color: ConstantsColors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
