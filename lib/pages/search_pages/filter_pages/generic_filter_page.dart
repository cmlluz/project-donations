import 'package:flutter/material.dart';
import 'package:appdonationsgestor/components/image_card.dart';
import 'package:appdonationsgestor/components/search_item.dart';
import 'package:go_router/go_router.dart';

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
    final filteredItems = _getFilteredItems();

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

  List<SearchItem> _getFilteredItems() {
    var filtered = items;

    // Filter by category
    if (category != SearchCategory.todos) {
      filtered = filtered.where((item) => item.category == category).toList();
    }

    // Filter by search query
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
                child: ImageCard(
                  imageUrl: item.imageUrl,
                  title: 'Doação',
                  location: 'Salvador, Bahia',
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
    final route = _getDetailRoute(item.category);
    GoRouter.of(context).push('$route/${item.id}');
  }

  String _getDetailRoute(SearchCategory category) {
    switch (category) {
      case SearchCategory.doacao:
        return '/doacao-detail';
      case SearchCategory.necessidade:
        return '/necessidade-detail';
      case SearchCategory.instituicao:
        return '/instituicao-detail';
      default:
        return '/item-detail';
    }
  }
}
