import 'package:appdonationsgestor/components/card_item.dart';
import 'package:appdonationsgestor/controllers/user_provider.dart';
import 'package:appdonationsgestor/models/post_model.dart';
import 'package:appdonationsgestor/pages/post_detail_page.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:appdonationsgestor/services/api_services/post_api_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PostApiService _postApiService;
  late Future<List<PostModel>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postApiService = PostApiService(ApiClient());
    _postsFuture = _postApiService.getPosts();
  }

  Future<void> _refresh() async {
    setState(() {
      _postsFuture = _postApiService.getPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final userName = userProvider.currentUser?.name ?? 'Usuário';
    final userImageUrl = userProvider.currentUser?.profilePictureUrl;

    ImageProvider profileImage = const AssetImage("assets/profile_default.png");
    if (userImageUrl != null && userImageUrl.isNotEmpty) {
      profileImage = NetworkImage(userImageUrl);
    }

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
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: profileImage,
                        ),
                        const SizedBox(width: 11.0),
                        Text(
                          'Olá, $userName 👋',
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
                      child: Text("Erro ao carregar: ${snapshot.error}"));
                }

                final posts = snapshot.data ?? [];
                if (posts.isEmpty) {
                  return const Center(
                      child: Text("Nenhuma publicação encontrada."));
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
                            "https://via.placeholder.com/150",
                        location: "Salvador, Bahia",
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
