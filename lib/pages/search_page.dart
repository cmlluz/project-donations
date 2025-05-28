import 'package:appdonationsgestor/components/image_card.dart';
import 'package:appdonationsgestor/components/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(top: 50.0, bottom: 20.0, left: 10.0),
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
                Expanded(
                  child: Searchbar(),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return const Column(
                    children: [
                      ImageCard(),
                      SizedBox(height: 16.0),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
