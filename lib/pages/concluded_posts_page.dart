import 'package:appdonationsgestor/components/profile_components/history_card.dart';
import 'package:appdonationsgestor/controllers/navigation_controller.dart';
import 'package:appdonationsgestor/models/donation_model.dart';
import 'package:appdonationsgestor/models/need_model.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:appdonationsgestor/services/api_services/donation_api_service.dart';
import 'package:appdonationsgestor/services/api_services/needs_api_service.dart';
import 'package:flutter/material.dart';

class _ConcludedItem {
  final String type;
  final int id;
  final String title;
  final int quantity;
  final String? imageUrl;

  const _ConcludedItem({
    required this.type,
    required this.id,
    required this.title,
    required this.quantity,
    required this.imageUrl,
  });
}

class ConcludedPostsPage extends StatefulWidget {
  const ConcludedPostsPage({super.key});

  @override
  State<ConcludedPostsPage> createState() => _ConcludedPostsPageState();
}

class _ConcludedPostsPageState extends State<ConcludedPostsPage> {
  late final DonationApiService _donationApiService;
  late final NeedApiService _needApiService;
  late Future<List<_ConcludedItem>> _postsFuture;
  late final VoidCallback _postsRefreshListener;

  @override
  void initState() {
    super.initState();
    final apiClient = ApiClient();
    _donationApiService = DonationApiService(apiClient);
    _needApiService = NeedApiService(apiClient);
    _postsFuture = _loadConcludedItems();
    _postsRefreshListener = _refresh;
    NavigationController.postsRefreshToken.addListener(_postsRefreshListener);
  }

  @override
  void dispose() {
    NavigationController.postsRefreshToken
        .removeListener(_postsRefreshListener);
    super.dispose();
  }

  Future<List<_ConcludedItem>> _loadConcludedItems() async {
    final results = await Future.wait([
      _donationApiService.getMyConcludedDonations(),
      _needApiService.getMyConcludedNeeds(),
    ]);

    final donations = results[0] as List<Donation>;
    final needs = results[1] as List<Need>;

    final concludedDonations = donations.map(
      (item) => _ConcludedItem(
        type: 'DOAÇÃO',
        id: item.id,
        title: item.title,
        quantity: item.quantity,
        imageUrl: item.imageUrl,
      ),
    );

    final concludedNeeds = needs.map(
      (item) => _ConcludedItem(
        type: 'NECESSIDADE',
        id: item.id,
        title: item.title,
        quantity: item.quantity,
        imageUrl: item.imageUrl,
      ),
    );

    return [...concludedDonations, ...concludedNeeds];
  }

  Future<void> _refresh() async {
    setState(() {
      _postsFuture = _loadConcludedItems();
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
            child: FutureBuilder<List<_ConcludedItem>>(
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
                      child: HistoryCard(
                        titulo: '${post.type} #${post.id} - ${post.title}',
                        quantidade: post.quantity,
                        imagem: post.imageUrl,
                        onTap: () {},
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
