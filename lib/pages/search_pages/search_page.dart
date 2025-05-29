import 'package:appdonationsgestor/components/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:go_router/go_router.dart';

import 'package:appdonationsgestor/pages/search_pages/filter_pages/todos_page.dart';
import 'package:appdonationsgestor/pages/search_pages/filter_pages/doacao_page.dart';
import 'package:appdonationsgestor/pages/search_pages/filter_pages/necessidade_page.dart';
import 'package:appdonationsgestor/pages/search_pages/filter_pages/instituicao_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String selectedButton = 'Todos';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 10.0, right: 10.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      top: 60.0, bottom: 30.0, left: 10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Olá, Name 👋',
                      style: const TextStyle(
                        color: ConstantsColors.greyShade900,
                        fontSize: 30,
                      ).merge(TextStylesConstants.kpoppinsBold),
                    ),
                  ),
                ),
                const Row(
                  children: [
                    Expanded(child: Searchbar()),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildSelectableButton('Todos'),
                    const SizedBox(width: 15),
                    buildSelectableButton('Doação'),
                    const SizedBox(width: 15),
                    buildSelectableButton('Necessidade'),
                    const SizedBox(width: 15),
                    buildSelectableButton('Instituição'),
                  ],
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  height: constraints.maxHeight - 260,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(2.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 15.0,
                      childAspectRatio: 1,
                    ),
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            'Item ${index + 1}',
                            style: const TextStyle(
                              color: ConstantsColors.greyShade900,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildSelectableButton(String label) {
    final bool isSelected = selectedButton == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedButton = label;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? ConstantsColors.blueShade900
                  : Colors.transparent,
              width: 2.0,
            ),
          ),
        ),
        padding: const EdgeInsets.only(bottom: 4.0),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? ConstantsColors.blueShade900
                : ConstantsColors.blackShade700,
            fontSize: 14,
          ).merge(TextStylesConstants.krobotoBold),
        ),
      ),
    );
  }
}
