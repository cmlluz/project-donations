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
      'donated': true,
    },
    {
      'instituicao': 'Casa da Criança',
      'item': 'Leite em pó',
      'quantidade': 10,
      'local': 'Cabula, Salvador',
      'data': '15 de Abril de 2024',
      'categoria': 'Alimentos',
      'donated': false,
    },
    {
      'instituicao': 'Abrigo Esperança',
      'item': 'Fraldas geriátricas',
      'quantidade': 5,
      'local': 'Federação, Salvador',
      'data': '20 de Abril de 2024',
      'categoria': 'Higiene',
      'donated': true,
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
          children: necessidades.map((necessidade) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    bottom: -30,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.only(top: 16, left: 12),
                      decoration: BoxDecoration(
                        color: ConstantsColors.blueShade500.withOpacity(0.38),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          necessidade['donated'] == true
                              ? const Icon(Icons.check_circle,
                                  color: Colors.green, size: 20)
                              : const Icon(Icons.close,
                                  color: Colors.red, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            necessidade['donated'] == true
                                ? 'Doação confirmada'
                                : 'Doação não confirmada',
                            style: TextStylesConstants.kpoppinsMedium.merge(
                              const TextStyle(
                                  fontSize: 13,
                                  color: ConstantsColors.blackShade900),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                necessidade['item'],
                                style: TextStylesConstants.kpoppinsSemiBold
                                    .merge(const TextStyle(fontSize: 16)),
                              ),
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'ver mais',
                                  style:
                                      TextStylesConstants.kinterRegular.merge(
                                    const TextStyle(
                                      fontSize: 13,
                                      color: ConstantsColors.greyShade900,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: ConstantsColors.greyShade300,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  necessidade['categoria'],
                                  style: TextStylesConstants.kpoppinsMedium
                                      .merge(const TextStyle(
                                    fontSize: 12,
                                    color: ConstantsColors.blackShade900,
                                  )),
                                ),
                              ),
                            ],
                          ),
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
