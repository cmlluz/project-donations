import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';

class CardItem extends StatefulWidget {
  const CardItem({
    super.key,
    this.onTap,
    required this.title,
    this.subtitle,
    required this.avatarUrl,
    required this.location,
    required this.date,
    required this.imageAsset,
  });

  final VoidCallback? onTap;
  final String title;
  final String? subtitle;
  final String avatarUrl;
  final String location;
  final String date;
  final String imageAsset;

  @override
  State<CardItem> createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  bool _isExpanded = false;
  bool _isOverflowing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOverflow());
  }

  void _checkOverflow() {
    if (widget.subtitle == null) return;

    final textSpan = TextSpan(
      text: widget.subtitle,
      style: const TextStyle(
        color: ConstantsColors.blueShade900,
        fontSize: 14,
      ).merge(TextStylesConstants.kpoppinsMedium),
    );

    final tp = TextPainter(
      text: textSpan,
      maxLines: 2,
      textDirection: TextDirection.ltr,
    );

    tp.layout(maxWidth: MediaQuery.of(context).size.width - 60);
    // 60 ≈ padding lateral (27 + 13 + margem extra)

    if (mounted) {
      setState(() {
        _isOverflowing = tp.didExceedMaxLines;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25.0),
        child: Material(
          color: ConstantsColors.whiteShade900,
          child: InkWell(
            onTap: widget.onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(widget.avatarUrl),
                          ),
                          const SizedBox(width: 9),
                          Text(
                            widget.title,
                            style: const TextStyle(
                              color: ConstantsColors.blueShade900,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ).merge(TextStylesConstants.kinterRegular),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset("assets/icons/location_icon.png"),
                          const SizedBox(width: 4),
                          Text(
                            "${widget.location}, ${widget.date}",
                            style: const TextStyle(
                              color: ConstantsColors.greyShade500,
                              fontSize: 10,
                            ).merge(TextStylesConstants.kinterRegular),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Subtítulo com Ver Mais (condicional)
                if (widget.subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 27.0, top: 15.0, bottom: 15.0, right: 13.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.subtitle!,
                          style: const TextStyle(
                            color: ConstantsColors.blueShade900,
                            fontSize: 14,
                          ).merge(TextStylesConstants.kpoppinsMedium),
                          maxLines: _isExpanded ? null : 2,
                          overflow: _isExpanded
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                        ),
                        if (_isOverflowing) ...[
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isExpanded = !_isExpanded;
                              });
                            },
                            child: Text(
                              _isExpanded ? "Ver menos" : "Ver mais",
                              style: const TextStyle(
                                color: ConstantsColors.blueShade900,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),

                // Imagem do card
                Container(
                  height: 230.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    image: DecorationImage(
                      image: AssetImage(widget.imageAsset),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
