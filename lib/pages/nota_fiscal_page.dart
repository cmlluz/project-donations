import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:appdonationsgestor/components/custom_button.dart';
import 'package:appdonationsgestor/components/custom_text_field.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';

class NotaFiscalPage extends StatefulWidget {
  final List<Item> items;

  const NotaFiscalPage({
    Key? key,
    this.items = const [Item(description: 'Sem descrição', quantity: 1)],
  }) : super(key: key);

  @override
  State<NotaFiscalPage> createState() => _NotaFiscalPageState();
}

class _NotaFiscalPageState extends State<NotaFiscalPage> {
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController customerCpfCnpjController =
      TextEditingController();
  final TextEditingController invoiceNumberController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  late List<Item> items;

  @override
  void initState() {
    super.initState();
    items = widget.items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantsColors.blueShade900,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Criar Nota Fiscal',
          style: TextStylesConstants.kformularyTitle,
        ),
        backgroundColor: ConstantsColors.blueShade900,
        foregroundColor: ConstantsColors.whiteShade900,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 50),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: ConstantsColors.whiteShade900,
                borderRadius: BorderRadius.vertical(top: Radius.circular(35.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 40, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFields(
                      icon: Icons.person,
                      label: 'Nome / Razão Social',
                      controller: customerNameController,
                      keyboardType: TextInputType.name,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    const SizedBox(height: 15),
                    CustomTextFields(
                      icon: Icons.badge,
                      label: 'CPF / CNPJ',
                      controller: customerCpfCnpjController,
                      keyboardType: TextInputType.text,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    const SizedBox(height: 15),
                    CustomTextFields(
                      icon: Icons.confirmation_number,
                      label: 'Número da Nota',
                      controller: invoiceNumberController,
                      keyboardType: TextInputType.number,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    const SizedBox(height: 15),
                    CustomTextFields(
                      icon: Icons.date_range,
                      label: 'Data da Emissão',
                      controller: dateController,
                      keyboardType: TextInputType.datetime,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      'Itens',
                      style: TextStylesConstants.kformularyTitle
                          .copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    ...items.asMap().entries.map((entry) {
                      int index = entry.key;
                      Item item = entry.value;

                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          GoRouter.of(context)
                              .go('/nota-fiscal/detalhes?itemIndex=$index');
                        },
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Text(
                                    item.description.isNotEmpty
                                        ? item.description
                                        : 'Sem descrição',
                                    style: TextStylesConstants.kpoppinsMedium,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Qtd: ${item.quantity}',
                                    style: TextStylesConstants.kinterRegular,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      items.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 30),
                    Column(
                      children: [
                        const CustomButton(
                          height: 50,
                          width: double.infinity,
                          text: 'Emitir Nota Fiscal',
                          color: ConstantsColors.blueShade900,
                          textColor: ConstantsColors.whiteShade900,
                          route: '/root',
                          hasMensage: true,
                          mensage: 'Nota Fiscal emitida com sucesso!',
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancelar',
                              style: const TextStyle(
                                color: ConstantsColors.blueShade900,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ).merge(TextStylesConstants.kpoppinsSemiBold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Item {
  final String description;
  final int quantity;

  const Item({
    this.description = '',
    this.quantity = 1,
  });
}
