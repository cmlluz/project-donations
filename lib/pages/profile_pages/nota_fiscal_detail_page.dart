import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';

class NotaFiscalDetailPage extends StatefulWidget {
  final String titulo;
  final List<String> imageUrls; // Aceita uma lista agora

  const NotaFiscalDetailPage({
    Key? key,
    required this.titulo,
    required this.imageUrls,
  }) : super(key: key);

  @override
  State<NotaFiscalDetailPage> createState() => _NotaFiscalDetailPageState();
}

class _NotaFiscalDetailPageState extends State<NotaFiscalDetailPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fundo escuro semitransparente para focar no conteúdo
      backgroundColor: Colors.black.withOpacity(0.9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.titulo,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: widget.imageUrls.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhuma imagem disponível',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : PageView.builder(
                      itemCount: widget.imageUrls.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return InteractiveViewer(
                          // Permite zoom na imagem
                          minScale: 0.5,
                          maxScale: 4.0,
                          child: Center(
                            child: Image.network(
                              widget.imageUrls[index],
                              fit: BoxFit.contain,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: ConstantsColors.blueShade900,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.broken_image,
                                        color: Colors.white, size: 50),
                                    SizedBox(height: 8),
                                    Text(
                                      "Erro ao carregar imagem",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
            if (widget.imageUrls.length > 1)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.imageUrls.asMap().entries.map((entry) {
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(
                          _currentIndex == entry.key ? 0.9 : 0.4,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}