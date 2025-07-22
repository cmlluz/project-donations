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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25), // Arredonda tudo
                    child: Image.asset(
                      'assets/instituicao.png',
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: CircleAvatar(
                      backgroundColor:
                          ConstantsColors.blueShade900.withOpacity(0.5),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: ConstantsColors.whiteShade900,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  // Positioned(
                  //   top: 16,
                  //   right: 16,
                  //   child: CircleAvatar(
                  //     backgroundColor:
                  //         ConstantsColors.blueShade900.withOpacity(0.5),
                  //     child: IconButton(
                  //       icon: Icon(
                  //         isFavorite ? Icons.favorite : Icons.favorite_border,
                  //         color: isFavorite
                  //             ? Colors.red
                  //             : ConstantsColors.whiteShade900,
                  //       ),
                  //       onPressed: () {
                  //         setState(() {
                  //           isFavorite = !isFavorite;
                  //         });
                  //       },
                  //     ),
                  //   ),
                  // ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ConstantsColors.blueShade900.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Agasalhos - Necessidade",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_pin,
                                  color: Colors.white, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                "Barbalho, Salvador",
                                style:
                                    TextStylesConstants.kpoppinsRegular.merge(
                                  const TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.white,
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
                  "Lar dos idosos",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Detalhes",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore.",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
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
                    // definir rota
                  },
                  child: const Text(
                    "Quero doar",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
