import 'package:appdonationsgestor/components/card_item.dart';
import 'package:appdonationsgestor/models/post_model.dart';
import 'package:appdonationsgestor/pages/post_detail_page.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:appdonationsgestor/services/api_services/post_api_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConcludedPostsPage extends StatefulWidget {
  const ConcludedPostsPage({super.key});

  @override
  State<ConcludedPostsPage> createState() => _ConcludedPostsPageState();
}

class _ConcludedPostsPageState extends State<ConcludedPostsPage> {
  late final PostApiService _postApiService;
  late Future<List<PostModel>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postApiService = PostApiService(ApiClient());
    _postsFuture = _postApiService.getConcludedPosts();
  }

  Future<void> _refresh() async {
    setState(() {
      _postsFuture = _postApiService.getConcludedPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantsColors.whiteShade900,
      appBar: AppBar(
        backgroundColor: ConstantsColors.whiteShade900,
        elevation: 0,
        iconTheme: const IconThemeData(color: ConstantsColors.blueShade900),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Posts Concluídos',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: ConstantsColors.blueShade900,
          ).merge(TextStylesConstants.kpoppinsMedium),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          color: ConstantsColors.whiteShade900,
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: FutureBuilder<List<PostModel>>(
              future: _postsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                        'Erro ao carregar posts concluídos: ${snapshot.error}'),
                  );
                }

                final posts = snapshot.data ?? [];
                if (posts.isEmpty) {
                  return const Center(
                    child: Text('Você ainda não tem posts concluídos.'),
                  );
                }

                return ListView.builder(
                  padding:
                      const EdgeInsets.only(left: 5.0, right: 5.0, top: 29.0),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 29.0),
                      child: CardItem(
                        title: post.authorName,
                        subtitle: post.caption,
                        avatarUrl: post.authorPhoto ??
                            'https://via.placeholder.com/150',
                        date: DateFormat('dd MMM, yyyy').format(post.createdAt),
                        imageAsset: post.imageUrl,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostDetailPage(post: post),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
