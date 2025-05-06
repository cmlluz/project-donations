import 'package:appdonationsgestor/components/image_card.dart';
import 'package:appdonationsgestor/components/search_bar.dart';
import 'package:flutter/material.dart';

class InstitutionPage extends StatefulWidget {
  const InstitutionPage({Key? key}) : super(key: key);

  @override
  State<InstitutionPage> createState() => _InstitutionPageState();
}

class _InstitutionPageState extends State<InstitutionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
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
                  return Column(
                    children: const [
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
