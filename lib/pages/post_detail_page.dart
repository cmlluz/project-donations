import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/models/post_model.dart';
import 'package:appdonationsgestor/components/popup.dart';
import 'package:appdonationsgestor/pages/confirm_donation_page.dart';
import 'package:appdonationsgestor/pages/item_edit_page.dart';

class PostDetailPage extends StatefulWidget {
  final PostModel post;
  final String? currentUser;

  const PostDetailPage({
    Key? key,
    required this.post,
    this.currentUser,
  }) : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  bool isFavorite = false;
  bool isConfirmed = false;

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final bool isAuthor = true; // passar uma lógica aqui depois
    final isNeed = post.category == 'necessidade';
    final buttonText = isNeed ? "Quero doar" : "Quero receber";

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 50, left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.asset(
                    post.imageUrl,
                    width: double.infinity,
                    height: 400,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 400,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
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
                if (!isAuthor)
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
                if (isAuthor)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: ConstantsColors.blueShade900,
                          child: IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: ConstantsColors.whiteShade900,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ItemEditPage(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        CircleAvatar(
                          backgroundColor: Colors.red.shade700,
                          child: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: ConstantsColors.whiteShade900,
                            ),
                            onPressed: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => const Dialog(
                                  backgroundColor: Colors.transparent,
                                  insetPadding:
                                      EdgeInsets.symmetric(horizontal: 24),
                                  child: Popup(
                                    title: "Excluir publicação",
                                    subtitle:
                                        "Tem certeza de que deseja excluir este post?",
                                    confirmText: "Excluir",
                                    cancelText: "Cancelar",
                                    confirmButtonColor: Colors.redAccent,
                                  ),
                                ),
                              );

                              if (confirmed == true) {
                                Navigator.of(context).pop(true);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Publicação excluída com sucesso!",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: ConstantsColors.blackShade900,
                                      ).merge(
                                          TextStylesConstants.kinterRegular),
                                      textAlign: TextAlign.center,
                                    ),
                                    backgroundColor:
                                        ConstantsColors.blueShade400,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
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
                          post.title,
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
                                color: ConstantsColors.greyShade600, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              post.location,
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
              leading: CircleAvatar(
                backgroundImage: AssetImage(post.institutionImageUrl),
                onBackgroundImageError: (exception, stackTrace) {},
                child: post.institutionImageUrl.isEmpty
                    ? const Icon(Icons.business)
                    : null,
              ),
              title: Text(
                post.institution,
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
                  ).merge(TextStylesConstants.kpoppinsMedium),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                post.description,
                style: const TextStyle(
                  fontSize: 16,
                  color: ConstantsColors.greyShade600,
                ).merge(TextStylesConstants.kpoppinsMedium),
              ),
            ),
            if (!isAuthor)
              SizedBox(
                width: double.infinity,
                child: isConfirmed && isNeed
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ConstantsColors.redShade900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ConfirmDonationPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Confirmar a doação",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ).merge(TextStylesConstants.kpoppinsMedium),
                        ),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ConstantsColors.blueShade900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return const Dialog(
                                child: Popup(
                                  title: "Permissão de compartilhamento",
                                  subtitle:
                                      "Você permite o compartilhamento dos seus dados para que a instituição entre em contato?",
                                  confirmText: "Confirmar",
                                  cancelText: "Cancelar",
                                ),
                              );
                            },
                          );

                          if (confirmed == true) {
                            final message = isNeed
                                ? "Interesse em doar registrado!"
                                : "Interesse em receber registrado!";

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  message,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: ConstantsColors.blackShade900,
                                  ).merge(TextStylesConstants.kinterRegular),
                                  textAlign: TextAlign.center,
                                ),
                                backgroundColor: ConstantsColors.blueShade400,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );

                            setState(() {
                              isConfirmed = true;
                            });
                          }
                        },
                        child: Text(
                          buttonText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ).merge(TextStylesConstants.kpoppinsMedium),
                        ),
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
