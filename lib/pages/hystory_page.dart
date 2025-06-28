import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';

class HystoryPage extends StatefulWidget {
  const HystoryPage({Key? key}) : super(key: key);

  @override
  State<HystoryPage> createState() => _HystoryPage();
}

class _HystoryPage extends State<HystoryPage> {
  final List<Map<String, dynamic>> necessidades = [
    {
      'instituicao': 'Lar dos Idosos',
      'item': 'Agasalho',
      'quantidade': 3,
      'local': 'Barbalho, Salvador',
      'data': '10 de Abril de 2024',
      'categoria': 'Vestimentas',
    },
    {
      'instituicao': 'Casa da Criança',
      'item': 'Leite em pó',
      'quantidade': 10,
      'local': 'Cabula, Salvador',
      'data': '15 de Abril de 2024',
      'categoria': 'Alimentos',
    },
    {
      'instituicao': 'Abrigo Esperança',
      'item': 'Fraldas geriátricas',
      'quantidade': 5,
      'local': 'Federação, Salvador',
      'data': '20 de Abril de 2024',
      'categoria': 'Higiene',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
        backgroundColor: ConstantsColors.whiteShade900,
        elevation: 0,
        iconTheme: const IconThemeData(color: ConstantsColors.blackShade900),
        titleTextStyle: TextStylesConstants.kinterSemiBold.merge(
          const TextStyle(
            color: ConstantsColors.blackShade900,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: ConstantsColors.whiteShade900,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: necessidades.map((necessidade) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    necessidade['instituicao'],
                    style: TextStylesConstants.kpoppinsMedium.merge(
                      const TextStyle(fontSize: 15.0),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: const Border(
                          right: BorderSide(
                            color: ConstantsColors.blueShade900,
                            width: 5,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            necessidade['item'],
                            style: TextStylesConstants.kpoppinsMedium.merge(
                              const TextStyle(fontSize: 15),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Quantidade: ${necessidade['quantidade']}',
                            style: TextStylesConstants.kinterRegular.merge(
                              const TextStyle(
                                fontSize: 12,
                                color: ConstantsColors.greyShade600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_pin,
                                color: ConstantsColors.greyShade600,
                                size: 15,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                necessidade['local'],
                                style: TextStylesConstants.kinterRegular.merge(
                                  const TextStyle(
                                    fontSize: 12,
                                    color: ConstantsColors.greyShade600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                necessidade['data'],
                                style: TextStylesConstants.kinterRegular.merge(
                                  const TextStyle(
                                    fontSize: 12,
                                    color: ConstantsColors.greyShade600,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 2.0,
                                  ),
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  backgroundColor: ConstantsColors.greyShade300,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  necessidade['categoria'],
                                  style:
                                      TextStylesConstants.kinterRegular.merge(
                                    const TextStyle(
                                      fontSize: 12,
                                      color: ConstantsColors.greyShade900,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
