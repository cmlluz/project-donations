import 'package:appdonationsgestor/models/donation_model.dart';
import 'package:appdonationsgestor/pages/donation_detail_page.dart';
import 'package:appdonationsgestor/pages/need_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/components/image_card.dart';
import 'package:appdonationsgestor/components/search_item.dart';
import 'package:appdonationsgestor/models/need_model.dart';
import 'package:go_router/go_router.dart';
import 'package:appdonationsgestor/pages/profile_pages/institution_profile_page.dart';
import 'package:appdonationsgestor/controllers/user_provider.dart';
import 'package:provider/provider.dart';

class GenericFilterPage extends StatelessWidget {
  final SearchCategory category;
  final List<SearchItem> items;
  final String? searchQuery;

  const GenericFilterPage({
    super.key,
    required this.category,
    required this.items,
    this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final currentUserUid = Provider.of<UserProvider>(context, listen: false).currentUser?.firebaseUid;
    
    final filteredItems = _getFilteredItems(currentUserUid);

    if (filteredItems.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Nenhum resultado encontrado',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        childAspectRatio: 0.85,
      ),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return _buildItemCard(context, item);
      },
    );
  }

  List<SearchItem> _getFilteredItems(String? currentUserUid) {
    var filtered = items;

    if (currentUserUid != null) {
      filtered = filtered.where((item) {
        if (item.category == SearchCategory.instituicao) return true;
        
        return item.authorUid != currentUserUid;
      }).toList();
    }

    if (category != SearchCategory.todos) {
      filtered = filtered.where((item) => item.category == category).toList();
    }

    if (searchQuery != null && searchQuery!.isNotEmpty) {
      filtered = filtered
          .where((item) =>
              item.title.toLowerCase().contains(searchQuery!.toLowerCase()) ||
              item.description
                  .toLowerCase()
                  .contains(searchQuery!.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  Widget _buildItemCard(BuildContext context, SearchItem item) {
    final isNetwork = item.imageUrl.startsWith('http');

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _navigateToDetail(context, item),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: AbsorbPointer(
                  child: ImageCard(
                    imageUrl: item.imageUrl,
                    isNetworkImage: isNetwork,
                    title: _getCardTitle(item),
                    onTap: null,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, SearchItem item) {
    if (item.category == SearchCategory.necessidade) {
      final need = Need(
          id: item.id,
          title: item.title,
          description: item.description,
          authorName: item.institution,
          authorUid: item.authorUid,
          category: item.category.toString(),
          quantity: item.quantity,
          postStatus: item.postStatus,
          date: item.date,
          imageUrl: item.imageUrl); 

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NeedDetailPage(need: need),
        ),
      );
    } else if (item.category == SearchCategory.doacao) {
      final donation = Donation(
          id: item.id,
          title: item.title,
          description: item.description,
          donatorName: item.institution,
          donatorUid: item.authorUid,
          category: item.category.toString(),
          quantity: item.quantity,
          postStatus: item.postStatus,
          date: item.date,
          imageUrl: item.imageUrl); 
          
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DonationDetailPage(donation: donation),
        ),
      );
    } else if (item.category == SearchCategory.campanha) {
      GoRouter.of(context).push('/campaignDetails/${item.id}');
    } else if (item.category == SearchCategory.instituicao) {
      if (item.firebaseUid != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InstitutionProfilePage(
              userId: item.firebaseUid!,
              userName: item.title,
              userEmail: item.description.contains('@') ? item.description : '',
              userImageUrl: item.imageUrl,
              isInitiallyFavorite: false,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Não foi possível carregar dados da instituição.')),
        );
      }
    }
  }

  String _getCardTitle(SearchItem item) {
    switch (item.category) {
      case SearchCategory.campanha:
        if (item.title.length > 15) {
          return '${item.title.substring(0, 15)}...';
        }
        return item.title;
      case SearchCategory.doacao:
        return 'Doação';
      case SearchCategory.necessidade:
        return 'Necessidade';
      case SearchCategory.instituicao:
        return 'Instituição';
      default:
        return item.category.label;
    }
  }
}