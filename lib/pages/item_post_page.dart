import 'package:appdonationsgestor/components/custom_text_field.dart';
import 'package:appdonationsgestor/components/rounded_background_component.dart';
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
          'Criar nova divulgação',
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
                    postTypeController: _controller1,
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
        productRegistrationController.itemQtdValue
      ]),
      builder: (_, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nome do item'),
            CustomTextFields(
              icon: Icons.label,
              secret: false,
              controller: productRegistrationController.crtlItemName,
              keyboardType: TextInputType.name,
              labelColor: ConstantsColors.greyShade200,
              hintText: 'Digite o item',
            ),
            const SizedBox(height: 20),
            const Text('Descrição'),
            CustomTextFields(
              icon: Icons.edit_document,
              hintText: 'Descreva a sua necessidade/doação',
              secret: false,
              controller: productRegistrationController.crtlDesc,
              keyboardType: TextInputType.multiline,
              labelColor: ConstantsColors.greyShade200,
            ),
            const SizedBox(height: 20),
            const Text('Categoria e Quantidade'),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
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
                    labelColor: ConstantsColors.greyShade200,
                  ),
                ),
              ],
            ),
            const Text('Tipo de divulgação'),
            CustomDropDownButtonComponent(
              selected: postTypeController.selectedValueCategory.value,
              items: postTypeController.category,
              hint: 'Selecione uma opção',
              onChanged: (item) =>
                  productRegistrationController.selectedItemCategory = item,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 120.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    height: 50,
                    width: 150,
                    text: 'Publicar',
                    route: '/root',
                    color: ConstantsColors.blueShade900,
                    textColor: ConstantsColors.whiteShade900,
                    hasMensage: true,
                    mensage: 'Publicado com sucesso!',
                  ),
                  SizedBox(width: 20),
                  CustomButton(
                    height: 50,
                    width: 150,
                    text: 'Voltar',
                    route: '/root',
                    color: ConstantsColors.whiteShade900,
                    textColor: ConstantsColors.blueShade900,
                  ),
                ],
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
  final Color? color;
  final void Function(String?)? onChanged;

  const CustomDropDownButtonComponent({
    super.key,
    required this.selected,
    required this.items,
    required this.onChanged,
    required this.hint,
    this.color = ConstantsColors.greyShade200,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: DropdownButton<String?>(
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
      ),
    );
  }
}
