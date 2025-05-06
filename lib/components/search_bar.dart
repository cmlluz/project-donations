import 'package:flutter/material.dart';

class Searchbar extends StatelessWidget {
  const Searchbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
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
                suffixIcon: Icon(
                  Icons.search,
                  color: const Color.fromARGB(213, 0, 0, 0).withOpacity(.6),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
