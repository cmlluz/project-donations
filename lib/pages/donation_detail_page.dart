import 'package:appdonationsgestor/models/request_model.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/models/donation_model.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:appdonationsgestor/services/api_services/favorites_api_service.dart';
import 'package:appdonationsgestor/services/api_services/request_api_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:appdonationsgestor/controllers/favorite_controller.dart';
import 'package:flutter/services.dart';

class DonationDetailPage extends StatefulWidget {
  final Donation donation;
  final bool isOwnerView;

  const DonationDetailPage({
    Key? key,
    required this.donation,
    this.isOwnerView = false,
  }) : super(key: key);

  @override
  State<DonationDetailPage> createState() => _DonationDetailPageState();
}

class _DonationDetailPageState extends State<DonationDetailPage> {
  late final FavoriteApiService _favoriteApiService;
  late final RequestApiService _requestApiService;
  final ApiClient _apiClient = ApiClient();

  late bool _isFavorite;
  bool _isLoadingFavorite = false;
  bool _isLoadingRequest = false;
  bool _hasRequestedItem = false;

  Future<List<Request>>? _requestsFuture;

  @override
  void initState() {
    super.initState();
    _favoriteApiService = FavoriteApiService(_apiClient);
    _requestApiService = RequestApiService(_apiClient);
    _isFavorite = Provider.of<FavoriteController>(context, listen: false)
        .isDonationFavorite(widget.donation.id);

    if (widget.isOwnerView) {
      _requestsFuture =
          _requestApiService.getRequestsForItem(donationId: widget.donation.id);
    }
  }

  void _toggleFavorite() async {
    if (_isLoadingFavorite) return;

    final newFavoriteState = !_isFavorite;
    final favController =
        Provider.of<FavoriteController>(context, listen: false);

    setState(() {
      _isLoadingFavorite = true;
      _isFavorite = newFavoriteState;
    });

    try {
      if (newFavoriteState) {
        await favController.addFavoriteDonation(widget.donation);
      } else {
        await favController.removeFavoriteDonation(widget.donation);
      }
      widget.donation.isFavorite = newFavoriteState;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(newFavoriteState
                ? 'Adicionado aos favoritos!'
                : 'Removido dos favoritos.'),
            backgroundColor: ConstantsColors.blueShade900,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isFavorite = !newFavoriteState;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar favorito: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingFavorite = false;
        });
      }
    }
  }

  void _submitRequest() async {
    if (_hasRequestedItem || _isLoadingRequest) return;

    setState(() => _isLoadingRequest = true);

    try {
      await _requestApiService.createRequest(
        donationId: widget.donation.id,
        needId: null,
      );

      if (mounted) {
        setState(() {
          _hasRequestedItem = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Solicitação enviada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao enviar solicitação: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingRequest = false);
      }
    }
  }

  String _traduzirPostStatus(String status) {
    switch (status) {
      case 'DISPONIVEL':
        return 'Disponível';
      case 'PENDENTE_APROVACAO':
        return 'Em Análise';
      case 'CONCLUIDO':
        return 'Entregue';
      case 'REJEITADO':
        return 'Rejeitado';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('dd/MM/yyyy').format(widget.donation.date ?? DateTime.now());
    final bool isDisponivel = widget.donation.postStatus == 'DISPONIVEL';

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
                  child: widget.donation.imageUrl != null &&
                          widget.donation.imageUrl!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(25)),
                          child: Image.network(
                            widget.donation.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image,
                                    size: 100, color: Colors.grey),
                          ),
                        )
                      : const Icon(Icons.volunteer_activism,
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
                if (!widget.isOwnerView)
                  Positioned(
                    top: 50,
                    right: 16,
                    child: CircleAvatar(
                      backgroundColor: _isFavorite
                          ? ConstantsColors.blueShade900
                          : Colors.grey.withOpacity(0.5),
                      child: IconButton(
                        icon: Icon(
                            _isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.white),
                        onPressed: _isLoadingFavorite ? null : _toggleFavorite,
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
                        'Status: ${_traduzirPostStatus(widget.donation.postStatus)} | Quantidade: ${widget.donation.quantity}'),
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
                  if (widget.isOwnerView)
                    _buildOwnerView()
                  else
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _hasRequestedItem
                              ? Colors.grey
                              : ConstantsColors.blueShade900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        onPressed: _isLoadingRequest ||
                                !isDisponivel ||
                                _hasRequestedItem
                            ? null
                            : _submitRequest,
                        child: _isLoadingRequest
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                _hasRequestedItem
                                    ? "Interesse Registrado"
                                    : isDisponivel
                                        ? "Quero Receber"
                                        : _traduzirPostStatus(
                                            widget.donation.postStatus),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
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

  Widget _buildOwnerView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Solicitações Recebidas",
          style:
              const TextStyle(fontSize: 22, color: ConstantsColors.blueShade900)
                  .merge(TextStylesConstants.kpoppinsMedium),
        ),
        const SizedBox(height: 10),
        FutureBuilder<List<Request>>(
          future: _requestsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                  child:
                      Text("Erro ao carregar solicitações: ${snapshot.error}"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                  child: Text("Nenhuma solicitação para este item."));
            }

            final requests = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: request.solicitante.profilePictureUrl !=
                              null
                          ? NetworkImage(request.solicitante.profilePictureUrl!)
                          : null,
                      child: request.solicitante.profilePictureUrl == null
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    title: Text(request.solicitante.name,
                        style: TextStylesConstants.kpoppinsMedium),
                    subtitle: Text("Status: ${request.status}"),
                    trailing: request.status == 'APROVADO'
                        ? SelectableText(
                            request.confirmationCode ?? "SEM COD",
                            style: TextStylesConstants.kpoppinsBold
                                .copyWith(color: ConstantsColors.blueShade900),
                          )
                        : null,
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
