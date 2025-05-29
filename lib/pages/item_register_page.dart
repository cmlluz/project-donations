import 'package:appdonationsgestor/components/custom_text_field.dart';
import 'package:appdonationsgestor/components/rounded_background_component.dart';
import 'package:appdonationsgestor/controllers/product_registration_controller.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/components/custom_button.dart';

class ItemRegisterPage extends StatelessWidget {
  ItemRegisterPage({Key? key}) : super(key: key);

  final ProductRegistrationController _controller =
      ProductRegistrationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).go('/popupMenuState');
          },
        ),
        title: const Text(
          'Criar nova necessidade',
          style: TextStylesConstants.kformularyTitle,
        ),
        backgroundColor: ConstantsColors.blueShade900,
        foregroundColor: ConstantsColors.whiteShade900,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: ConstantsColors.blueShade900,
      body: Container(
        decoration: const BoxDecoration(
          color: ConstantsColors.whiteShade900,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(35),
          ),
        ),
        child: RoundedBackgroundComponent(
          height: MediaQuery.of(context).size.height * 0.02,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DonationItemComponent(
                    productRegistrationController: _controller,
                  ),
                  const Row(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DonationItemComponent extends StatelessWidget {
  final ProductRegistrationController productRegistrationController;

  const DonationItemComponent({
    Key? key,
    required this.productRegistrationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        productRegistrationController.selectedValueCategory,
        productRegistrationController.itemQtdValue
      ]),
      builder: (_, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nome do produto'),
            CustomTextFields(
              icon: Icons.label,
              label: 'Produto',
              secret: false,
              controller: productRegistrationController.crtlItemName,
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 20),
            const Text('Descrição'),
            CustomTextFields(
              icon: Icons.edit_document,
              label: 'Descrição',
              secret: false,
              controller: productRegistrationController.crtlDesc,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 20),
            const Text('Categoria e Quantidade'),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: CustomDropDownButtonComponent(
                    selected: productRegistrationController
                        .selectedValueCategory.value,
                    items: productRegistrationController.category,
                    hint: 'Selecione uma opção',
                    onChanged: (item) => productRegistrationController
                        .selectedItemCategory = item,
                  ),
                ),
                Flexible(
                  child: CustomTextFields(
                    icon: Icons.label,
                    label: 'Quantidade',
                    secret: false,
                    controller: productRegistrationController.crtlQtd,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 180.0),
                child: CustomButton(
                  height: 50,
                  width: 200,
                  text: 'Publicar',
                  route: '/root',
                  color: ConstantsColors.blueShade900,
                  textColor: ConstantsColors.whiteShade900,
                  hasMensage: true,
                  mensage: 'Publicado com sucesso!',
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CustomDropDownButtonComponent extends StatelessWidget {
  final String? selected;
  final List<String?> items;
  final String hint;
  final void Function(String?)? onChanged;

  const CustomDropDownButtonComponent({
    Key? key,
    required this.selected,
    required this.items,
    required this.onChanged,
    required this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String?>(
      value: selected,
      hint: Text(hint),
      items: items
          .map((item) => DropdownMenuItem<String?>(
                value: item,
                child: Text(
                  item!,
                  style: const TextStyle(fontSize: 24),
                ),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
