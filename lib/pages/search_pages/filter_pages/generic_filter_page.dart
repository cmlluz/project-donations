import 'package:appdonationsgestor/pages/need_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/components/image_card.dart';
import 'package:appdonationsgestor/components/search_item.dart';
import 'package:appdonationsgestor/models/need_model.dart';

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
                    title: 'Doação',
                    location: 'Salvador, Bahia',
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
          category: item.category.toString(),
          quantity: item.quantity,
          status: item.status,
          date: item.date);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NeedDetailPage(need: need),
        ),
      );
    } else {
      // Mantenha a sua lógica existente para outros tipos de itens, como Posts
      // Exemplo:
      // final post = PostModel(...);
      // GoRouter.of(context).push('/postDetailPage', extra: post);
    }
  }
}
