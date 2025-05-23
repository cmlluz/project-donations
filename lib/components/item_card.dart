import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ItemCardComponent extends StatefulWidget {
  const ItemCardComponent({
    super.key,
  });

  @override
  State<ItemCardComponent> createState() => ItemCardComponentState();
}

class ItemCardComponentState extends State<ItemCardComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 9.0, right: 9.0),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Material(
                  child: Container(
                    width: 45.0,
                    height: 70.0,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0)),
                      color: Color.fromARGB(255, 24, 32, 101),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.5),
                      child: IconButton(
                        onPressed: () {
                          context.push("/itemEditPage");
                        },
                        icon: Image.asset(
                          'assets/EditIcon.png',
                          scale: 4.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 33,
                child: Material(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: SizedBox(
                    width: 300.0,
                    height: 70.0,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Agasalho",
                              style: TextStylesConstants.kpoppinsBold,
                            ),
                          ),
                          Row(
                            children: [
                              const Align(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 5.0),
                                  child: Opacity(
                                    opacity: 0.7,
                                    child: Text("10 de Abril de 2024"),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(3.0),
                                child: Icon(
                                  Icons.volunteer_activism,
                                  size: 20,
                                ),
                              ),
                              const Opacity(
                                opacity: 0.7,
                                child: Text("1"),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 18.0),
                                child: Material(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(50.0)),
                                  child: Container(
                                    color: const Color.fromARGB(
                                        255, 237, 237, 237),
                                    height: 25,
                                    width: 90,
                                    child: const Text(
                                      "Vestimentas",
                                      style: TextStylesConstants.kpoppinsBlack,
                                    ),
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}
