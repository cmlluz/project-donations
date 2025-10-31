import 'package:appdonationsgestor/models/post_model.dart';
import 'package:appdonationsgestor/pages/allow_post_page.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPage();
}

class _NotificationsPage extends State<NotificationsPage> {
  bool notificationsEnabled = true;

  final PostModel pendingPost = PostModel(
    id: "2",
    title: "Vestuário - Doação",
    description: "Doação de roupas variadas para pessoas em situação de rua.",
    quantity: 50,
    imageUrl: "assets/donations.jpg",
    location: "Rio Vermelho, Salvador",
    institution: "Lar dos Idosos",
    institutionImageUrl: "assets/profile.jpg",
    createdAt: DateTime(2025, 8, 20),
    category: "doacao",
  );

  late final List<Map<String, dynamic>> notifications = [
    {
      "title": "Solicitação de postagem",
      "time": "Hoje às 10:15",
      "message":
          "A instituição Lar dos Idosos quer realizar uma postagem e precisa da sua permissão. Clique aqui para saber mais.",
      "onTap": () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AllowPostPage(post: pendingPost),
            ),
          ),
    },
    {
      "title": "Exemplo de notificação antiga",
      "time": "Ontem às 16:45",
      "message":
          "There are many variations of passages of Lorem Ipsum available, but the majority",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final todayNotifications = notifications
        .where((n) => n["time"]!.toLowerCase().contains("hoje"))
        .toList();

    final oldNotifications = notifications
        .where((n) => !n["time"]!.toLowerCase().contains("hoje"))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
        centerTitle: true,
        backgroundColor: ConstantsColors.whiteShade900,
        elevation: 0,
        iconTheme: const IconThemeData(color: ConstantsColors.blueShade900),
        titleTextStyle: TextStylesConstants.kinterSemiBold.merge(
          const TextStyle(
            color: ConstantsColors.blueShade900,
            fontSize: 24,
          ).merge(TextStylesConstants.kpoppinsRegular),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          iconSize: 30,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: ConstantsColors.whiteShade900,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: notificationsEnabled
              ? (notifications.isEmpty
                  ? buildEmptyNotifications()
                  : ListView(
                      children: [
                        if (todayNotifications.isNotEmpty) ...[
                          buildSectionTitle("Recente"),
                          ...todayNotifications.map(buildNotification),
                        ],
                        if (oldNotifications.isNotEmpty) ...[
                          buildDivider(),
                          buildSectionTitle("Antigas"),
                          ...oldNotifications.map(buildNotification),
                        ],
                      ],
                    ))
              : buildDisabledNotifications(),
        ),
      ),
    );
  }

  Widget buildNotification(Map<String, dynamic> notif) {
    return GestureDetector(
      onTap: notif["onTap"],
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: ConstantsColors.whiteShade900,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 6),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "•",
                  style: TextStyle(
                    fontSize: 30,
                    color: ConstantsColors.blueShade900,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    notif["title"]!,
                    style: const TextStyle(
                      color: ConstantsColors.blueShade900,
                      fontSize: 17,
                    ).merge(TextStylesConstants.kinterBold),
                  ),
                ),
              ],
            ),
            Text(
              notif["time"]!,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 10,
              ).merge(TextStylesConstants.kinterRegular),
            ),
            const SizedBox(height: 10),
            Text(
              notif["message"]!,
              style: const TextStyle(
                color: ConstantsColors.blueShade900,
                fontSize: 14,
              ).merge(TextStylesConstants.kinterRegular),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: ConstantsColors.blueShade900,
          ).merge(TextStylesConstants.kinterRegular),
        ),
      );

  Widget buildDivider() => Container(
        margin: const EdgeInsets.only(top: 20),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: ConstantsColors.greyShade600,
              width: 1,
            ),
          ),
        ),
      );

  Widget buildEmptyNotifications() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/notification_img.png",
            width: 150,
            height: 150,
          ),
          const SizedBox(height: 40),
          Text(
            'Nenhuma notificação encontrada',
            style: const TextStyle(
              color: ConstantsColors.blueShade900,
              fontSize: 20,
            ).merge(TextStylesConstants.kpoppinsBold),
          ),
          const SizedBox(height: 10),
          Text(
            'Fique tranquilo, avisaremos quando houver novidades.',
            style: const TextStyle(
              color: ConstantsColors.blueShade900,
              fontSize: 17,
            ).merge(TextStylesConstants.kpoppinsRegular),
            textAlign: TextAlign.center,
          ),
        ],
      );

  Widget buildDisabledNotifications() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/notification_img.png",
            width: 150,
            height: 150,
          ),
          const SizedBox(height: 40),
          Text(
            'Suas notificações são exibidas aqui',
            style: const TextStyle(
              color: ConstantsColors.blueShade900,
              fontSize: 20,
            ).merge(TextStylesConstants.kpoppinsBold),
          ),
          const SizedBox(height: 10),
          Text(
            'Não deixe passar nenhuma oportunidade de fazer o bem.',
            style: const TextStyle(
              color: ConstantsColors.blueShade900,
              fontSize: 17,
            ).merge(TextStylesConstants.kpoppinsRegular),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          TextButton(
            onPressed: () {
              setState(() {
                notificationsEnabled = true;
              });
            },
            style: TextButton.styleFrom(
              backgroundColor: ConstantsColors.blueShade900,
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Ativar Notificações',
              style: const TextStyle(
                color: ConstantsColors.whiteShade900,
                fontSize: 16,
              ).merge(TextStylesConstants.kpoppinsMedium),
            ),
          ),
        ],
      );
}
