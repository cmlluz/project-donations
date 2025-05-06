import 'package:flutter/widgets.dart';

class ProductRegistrationController {
  final _crtlQtd = TextEditingController();
  final _crtlItemName = TextEditingController();
  final _crtlDesc = TextEditingController();

  List<String> category = [
    'Vestuário',
    'Construção Civil',
    'Não Perecíveis',
    'Perecíveis'
  ];

  ValueNotifier<String?> selectedValueCategory = ValueNotifier<String?>(null);

  ValueNotifier<int> itemQtdValue = ValueNotifier<int>(0);

  set selectedItemCategory(String? item) => selectedValueCategory.value = item;

  set itemQtd(int qtd) => itemQtdValue.value = qtd;

  String? get selectedItemCategory => selectedValueCategory.value;

  int get itemQtd => itemQtdValue.value;

  TextEditingController get crtlQtd => _crtlQtd;
  TextEditingController get crtlItemName => _crtlItemName;
  TextEditingController get crtlDesc => _crtlDesc;
}
