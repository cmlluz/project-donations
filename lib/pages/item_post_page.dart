import 'package:appdonationsgestor/components/custom_text_field.dart';
import 'package:appdonationsgestor/controllers/post_type_controller.dart';
import 'package:appdonationsgestor/controllers/product_registration_controller.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/components/custom_button.dart';

class ItemPostPage extends StatelessWidget {
  ItemPostPage({super.key});

  final ProductRegistrationController _controller =
      ProductRegistrationController();
  final PostTypeController _controller1 = PostTypeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).go('/root');
          },
        ),
        title: const Text(
          'Criar novo anúncio',
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DonationItemComponent(
                productRegistrationController: _controller,
                postTypeController: _controller1,
              ),
              const Row(),
            ],
          ),
        ),
      ),
    );
  }
}

class DonationItemComponent extends StatelessWidget {
  final ProductRegistrationController productRegistrationController;
  final PostTypeController postTypeController;

  const DonationItemComponent({
    super.key,
    required this.productRegistrationController,
    required this.postTypeController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        productRegistrationController.selectedValueCategory,
        productRegistrationController.itemQtdValue,
        postTypeController.selectedValueCategory,
        postTypeController.itemQtdValue,
      ]),
      builder: (_, __) {
        return Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Nome do item'),
            ),
            const SizedBox(height: 10),
            CustomTextFields(
              icon: Icons.label,
              secret: false,
              controller: productRegistrationController.crtlItemName,
              keyboardType: TextInputType.name,
              labelColor: ConstantsColors.whiteShade700,
            ),
            const SizedBox(height: 10),
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
                    icon: Icons.label,
                    secret: false,
                    controller: productRegistrationController.crtlQtd,
                    keyboardType: TextInputType.number,
                    labelColor: ConstantsColors.whiteShade700,
                  ),
                ),
              ],
            ),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text('Tipo de divulgação')),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: CustomDropDownButtonComponent(
                selected: postTypeController.selectedValueCategory.value,
                color: ConstantsColors.whiteShade700,
                items: postTypeController.category,
                onChanged: (item) =>
                    postTypeController.selectedPostCategory = item,
              ),
            ),
            const SizedBox(height: 40),
            const CustomButton(
              height: 40,
              width: 150,
              text: 'Publicar',
              route: '/root',
              color: ConstantsColors.blueShade900,
              textColor: ConstantsColors.whiteShade700,
              hasMensage: true,
              mensage: 'Publicado com sucesso!',
            ),
            const SizedBox(height: 10),
            const CustomButton(
              height: 40,
              width: 150,
              text: 'Voltar',
              route: '/root',
              color: ConstantsColors.whiteShade700,
              textColor: ConstantsColors.blueShade900,
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
    super.key,
    required this.selected,
    required this.items,
    required this.onChanged,
    this.hint,
    this.color = ConstantsColors.greyShade200,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ConstantsColors.blueShade900)),
      child: DropdownButton<String?>(
        icon: const Icon(
          Icons.keyboard_arrow_down_sharp,
          color: ConstantsColors.blueShade900,
        ),
        value: selected,
        hint: hint != null
            ? Text(hint!,
                style: const TextStyle(
                    fontSize: 16, color: ConstantsColors.blueShade900))
            : null,
        borderRadius: BorderRadius.circular(12),
        dropdownColor: ConstantsColors.whiteShade700,
        items: items
            .map((item) => DropdownMenuItem<String?>(
                  value: item,
                  child: Text(
                    item!,
                    style: const TextStyle(
                        fontSize: 18, color: ConstantsColors.blueShade900),
                  ),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
