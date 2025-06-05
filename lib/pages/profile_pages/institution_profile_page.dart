import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/components/gallery_state.dart';
import 'package:appdonationsgestor/components/profile_info_component.dart';
import 'package:page_transition/page_transition.dart';
import 'package:appdonationsgestor/pages/settings_page.dart';
import 'package:appdonationsgestor/components/post_card.dart';

class InstitutionProfilePage extends StatefulWidget {
  const InstitutionProfilePage({super.key});

  @override
  State<InstitutionProfilePage> createState() => InstitutionProfilePageState();
}

class InstitutionProfilePageState extends State<InstitutionProfilePage> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.symmetric(horizontal: 2.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: ConstantsColors.blueShade900,
                              width: 4.0,
                            ),
                          ),
                          child: const CircleAvatar(
                            radius: 70,
                            backgroundImage: NetworkImage(
                              "https://media.gettyimages.com/id/1317804578/pt/foto/one-businesswoman-headshot-smiling-at-the-camera.jpg?s=612x612&w=0&k=20&c=RXbgBRAoPeDrPXNLXI74Th6Lexbk6PRQ6q0b4rIzEcc=",
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Lar dos idosos',
                                style: TextStylesConstants.kinterSemiBold
                                    .merge(const TextStyle(fontSize: 19.0)),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Contato: ',
                                style: TextStylesConstants.kinterBold
                                    .merge(const TextStyle(fontSize: 14.0)),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.phone_in_talk_outlined,
                                      size: 20.0,
                                      color: ConstantsColors.blackShade700),
                                  const SizedBox(width: 6),
                                  Text(
                                    '(71)12345-6789',
                                    style: TextStylesConstants.kinterRegular
                                        .merge(const TextStyle(fontSize: 14.0)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.email_outlined,
                                      size: 20.0,
                                      color: ConstantsColors.blackShade700),
                                  const SizedBox(width: 6),
                                  Text(
                                    'intituicaotal@gmail.com',
                                    style: TextStylesConstants.kinterRegular
                                        .merge(const TextStyle(fontSize: 14.0)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Text(
                                'Chave Pix: ',
                                style: TextStylesConstants.kinterBold
                                    .merge(const TextStyle(fontSize: 14.0)),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'intituicaotal@gmail.com',
                                style: TextStylesConstants.kinterRegular
                                    .merge(const TextStyle(fontSize: 14.0)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Detalhes
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.symmetric(horizontal: 6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detalhes:',
                          style: TextStylesConstants.kpoppinsMedium.merge(
                            const TextStyle(fontSize: 20.0),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua...',
                          style: TextStylesConstants.kpoppinsMedium.merge(
                            const TextStyle(
                                fontSize: 14.0,
                                color: ConstantsColors.greyShade600),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Doações
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.symmetric(horizontal: 6.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Suas necessidades',
                              style: TextStylesConstants.kpoppinsMedium.merge(
                                const TextStyle(fontSize: 20.0),
                              ),
                            ),
                            TextButton(
                              child: Text(
                                'ver todas',
                                style: TextStylesConstants.kinterRegular.merge(
                                  const TextStyle(
                                      fontSize: 13.0,
                                      color: ConstantsColors.greyShade900),
                                ),
                              ),
                              onPressed: () => {},
                            ),
                          ],
                        ),
                        Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 10),
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
                                Text('Agasalho',
                                    style: TextStylesConstants.kpoppinsMedium
                                        .merge(const TextStyle(fontSize: 15))),
                                const SizedBox(height: 6),
                                Text('Quantidade: 3',
                                    style: TextStylesConstants.kinterRegular
                                        .merge(const TextStyle(
                                            fontSize: 12,
                                            color:
                                                ConstantsColors.greyShade600))),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_pin,
                                      color: ConstantsColors.greyShade600,
                                      size: 15,
                                    ),
                                    const SizedBox(width: 3),
                                    Text('Barbalho, Salvador',
                                        style: TextStylesConstants.kinterRegular
                                            .merge(const TextStyle(
                                                fontSize: 12,
                                                color: ConstantsColors
                                                    .greyShade600))),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('10 de Abril de 2024',
                                        style: TextStylesConstants.kinterRegular
                                            .merge(const TextStyle(
                                                fontSize: 12,
                                                color: ConstantsColors
                                                    .greyShade600))),
                                    TextButton(
                                      onPressed: () {},
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 2.0),
                                        minimumSize: const Size(0, 0),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        backgroundColor:
                                            ConstantsColors.greyShade300,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: Text(
                                        'Vestimentas',
                                        style: TextStylesConstants.kinterRegular
                                            .merge(
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
                  ),

                  const SizedBox(height: 20),

                  // Publicações
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.symmetric(horizontal: 6.0),
                    child: Text(
                      'Publicações',
                      textAlign: TextAlign.start,
                      style: TextStylesConstants.kpoppinsMedium.merge(
                        const TextStyle(
                          fontSize: 20.0,
                          color: ConstantsColors.blackShade900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 1.0,
                      crossAxisSpacing: 1.0,
                      childAspectRatio: 1,
                    ),
                    itemCount: 24,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        color: Colors.white,
                        child: const PostCard(
                          imageUrl: 'assets/donations.jpg',
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite
                      ? ConstantsColors.blueShade900
                      : ConstantsColors.blueShade900,
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
