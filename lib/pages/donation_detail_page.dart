import 'package:appdonationsgestor/models/request_model.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/models/donation_model.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:appdonationsgestor/services/api_services/donation_api_service.dart';
import 'package:appdonationsgestor/services/api_services/favorites_api_service.dart';
import 'package:appdonationsgestor/services/api_services/request_api_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:appdonationsgestor/controllers/favorite_controller.dart';
import 'package:appdonationsgestor/controllers/user_provider.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

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
  late final DonationApiService _donationApiService;
  final ApiClient _apiClient = ApiClient();
  late String _currentPostStatus;

  late bool _isFavorite;
  bool _isLoadingFavorite = false;
  bool _isLoadingRequest = false;
  bool _hasRequestedItem = false;
  bool _hasApprovedRequest = false;
  int? _approvedRequestId;
  bool _isCheckingExistingRequest = true;
  late bool _actualOwnerView;

  Future<List<Request>>? _requestsFuture;

  @override
  void initState() {
    super.initState();
    _favoriteApiService = FavoriteApiService(_apiClient);
    _requestApiService = RequestApiService(_apiClient);
    _donationApiService = DonationApiService(_apiClient);
    _currentPostStatus = widget.donation.postStatus;
    _isFavorite = Provider.of<FavoriteController>(context, listen: false)
        .isDonationFavorite(widget.donation.id);

    final currentUserUid = Provider.of<UserProvider>(context, listen: false)
        .currentUser
        ?.firebaseUid;
    _actualOwnerView = widget.isOwnerView ||
        (currentUserUid != null &&
            widget.donation.donatorUid == currentUserUid);
    if (_actualOwnerView) {
      _requestsFuture =
          _requestApiService.getRequestsForItem(donationId: widget.donation.id);
    } else {
      _checkExistingRequest();
    }
  }

  Future<void> _checkExistingRequest() async {
    try {
      final sentRequests = await _requestApiService.getMySentRequests();

      final activeRequests = sentRequests
          .where((request) =>
              request.donation?.id == widget.donation.id &&
              (request.status == 'PENDENTE' || request.status == 'APROVADO'))
          .toList();

      if (mounted && activeRequests.isNotEmpty) {
        final existingRequest = activeRequests.first;
        setState(() {
          _hasRequestedItem = true;
          _hasApprovedRequest = existingRequest.status == 'APROVADO';
          _approvedRequestId = _hasApprovedRequest ? existingRequest.id : null;
          _isCheckingExistingRequest = false;
        });
      } else {
        if (mounted) {
          setState(() {
            _hasRequestedItem = false;
            _hasApprovedRequest = false;
            _approvedRequestId = null;
            _isCheckingExistingRequest = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasRequestedItem = false;
          _hasApprovedRequest = false;
          _approvedRequestId = null;
          _isCheckingExistingRequest = false;
        });
      }
    }
  }

  Future<void> _refreshDonationStatus() async {
    try {
      final updatedDonation = await _donationApiService
          .getDonationById(widget.donation.id.toString());
      if (mounted) {
        setState(() {
          _currentPostStatus = updatedDonation.postStatus;
        });
      }
    } catch (_) {
      // Ignora falha de atualização de status para não interromper a navegação.
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

  Future<bool> _confirmShareContactData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          title: const Text(
            'Compartilhar informações?',
            style: TextStyle(color: Colors.black87),
          ),
          content: Text(
            'Você concorda em compartilhar suas informações de contato para que ${widget.donation.donatorName} possa entrar em contato e a entrega possa ocorrer?',
            style: const TextStyle(color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.black54),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade700,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Concordo'),
            ),
          ],
        );
      },
    );

    return confirmed ?? false;
  }

  Future<void> _openConfirmationPage() async {
    if (_approvedRequestId == null) return;

    final result = await context.push<bool?>(
      '/confirmDonationPage',
      extra: _approvedRequestId,
    );

    if (result == true && mounted) {
      await _refreshDonationStatus();
    }
  }

  String _confirmedQuantityLabel() {
    return 'Quantidade que já foi recebida:';
  }

  String _traduzirPostStatus(String status) {
    switch (status) {
      case 'DISPONIVEL':
        return 'Disponível';
      case 'PENDENTE_APROVACAO':
        return 'Em Análise';
      case 'CONCLUIDO':
        return 'Concluído';
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
    final bool isDisponivel = _currentPostStatus == 'DISPONIVEL';

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
                if (!_actualOwnerView)
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
                        'Status: ${_traduzirPostStatus(_currentPostStatus)} | Quantidade: ${widget.donation.quantity}'),
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
                  if (_actualOwnerView)
                    _buildOwnerView()
                  else
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _hasApprovedRequest
                              ? Colors.green.shade700
                              : (_hasRequestedItem
                                  ? Colors.grey
                                  : ConstantsColors.blueShade900),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        onPressed: _isLoadingRequest ||
                                !isDisponivel ||
                                _isCheckingExistingRequest ||
                                (_hasRequestedItem && !_hasApprovedRequest)
                            ? null
                            : () async {
                                if (_hasApprovedRequest) {
                                  _openConfirmationPage();
                                  return;
                                }

                                final confirmed =
                                    await _confirmShareContactData();
                                if (!confirmed) return;
                                _submitRequest();
                              },
                        child: _isLoadingRequest || _isCheckingExistingRequest
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                _hasApprovedRequest
                                    ? "Inserir o Código"
                                    : _hasRequestedItem
                                        ? "Interesse Registrado"
                                        : isDisponivel
                                            ? "Quero Receber"
                                            : _traduzirPostStatus(
                                                _currentPostStatus),
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

            final requests = snapshot.data!
                .where((request) => request.status != 'REJEITADO')
                .toList();

            if (requests.isEmpty) {
              return const Center(
                  child: Text("Nenhuma solicitação para este item."));
            }

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
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Status: ${request.status}"),
                        if (request.status == 'APROVADO' &&
                            request.confirmedQuantity != null)
                          Text(
                            '${_confirmedQuantityLabel()} ${request.confirmedQuantity}',
                          ),
                        Text(
                          [
                            if (request.status == 'APROVADO')
                              'Código: ${request.confirmationCode ?? "SEM COD"}',
                            'Contato: ${request.solicitante.email}',
                            if (request.solicitante.phone != null &&
                                request.solicitante.phone!.isNotEmpty)
                              'Telefone: ${request.solicitante.phone}',
                          ].join(' | '),
                        ),
                      ],
                    ),
                    trailing: null,
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
