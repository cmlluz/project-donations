import 'package:appdonationsgestor/components/custom_button.dart';
import 'package:appdonationsgestor/components/custom_text_field.dart';
import 'package:appdonationsgestor/controllers/product_registration_controller.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ItemEditPage extends StatefulWidget {
  const ItemEditPage({Key? key}) : super(key: key);

  @override
  State<ItemEditPage> createState() => _ItemEditPageState();
}

class _ItemEditPageState extends State<ItemEditPage> {
  final ProductRegistrationController _controller =
      ProductRegistrationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).pop(),
        ),
        title: Text(
          // fazer o titulo ser adaptável a partir do back
          'Editar necessidade/doação',
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
          color: ConstantsColors.whiteShade700,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(35),
          ),
        ),
        padding: const EdgeInsets.all(30.0),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: DonationItemComponent(
            productRegistrationController: _controller,
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
        productRegistrationController.itemQtdValue,
      ]),
      builder: (_, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Descrição', textAlign: TextAlign.start),
            ),
            const SizedBox(height: 10),
            CustomTextFields(
              icon: Icons.edit_document,
              secret: false,
              controller: productRegistrationController.crtlDesc,
              keyboardType: TextInputType.multiline,
              labelColor: ConstantsColors.whiteShade700,
            ),
            const SizedBox(height: 20),
            const Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Categoria'),
                ),
                SizedBox(width: 165),
                Text('Quantidade'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomDropDownButtonComponent(
                  selected:
                      productRegistrationController.selectedValueCategory.value,
                  items: productRegistrationController.category,
                  color: ConstantsColors.whiteShade700,
                  onChanged: (item) =>
                      productRegistrationController.selectedItemCategory = item,
                ),
                const SizedBox(width: 40),
                Flexible(
                  child: CustomTextFields(
                    icon: Icons.numbers,
                    secret: false,
                    controller: productRegistrationController.crtlQtd,
                    keyboardType: TextInputType.number,
                    labelColor: ConstantsColors.whiteShade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Center(
              child: CustomButton(
                height: 45,
                width: 240,
                text: 'Salvar',
                color: ConstantsColors.blueShade900,
                textColor: ConstantsColors.whiteShade900,
                onPressed: () {},
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
  final String? hint;
  final Color? color;
  final void Function(String?)? onChanged;

  const CustomDropDownButtonComponent({
    Key? key,
    required this.selected,
    required this.items,
    required this.onChanged,
    this.hint,
    this.color = ConstantsColors.greyShade200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ConstantsColors.blueShade900),
      ),
      child: DropdownButton<String?>(
        icon: const Icon(
          Icons.keyboard_arrow_down_sharp,
          color: ConstantsColors.blueShade900,
        ),
        value: selected,
        hint: hint != null
            ? Text(
                hint!,
                style: const TextStyle(
                  fontSize: 16,
                  color: ConstantsColors.blueShade900,
                ),
              )
            : null,
        borderRadius: BorderRadius.circular(12),
        dropdownColor: ConstantsColors.whiteShade700,
        items: items
            .map((item) => DropdownMenuItem<String?>(
                  value: item,
                  child: Text(
                    item!,
                    style: const TextStyle(
                      fontSize: 18,
                      color: ConstantsColors.blueShade900,
                    ),
                  ),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
