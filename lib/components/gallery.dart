import 'package:flutter/material.dart';

class GalleryList extends StatefulWidget {
  const GalleryList({super.key});

  @override
  State<GalleryList> createState() => _GalleryListState();
}

List<String> imageUrls = [
  'https://placeimg.com/640/480/animals',
  'https://placeimg.com/640/480/arch',
  'https://placeimg.com/640/480/nature',
  'https://placeimg.com/640/480/people',
  'https://placeimg.com/640/480/tech',
  'https://placeimg.com/640/480/animals',
  'https://placeimg.com/640/480/arch',
  'https://placeimg.com/640/480/nature',
  'https://placeimg.com/640/480/people',
  'https://placeimg.com/640/480/tech',
  'https://placeimg.com/640/480/nature',
  'https://placeimg.com/640/480/people',
  'https://placeimg.com/640/480/tech',
  'https://placeimg.com/640/480/animals',
  'https://placeimg.com/640/480/arch',
  'https://placeimg.com/640/480/nature',
  'https://placeimg.com/640/480/people',
];

class _GalleryListState extends State<GalleryList> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 0.5,
        shrinkWrap: true,
        children: [ListTile()]);
  }
}
