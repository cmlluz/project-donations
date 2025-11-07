import 'package:appdonationsgestor/models/donation_model.dart';
import 'package:appdonationsgestor/models/need_model.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:appdonationsgestor/services/api_services/donation_api_service.dart';
import 'package:appdonationsgestor/services/api_services/needs_api_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AllowPostPage extends StatefulWidget {
  final String itemId;
  final String itemType;

  const AllowPostPage({
    Key? key,
    required this.itemId,
    required this.itemType,
  }) : super(key: key);

  @override
  State<AllowPostPage> createState() => _AllowPostPageState();
}

class _AllowPostPageState extends State<AllowPostPage> {
  final ApiClient _apiClient = ApiClient();
  late final DonationApiService _donationApiService;
  late final NeedApiService _needApiService;

  bool _isLoading = true;
  bool _isProcessing = false;
  String? _error;

  String _title = '';
  String _description = '';
  String _authorName = '';
  String _imageUrl = 'assets/donations.jpg';

  @override
  void initState() {
    super.initState();
    _donationApiService = DonationApiService(_apiClient);
    _needApiService = NeedApiService(_apiClient);
    _loadItemData();
  }

  Future<void> _loadItemData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      if (widget.itemType == "DONATION") {
        Donation item =
            await _donationApiService.getDonationById(widget.itemId);
        _title = item.title;
        _description = item.description;
        _authorName = item.donatorName;
      } else if (widget.itemType == "NEED") {
        Need item = await _needApiService.getNeedById(widget.itemId);
        _title = item.title;
        _description = item.description;
        _authorName = item.authorName;
      } else {
        throw Exception("Tipo de item desconhecido");
      }
    } catch (e) {
      _error = "Erro ao carregar item: $e";
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleApproval(bool approve) async {
    setState(() => _isProcessing = true);

    try {
      if (widget.itemType == "DONATION") {
        if (approve) {
          await _donationApiService.approveDonation(widget.itemId);
        } else {
          await _donationApiService.rejectDonation(widget.itemId);
        }
      } else if (widget.itemType == "NEED") {
        if (approve) {
          await _needApiService.approveNeed(widget.itemId);
        } else {
          await _needApiService.rejectNeed(widget.itemId);
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                approve ? "Postagem permitida!" : "Postagem não permitida."),
            backgroundColor: ConstantsColors.blueShade900,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.go('/root');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao processar: $e"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child:
                      Text(_error!, style: const TextStyle(color: Colors.red)))
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 50, left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.asset(
                  _imageUrl,
                  width: double.infinity,
                  height: 400,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 400,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: CircleAvatar(
                  backgroundColor: ConstantsColors.blueShade900,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: ConstantsColors.whiteShade900,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.business),
            ),
            title: Text(
              _authorName,
              style: const TextStyle(
                fontSize: 16,
                color: ConstantsColors.blueShade900,
              ).merge(TextStylesConstants.kinterSemiBold),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "Detalhes - $_title",
                style: const TextStyle(
                  fontSize: 22,
                  color: ConstantsColors.blueShade900,
                ).merge(TextStylesConstants.kpoppinsMedium),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              _description,
              style: const TextStyle(
                fontSize: 16,
                color: ConstantsColors.greyShade600,
              ).merge(TextStylesConstants.kpoppinsMedium),
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ConstantsColors.blueShade900,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: _isProcessing ? null : () => _handleApproval(true),
              child: _isProcessing
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      "Permitir postagem",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ).merge(TextStylesConstants.kpoppinsMedium),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ConstantsColors.redShade900,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: _isProcessing ? null : () => _handleApproval(false),
              child: Text(
                "Não permitir postagem",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ).merge(TextStylesConstants.kpoppinsMedium),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
