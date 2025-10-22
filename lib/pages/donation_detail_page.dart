import 'package:flutter/material.dart';
import 'package:appdonationsgestor/models/donation_model.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/services/api_services.dart';
import 'package:intl/intl.dart';

class DonationDetailPage extends StatefulWidget {
  final Donation donation;

  const DonationDetailPage({Key? key, required this.donation}) : super(key: key);

  @override
  State<DonationDetailPage> createState() => _DonationDetailPageState();
}

class _DonationDetailPageState extends State<DonationDetailPage> {
  final ApiService _apiService = ApiService();
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.donation.isFavorite;
  }

  /*void _toggleFavorite() async {
    final newFavoriteState = !_isFavorite;
    const type = 'doacao';
    final id = widget.donation.id.toString();

    try {
      if (newFavoriteState) {
        await _apiService.addFavorite(type, id);
      } else {
        await _apiService.removeFavorite(type, id);
      }
      setState(() {
        _isFavorite = newFavoriteState;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(newFavoriteState ? 'Adicionado aos favoritos!' : 'Removido dos favoritos.'),
          backgroundColor: ConstantsColors.blueShade900,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar favorito: $e')),
      );
    }
  }*/

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('dd/MM/yyyy').format(widget.donation.date ?? DateTime.now());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(Icons.volunteer_activism,
                      size: 100, color: Colors.grey),
                ),
                Positioned(
                  top: 50,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: ConstantsColors.blueShade900,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  right: 16,
                  child: CircleAvatar(
                    backgroundColor: _isFavorite
                        ? ConstantsColors.blueShade900
                        : Colors.grey.withOpacity(0.5),
                    child: const IconButton(
                      icon: Icon(Icons.favorite, color: Colors.white),
                      onPressed: null, //_toggleFavorite,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.donation.title,
                    style: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold)
                        .merge(TextStylesConstants.kinterSemiBold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Publicado em $formattedDate',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.business)),
                    title: Text(
                      widget.donation.donatorName,
                      style: const TextStyle(
                              fontSize: 18, color: ConstantsColors.blueShade900)
                          .merge(TextStylesConstants.kinterSemiBold),
                    ),
                    subtitle: Text(
                        'Status: ${widget.donation.status} | Quantidade: ${widget.donation.quantity}'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Detalhes da Doação",
                    style: const TextStyle(
                            fontSize: 22, color: ConstantsColors.blueShade900)
                        .merge(TextStylesConstants.kpoppinsMedium),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      widget.donation.description,
                      style: const TextStyle(
                              fontSize: 16, color: ConstantsColors.greyShade600)
                          .merge(TextStylesConstants.kpoppinsMedium),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ConstantsColors.blueShade900,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Quero Receber",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
