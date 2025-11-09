import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:appdonationsgestor/controllers/campaign_controller.dart';
import 'package:appdonationsgestor/controllers/user_provider.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/components/popup.dart';
import 'package:provider/provider.dart';

class CampaignDetailsPage extends StatefulWidget {
  final String campaignId;

  const CampaignDetailsPage({
    super.key,
    required this.campaignId,
  });

  @override
  State<CampaignDetailsPage> createState() => _CampaignDetailsPageState();
}

class _CampaignDetailsPageState extends State<CampaignDetailsPage> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = context.read<UserProvider>();
      context.read<CampaignController>().loadCampaignByIdWithAuthor(
            widget.campaignId,
            userProvider.currentUser?.name,
            userProvider.currentUser?.profilePictureUrl,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CampaignController, UserProvider>(
      builder: (context, campaignController, userProvider, child) {
        final campaign = campaignController.selectedCampaign;
        final isLoading = campaignController.isLoading;
        final errorMessage = campaignController.errorMessage;

        final bool isAuthor =
            campaign?.authorName == (userProvider.currentUser?.name ?? '');

        if (isLoading) {
          return const Scaffold(
            backgroundColor: ConstantsColors.whiteShade700,
            body: Center(
              child: CircularProgressIndicator(
                color: ConstantsColors.blueShade900,
              ),
            ),
          );
        }

        if (errorMessage.isNotEmpty) {
          return Scaffold(
            backgroundColor: ConstantsColors.whiteShade700,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      campaignController.clearError();
                      campaignController.loadCampaignById(widget.campaignId);
                    },
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            ),
          );
        }

        if (campaign == null) {
          return const Scaffold(
            backgroundColor: ConstantsColors.whiteShade700,
            body: Center(
              child: Text(
                'Campanha não encontrada',
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: ConstantsColors.whiteShade700,
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: campaign.urlImagem.isNotEmpty
                          ? Image.network(
                              campaign.urlImagem,
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
                            )
                          : Container(
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
                    if (isAuthor)
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: ConstantsColors.blueShade900,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: ConstantsColors.whiteShade900,
                                ),
                                onPressed: () {
                                  GoRouter.of(context).push(
                                      '/campaignEdit/${widget.campaignId}');
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            CircleAvatar(
                              backgroundColor: Colors.red.shade700,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: ConstantsColors.whiteShade900,
                                ),
                                onPressed: () async {
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => const Dialog(
                                      backgroundColor: Colors.transparent,
                                      insetPadding:
                                          EdgeInsets.symmetric(horizontal: 24),
                                      child: Popup(
                                        title: "Excluir campanha",
                                        subtitle:
                                            "Tem certeza de que deseja excluir esta campanha?",
                                        confirmText: "Excluir",
                                        cancelText: "Cancelar",
                                        confirmButtonColor: Colors.redAccent,
                                      ),
                                    ),
                                  );

                                  if (confirmed == true) {
                                    final success = await campaignController
                                        .deleteCampaign(widget.campaignId);

                                    if (success) {
                                      Navigator.of(context).pop(true);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Campanha excluída com sucesso!",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color:
                                                  ConstantsColors.blackShade900,
                                            ).merge(TextStylesConstants
                                                .kinterRegular),
                                            textAlign: TextAlign.center,
                                          ),
                                          backgroundColor:
                                              ConstantsColors.blueShade400,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            campaignController.errorMessage,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          backgroundColor: Colors.red,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Positioned(
                        top: 16,
                        right: 16,
                        child: CircleAvatar(
                          backgroundColor: isFavorite
                              ? ConstantsColors.blueShade900
                              : Colors.grey.withOpacity(0.5),
                          child: IconButton(
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                isFavorite = !isFavorite;
                              });
                            },
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        campaignController.authorProfilePictureUrl != null
                            ? NetworkImage(
                                campaignController.authorProfilePictureUrl!)
                            : const AssetImage("assets/profile_default.png")
                                as ImageProvider,
                    radius: 22,
                  ),
                  title: Text(
                    campaign.authorName,
                    style: TextStylesConstants.kpoppinsSemiBold.merge(
                      const TextStyle(
                        color: ConstantsColors.blueShade900,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    campaign.titulo,
                    style: const TextStyle(
                      fontSize: 20,
                      color: ConstantsColors.blueShade900,
                      fontWeight: FontWeight.bold,
                    ).merge(TextStylesConstants.kpoppinsSemiBold),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    campaign.descricao,
                    style: const TextStyle(
                      fontSize: 14,
                      color: ConstantsColors.greyShade600,
                      height: 1.5,
                    ).merge(TextStylesConstants.kpoppinsMedium),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        color: ConstantsColors.blueShade900, size: 18),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        campaign.localizacao,
                        style: const TextStyle(
                          fontSize: 14,
                          color: ConstantsColors.greyShade600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined,
                        color: ConstantsColors.blueShade900, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      _formatDateRange(
                          campaign.dataInicial, campaign.dataFinal),
                      style: const TextStyle(
                        fontSize: 14,
                        color: ConstantsColors.greyShade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                if (!isAuthor)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ConstantsColors.blueShade900,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Interesse registrado! Contamos com a sua presença.",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15),
                            ),
                            backgroundColor: ConstantsColors.blueShade400,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Text(
                        "Quero Participar",
                        style: TextStylesConstants.kpoppinsMedium.merge(
                          const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Método para formatar o intervalo de datas
  String _formatDateRange(DateTime? dataInicial, DateTime? dataFinal) {
    if (dataInicial == null && dataFinal == null) {
      return 'Datas não definidas';
    }

    if (dataInicial == null) {
      return 'Até ${_formatDate(dataFinal!)}';
    }

    if (dataFinal == null) {
      return 'A partir de ${_formatDate(dataInicial)}';
    }

    return '${_formatDate(dataInicial)} a ${_formatDate(dataFinal)}';
  }

  // Método para formatar uma data individual
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
