import 'package:flutter/material.dart';
import 'package:appdonationsgestor/models/post_model.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/pages/profile_pages/institution_profile_page.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:appdonationsgestor/services/api_services/post_api_service.dart';
import 'package:intl/intl.dart';

class PostDetailPage extends StatefulWidget {
  final PostModel post;

  const PostDetailPage({
    super.key,
    required this.post,
  });

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late final PostApiService _postApiService;
  final ApiClient _apiClient = ApiClient();
  int _pendingPostsCount = 0;
  bool _isLoadingCount = false;

  @override
  void initState() {
    super.initState();
    _postApiService = PostApiService(_apiClient);
    if (widget.post.postStatus == 'PENDENTE_APROVACAO') {
      _loadPendingPostsCount();
    }
  }

  Future<void> _loadPendingPostsCount() async {
    setState(() {
      _isLoadingCount = true;
    });

    try {
      final allPosts = await _postApiService.getPosts();
      final pendingPosts =
          allPosts.where((p) => p.postStatus == 'PENDENTE_APROVACAO').toList();
      setState(() {
        _pendingPostsCount = pendingPosts.length;
      });
    } catch (e) {
      print('Erro ao carregar contagem de posts pendentes: $e');
    } finally {
      setState(() {
        _isLoadingCount = false;
      });
    }
  }

  String _traduzirPostStatus(String status) {
    switch (status) {
      case 'DISPONIVEL':
        return 'Publicado';
      case 'PENDENTE_APROVACAO':
        return 'Em Análise';
      case 'REJEITADO':
        return 'Rejeitado';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final formattedDate = DateFormat('dd \'de\' MMMM \'de\' yyyy', 'pt_BR')
        .format(post.createdAt);

    return Scaffold(
      backgroundColor: ConstantsColors.whiteShade900,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 70, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InstitutionProfilePage(
                            userId: post.authorUid,
                            userName: post.authorName,
                            userEmail: '',
                            userImageUrl: post.authorPhoto ?? '',
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(
                            post.authorPhoto ??
                                "https://via.placeholder.com/150",
                          ),
                          onBackgroundImageError: (_, __) {},
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.authorName,
                              style: TextStylesConstants.kpoppinsSemiBold.merge(
                                const TextStyle(
                                  fontSize: 18,
                                  color: ConstantsColors.blueShade900,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            Text(
                              formattedDate,
                              style: TextStylesConstants.kinterRegular.merge(
                                const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Hero(
                          tag: 'post_image_${post.id}',
                          child: Image.network(
                            post.imageUrl,
                            width: double.infinity,
                            height: 400,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: double.infinity,
                                height: 300,
                                color: Colors.grey[300],
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.broken_image,
                                        size: 50, color: Colors.grey),
                                    SizedBox(height: 8),
                                    Text("Erro ao carregar imagem",
                                        style: TextStyle(color: Colors.grey)),
                                  ],
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 400,
                                width: double.infinity,
                                color: Colors.grey[100],
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: ConstantsColors.blueShade900,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.business)),
                    title: Text(
                      post.authorName,
                      style: const TextStyle(
                              fontSize: 18, color: ConstantsColors.blueShade900)
                          .merge(TextStylesConstants.kinterSemiBold),
                    ),
                    subtitle:
                        Text('Status: ${_traduzirPostStatus(post.postStatus)}'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Descrição",
                    style: TextStylesConstants.kpoppinsSemiBold.merge(
                      const TextStyle(
                        fontSize: 20,
                        color: ConstantsColors.blueShade900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    post.caption,
                    style: TextStylesConstants.kinterRegular.merge(
                      const TextStyle(
                        fontSize: 16,
                        color: ConstantsColors.greyShade800,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 15,
              left: 15,
              child: CircleAvatar(
                backgroundColor: ConstantsColors.blueShade900,
                radius: 22,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
