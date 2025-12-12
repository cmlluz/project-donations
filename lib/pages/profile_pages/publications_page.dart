import 'package:appdonationsgestor/controllers/user_provider.dart';
import 'package:appdonationsgestor/models/post_model.dart';
import 'package:appdonationsgestor/pages/post_detail_page.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:appdonationsgestor/services/api_services/post_api_service.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/components/card_item.dart';
import 'package:appdonationsgestor/components/popup.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PublicationsPage extends StatefulWidget {
  const PublicationsPage({super.key});

  @override
  State<PublicationsPage> createState() => _PublicationsPageState();
}

class _PublicationsPageState extends State<PublicationsPage> {
  late final PostApiService _postApiService;
  late Future<List<PostModel>> _postsFuture;

  bool isEditing = false;
  bool isDeleting = false;
  int? editingIndex;
  int? editingPostId;
  late TextEditingController _captionController;

  @override
  void initState() {
    super.initState();
    _postApiService = PostApiService(ApiClient());
    _captionController = TextEditingController();
    _loadPosts();
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  void _loadPosts() {
    final userUid = Provider.of<UserProvider>(context, listen: false)
        .currentUser
        ?.firebaseUid;

    if (userUid != null) {
      _postsFuture = _postApiService.getPostsByAuthor(userUid);
    } else {
      _postsFuture = Future.value([]);
    }
    setState(() {});
  }

  void startEditing(int index, PostModel post) {
    setState(() {
      editingIndex = index;
      editingPostId = post.id;
      _captionController.text = post.caption;
    });
  }

  Future<void> saveEditing() async {
    if (editingPostId != null) {
      try {
        await _postApiService.updatePostCaption(
            editingPostId!, _captionController.text.trim());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Descrição atualizada com sucesso!"),
            backgroundColor: ConstantsColors.blueShade900,
            behavior: SnackBarBehavior.floating,
          ),
        );

        setState(() {
          editingIndex = null;
          editingPostId = null;
          isEditing = false;
        });

        _loadPosts();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao salvar: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> confirmDelete(int postId) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Popup(
          title: "Excluir publicação",
          subtitle: "Tem certeza de que deseja excluir este post?",
          confirmText: "Confirmar",
          cancelText: "Cancelar",
          confirmButtonColor: ConstantsColors.redShade900,
        ),
      ),
    );

    if (result == true) {
      try {
        await _postApiService.deletePost(postId);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Publicação excluída com sucesso!"),
              backgroundColor: ConstantsColors.blueShade900,
              behavior: SnackBarBehavior.floating,
            ),
          );
          _loadPosts();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Erro ao excluir: $e"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
    setState(() => isDeleting = false);
  }

  String _traduzirStatus(String status) {
    switch (status) {
      case 'PENDENTE_APROVACAO':
        return 'Em Análise';
      case 'DISPONIVEL':
        return 'Publicado';
      case 'REJEITADO':
        return 'Rejeitado';
      default:
        return '';
    }
  }

  Color _corStatus(String status) {
    switch (status) {
      case 'PENDENTE_APROVACAO':
        return Colors.orange;
      case 'DISPONIVEL':
        return Colors.green;
      case 'REJEITADO':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final userName = userProvider.currentUser?.name ?? "Usuário";
    final userPhoto = userProvider.currentUser?.profilePictureUrl ??
        "https://via.placeholder.com/150";

    return Scaffold(
      backgroundColor: ConstantsColors.whiteShade900,
      appBar: AppBar(
        backgroundColor: ConstantsColors.whiteShade900,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back, color: ConstantsColors.blueShade900),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Minhas Publicações",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: ConstantsColors.blueShade900,
          ).merge(TextStylesConstants.kpoppinsMedium),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isEditing ? Icons.check : Icons.edit,
              color: ConstantsColors.blueShade900,
            ),
            onPressed: () {
              if (isEditing && editingIndex != null) {
                saveEditing();
              } else {
                setState(() {
                  isEditing = !isEditing;
                  isDeleting = false;
                  editingIndex = null;
                });
              }
            },
          ),
          IconButton(
            icon: Icon(
              isDeleting ? Icons.close : Icons.delete_outline,
              color: isDeleting
                  ? ConstantsColors.redShade900
                  : ConstantsColors.blueShade900,
            ),
            onPressed: () {
              setState(() {
                isDeleting = !isDeleting;
                isEditing = false;
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<PostModel>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          }

          final posts = snapshot.data ?? [];

          if (posts.isEmpty) {
            return const Center(child: Text("Você ainda não tem publicações."));
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 12),
            separatorBuilder: (_, __) => const SizedBox(height: 20),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final pub = posts[index];
              final formattedDate =
                  DateFormat('dd MMM, yyyy').format(pub.createdAt);
              final isThisBeingEdited = isEditing && editingIndex == index;

              return GestureDetector(
                onTap: () {
                  if (isEditing) {
                    if (isThisBeingEdited) {
                    } else {
                      startEditing(index, pub);
                    }
                  } else if (isDeleting) {
                    confirmDelete(pub.id);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetailPage(post: pub),
                      ),
                    );
                  }
                },
                child: Stack(
                  children: [
                    CardItem(
                      title: userName,
                      subtitle: isThisBeingEdited
                          ? null
                          : "${_traduzirStatus(pub.postStatus)} - ${pub.caption}",
                      avatarUrl: userPhoto,
                      location: "Salvador, Bahia",
                      date: formattedDate,
                      imageAsset: pub.imageUrl,
                    ),
                    if (!isThisBeingEdited)
                      Positioned(
                        top: 20,
                        right: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _corStatus(pub.postStatus).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(color: _corStatus(pub.postStatus)),
                          ),
                          child: Text(
                            _traduzirStatus(pub.postStatus),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _corStatus(pub.postStatus),
                            ),
                          ),
                        ),
                      ),
                    if (isThisBeingEdited)
                      Positioned.fill(
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          color: Colors.white.withOpacity(0.95),
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("Editar Legenda",
                                  style: TextStyle(
                                      color: ConstantsColors.blueShade900,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _captionController,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  hintText: "Edite a legenda...",
                                  filled: true,
                                  fillColor: ConstantsColors.greyShade200,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: saveEditing,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ConstantsColors.blueShade900,
                                ),
                                child: const Text("Salvar",
                                    style: TextStyle(color: Colors.white)),
                              )
                            ],
                          ),
                        ),
                      ),
                    if (isDeleting)
                      Positioned.fill(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.delete,
                              color: ConstantsColors.redShade900,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
