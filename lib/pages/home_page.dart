import 'package:appdonationsgestor/components/card_item.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> cardsData = [
    {
      "title": "Lar dos Idosos",
      "subtitle": "Lorem ipsum dolor sit amet, consectetur adipiscing...",
      "avatarUrl":
          "https://imgs.search.brave.com/EH557LzfsHTfIMbszf0VhVSjTAxp2YIL1olc8zaL-ic/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9zdGF0/aWM2LmRlcG9zaXRw/aG90b3MuY29tLzEw/MzExNzQvNTk0L2kv/NDUwL2RlcG9zaXRw/aG90b3NfNTk0MjE0/MS1zdG9jay1waG90/by1ncm91cC1vZi1w/YXBlcmNoYWluLWhv/bGRpbmctaGFuZHMu/anBn",
      "location": "Salvador, Bahia",
      "date": "15 Jun, 2025",
      "imageAsset": "assets/donations.jpg",
    },
    {
      "title": "Centro Comunitário",
      "subtitle": "Ajudando crianças carentes com educação e saúde",
      "avatarUrl":
          "https://imgs.search.brave.com/EH557LzfsHTfIMbszf0VhVSjTAxp2YIL1olc8zaL-ic/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9zdGF0/aWM2LmRlcG9zaXRw/aG90b3MuY29tLzEw/MzExNzQvNTk0L2kv/NDUwL2RlcG9zaXRw/aG90b3NfNTk0MjE0/MS1zdG9jay1waG90/by1ncm91cC1vZi1w/YXBlcmNoYWluLWhv/bGRpbmctaGFuZHMu/anBn",
      "location": "Recife, PE",
      "date": "10 Jun, 2025",
      "imageAsset": "assets/donations2.jpg",
    },
    {
      "title": "ONG Teste",
      "subtitle":
          "Este é um subtítulo muito longo para testar a limitação de duas linhas no CardItem. Ele deve mostrar reticências quando ultrapassar o limite.",
      "avatarUrl":
          "https://imgs.search.brave.com/EH557LzfsHTfIMbszf0VhVSjTAxp2YIL1olc8zaL-ic/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9zdGF0/aWM2LmRlcG9zaXRw/aG90b3MuY29tLzEw/MzExNzQvNTk0L2kv/NDUwL2RlcG9zaXRw/aG90b3NfNTk0MjE0/MS1zdG9jay1waG90/by1ncm91cC1vZi1w/YXBlcmNoYWluLWhv/bGRpbmctaGFuZHMu/anBn",
      "location": "São Paulo, SP",
      "date": "20 Jun, 2025",
      "imageAsset": "assets/donations.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromRGBO(252, 251, 248, 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                offset: const Offset(0, 1),
                blurRadius: 2,
                spreadRadius: 0,
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 21.0, vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () =>
                        GoRouter.of(context).pushNamed("managerProfilePage"),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size.zero,
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundImage: AssetImage("assets/profile.jpg"),
                        ),
                        const SizedBox(width: 11.0),
                        Text(
                          'Olá, Name 👋',
                          style: const TextStyle(
                            color: ConstantsColors.blueShade900,
                            fontSize: 20,
                          ).merge(TextStylesConstants.kpoppinsRegular),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      GoRouter.of(context).pushNamed("notificationsPage");
                    },
                    icon: Image.asset("assets/icons/notification_icon.png"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: ConstantsColors.whiteShade900,
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 29.0),
            itemCount: cardsData.length,
            itemBuilder: (context, index) {
              final card = cardsData[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 29.0),
                child: CardItem(
                  onTap: () => print("Clicou no card ${card['title']}"),
                  title: card['title']!,
                  subtitle: card['subtitle'],
                  avatarUrl: card['avatarUrl']!,
                  location: card['location']!,
                  date: card['date']!,
                  imageAsset: card['imageAsset']!,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
