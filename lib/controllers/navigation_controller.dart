import 'package:flutter/material.dart';

class NavigationController {
  static final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);
  static final ValueNotifier<int> postsRefreshToken = ValueNotifier<int>(0);

  static void resetIndex() {
    currentIndex.value = 0;
  }
}
