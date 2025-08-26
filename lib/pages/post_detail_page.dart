import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({Key? key}) : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  bool isFavorite = false;

  // Lista de itens de teste
  final List<Map<String, dynamic>> itensNecessarios = [
    {
      "titulo": "Agasalhos - Necessidade",
      "local": "Barbalho, Salvador",
      "instituicao": "Lar dos idosos",
      "detalhes":
          "Precisamos de agasalhos para os idosos devido às baixas temperaturas.",
      "button": true,
    },
    // {
    //   "titulo": "Alimentos não perecíveis",
    //   "local": "Centro, Salvador",
    //   "instituicao": "Casa Esperança",
    //   "detalhes": "A instituição está arrecadando alimentos para 50 famílias.",
    //   "button": false,
    // },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 50, left: 15, right: 15),
        itemCount: itensNecessarios.length,
        itemBuilder: (context, index) {
          final item = itensNecessarios[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.asset(
                      'assets/instituicao.png',
                      width: double.infinity,
                      height: 400,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: CircleAvatar(
                      backgroundColor: ConstantsColors.blueShade900,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: ConstantsColors.whiteShade900,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: CircleAvatar(
                      backgroundColor: isFavorite
                          ? ConstantsColors.blueShade900
                          : Colors.grey.withOpacity(0.5),
                      child: IconButton(
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ConstantsColors.blueShade900,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item["titulo"],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ).merge(TextStylesConstants.kinterSemiBold),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_pin,
                                  color: ConstantsColors.greyShade600,
                                  size: 16),
                              const SizedBox(width: 4),
                              Text(
                                item["local"],
                                style: TextStylesConstants.krobotoRegular.merge(
                                  const TextStyle(
                                    fontSize: 18.0,
                                    color: ConstantsColors.greyShade600,
                                  ),
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
              const SizedBox(height: 16),
              ListTile(
                leading: const CircleAvatar(
                  backgroundImage: AssetImage('assets/instituicao.png'),
                ),
                title: Text(
                  item["instituicao"],
                  style: const TextStyle(
                    fontSize: 16,
                    color: ConstantsColors.blueShade900,
                  ).merge(TextStylesConstants.kinterSemiBold),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Detalhes",
                    style: const TextStyle(
                      fontSize: 22,
                      color: ConstantsColors.blueShade900,
                    ).merge(
                      TextStylesConstants.kpoppinsMedium,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  item["detalhes"],
                  style: const TextStyle(
                    fontSize: 16,
                    color: ConstantsColors.greyShade600,
                  ).merge(
                    TextStylesConstants.kpoppinsMedium,
                  ),
                ),
              ),
              if (item["button"])
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ConstantsColors.blueShade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: () {
                      // ação do botão
                    },
                    child: const Text(
                      "Quero doar",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}
