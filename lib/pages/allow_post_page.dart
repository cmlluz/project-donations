import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/models/post_model.dart';

class AllowPostPage extends StatefulWidget {
  final PostModel post;

  const AllowPostPage({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<AllowPostPage> createState() => _AllowPostPageState();
}

class _AllowPostPageState extends State<AllowPostPage> {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

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

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ConstantsColors.blueShade900,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Postagem permitida!",
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
                },
                child: Text(
                  "Permitir postagem",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ).merge(TextStylesConstants.kpoppinsMedium),
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ConstantsColors.redShade900,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Postagem não permitida.",
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
                },
                child: Text(
                  "Não permitir postagem",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ).merge(TextStylesConstants.kpoppinsMedium),
                ),
              ),
            ),

            const SizedBox(height: 25),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Observações (opcional)",
                style: const TextStyle(
                  fontSize: 18,
                  color: ConstantsColors.blueShade900,
                ).merge(TextStylesConstants.kpoppinsMedium),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Adicione um comentário ou justificativa...",
                hintStyle: TextStylesConstants.kpoppinsMedium.merge(
                  const TextStyle(
                    color: ConstantsColors.greyShade600,
                    fontSize: 14,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: ConstantsColors.greyShade600,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: ConstantsColors.blueShade900,
                    width: 2,
                  ),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
