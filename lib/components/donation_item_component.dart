import 'dart:io';
import 'package:appdonationsgestor/components/custom_button.dart';
import 'package:appdonationsgestor/components/custom_drop_down_button_component.dart';
import 'package:appdonationsgestor/components/custom_text_field.dart';
import 'package:appdonationsgestor/controllers/post_type_controller.dart';

import 'package:appdonationsgestor/controllers/product_registration_controller.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class DonationItemComponent extends StatelessWidget {
  // DEPOIS EXTRAIR PARA OUTRO FILE
  final ProductRegistrationController productRegistrationController;
  final PostTypeController postTypeController;
  final VoidCallback onPickImage;
  final File? selectedImg;
  final VoidCallback onSubmit;

  const DonationItemComponent({
    super.key,
    required this.productRegistrationController,
    required this.postTypeController,
    required this.onPickImage,
    required this.selectedImg,
    required this.onSubmit,
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
            const SizedBox(height: 10),
            GestureDetector(
              onTap: onPickImage,
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(25.0),
                color: ConstantsColors.blueShade900,
                dashPattern: const [5, 5],
                strokeWidth: 2,
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(1, 91, 124, 0.05),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: selectedImg != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(25.0),
                          child: Image.file(
                            selectedImg!,
                            width: 350,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.image_search_outlined,
                              size: 60,
                              color: ConstantsColors.blueShade900,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Adicione a foto aqui',
                              style: TextStyle(
                                fontSize: 14,
                                color: ConstantsColors.greyShade600
                                    .withOpacity(0.8),
                              ),
                            ),
                            const Text(
                              'Procurar',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: ConstantsColors.blueShade900,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
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
                    icon: Icons.production_quantity_limits,
                    secret: false,
                    controller: productRegistrationController.crtlQtd,
                    keyboardType: TextInputType.number,
                    labelColor: ConstantsColors.whiteShade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
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
            CustomButton(
              height: 40,
              width: 150,
              text: 'Publicar',
              color: ConstantsColors.blueShade900,
              textColor: ConstantsColors.whiteShade700,
              onPressed: onSubmit,
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancelar',
                  style: const TextStyle(
                    color: ConstantsColors.greyShade600,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ).merge(TextStylesConstants.kpoppinsSemiBold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
