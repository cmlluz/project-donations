import 'package:flutter/widgets.dart';

class PostController {
  final _crtlDesc = TextEditingController();
  final _crtlPic = TextEditingController();

  TextEditingController get crtlDesc => _crtlDesc;
  TextEditingController get crtlPic => _crtlPic;
}
