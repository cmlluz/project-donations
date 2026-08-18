import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/controllers/search_controller.dart';
import 'package:appdonationsgestor/controllers/user_provider.dart';
import 'package:appdonationsgestor/controllers/campaign_controller.dart';
import 'package:appdonationsgestor/controllers/donation_controller.dart';
import 'package:appdonationsgestor/controllers/need_controller.dart';
import 'package:appdonationsgestor/controllers/navigation_controller.dart';
import 'package:appdonationsgestor/components/search_item.dart';
import 'package:appdonationsgestor/pages/search_pages/filter_pages/generic_filter_page.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  late AppSearchController _searchControllerProvider;
  late final VoidCallback _postsRefreshListener;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _searchControllerProvider = AppSearchController();
    _searchControllerProvider.loadItems();
    _postsRefreshListener = () {
      if (mounted) {
        _searchControllerProvider.loadItems();
      }
    };
    NavigationController.postsRefreshToken.addListener(_postsRefreshListener);

    // Conecta com os Controllers para receber atualizações em tempo real
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final campaignController =
          Provider.of<CampaignController>(context, listen: false);
      final donationController =
          Provider.of<DonationController>(context, listen: false);
      final needController =
          Provider.of<NeedController>(context, listen: false);

      // Atualiza com dados iniciais
      _searchControllerProvider.updateCampaigns(campaignController.campaigns);
      _searchControllerProvider.updateDonations(donationController.donations);
      _searchControllerProvider.updateNeeds(needController.needs);

      // Listeners para atualizações em tempo real
      campaignController.addListener(() {
        if (mounted) {
          _searchControllerProvider
              .updateCampaigns(campaignController.campaigns);
        }
      });

      donationController.addListener(() {
        if (mounted) {
          _searchControllerProvider
              .updateDonations(donationController.donations);
        }
      });

      needController.addListener(() {
        if (mounted) {
          _searchControllerProvider.updateNeeds(needController.needs);
        }
      });
    });
  }

  @override
  void dispose() {
    // Remove listeners se ainda estiver montado
    if (mounted) {
      try {
        final campaignController =
            Provider.of<CampaignController>(context, listen: false);
        campaignController.removeListener(() {
          _searchControllerProvider
              .updateCampaigns(campaignController.campaigns);
        });
      } catch (e) {
        // Ignora erro se o Provider não estiver mais disponível
      }

      try {
        final donationController =
            Provider.of<DonationController>(context, listen: false);
        donationController.removeListener(() {
          _searchControllerProvider
              .updateDonations(donationController.donations);
        });
      } catch (e) {
        // Ignora erro se o Provider não estiver mais disponível
      }

      try {
        final needController =
            Provider.of<NeedController>(context, listen: false);
        needController.removeListener(() {
          _searchControllerProvider.updateNeeds(needController.needs);
        });
      } catch (e) {
        // Ignora erro se o Provider não estiver mais disponível
      }
    }

    _tabController.dispose();
    _searchController.dispose();
    NavigationController.postsRefreshToken
        .removeListener(_postsRefreshListener);
    _searchControllerProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _searchControllerProvider,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Container(
          color: ConstantsColors.whiteShade700,
          child: Column(
            children: [
              _buildSearchBar(),
              _buildTabBar(),
              Expanded(child: _buildTabBarView()),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSize _buildAppBar() {
    final userProvider = context.watch<UserProvider>();
    final userName = userProvider.currentUser?.name ?? 'Usuário';
    final userImageUrl = userProvider.currentUser?.profilePictureUrl;

    ImageProvider profileImage = const AssetImage("assets/profile_default.png");
    if (userImageUrl != null && userImageUrl.isNotEmpty) {
      profileImage = NetworkImage(userImageUrl);
    }

    return PreferredSize(
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
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 21.0, vertical: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: TextButton(
                    onPressed: () =>
                        GoRouter.of(context).pushNamed("managerProfilePage"),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: profileImage,
                        ),
                        const SizedBox(width: 11.0),
                        Expanded(
                          child: Text(
                            'Olá, $userName 👋',
                            style: const TextStyle(
                              color: ConstantsColors.blueShade900,
                              fontSize: 20,
                            ).merge(TextStylesConstants.kpoppinsRegular),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 15.0),
                IconButton(
                  onPressed: () =>
                      GoRouter.of(context).pushNamed("notificationsPage"),
                  icon: Image.asset("assets/icons/notification_icon.png"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        onChanged: (value) =>
            _searchControllerProvider.updateSearchQuery(value),
        decoration: InputDecoration(
          hintText: 'O que você busca?',
          suffixIcon:
              const Icon(Icons.search, color: ConstantsColors.blueShade900),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(
              color: ConstantsColors.blueShade900,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(
              color: ConstantsColors.blueShade900,
              width: 1.5,
            ),
          ),
          filled: true,
          fillColor: ConstantsColors.whiteShade700,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      onTap: (index) {
        const categories = SearchCategory.values;
        _searchControllerProvider.updateCategory(categories[index]);
      },
      tabs: SearchCategory.values
          .map((category) => Tab(text: category.label))
          .toList(),
      labelColor: ConstantsColors.blueShade900,
      unselectedLabelColor: ConstantsColors.blackShade700,
      indicatorColor: ConstantsColors.blueShade900,
    );
  }

  Widget _buildTabBarView() {
    return Consumer<AppSearchController>(
      builder: (context, searchController, child) {
        if (searchController.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return TabBarView(
          controller: _tabController,
          children: SearchCategory.values
              .map((category) => GenericFilterPage(
                    category: category,
                    items: searchController.allItems,
                    searchQuery: searchController.searchQuery,
                  ))
              .toList(),
        );
      },
    );
  }
}
