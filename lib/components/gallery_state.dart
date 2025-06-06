import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  late OverlayEntry _popupDialog;
  List<String> imageUrls = [
    'https://imgs.search.brave.com/IzCeCU8PrEZ9T52ad2djo7oiwnH7Oue-3x_MKTRFZek/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9tZWRp/YS5pc3RvY2twaG90/by5jb20vaWQvMTM1/MzMzMjI1OC9waG90/by9kb25hdGlvbi1j/b25jZXB0LXRoZS12/b2x1bnRlZXItZ2l2/aW5nLWEtZG9uYXRl/LWJveC10by10aGUt/cmVjaXBpZW50LXN0/YW5kaW5nLWFnYWlu/c3QtdGhlLXdhbGwu/d2VicD9iPTEmcz0x/NzA2NjdhJnc9MCZr/PTIwJmM9RDUzZHk0/SFBsZkxpOXlDTzhv/dW93SW45SHFJV2Zr/akV4NC1DMDVCOFRZ/VT0',
    'https://imgs.search.brave.com/IzCeCU8PrEZ9T52ad2djo7oiwnH7Oue-3x_MKTRFZek/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9tZWRp/YS5pc3RvY2twaG90/by5jb20vaWQvMTM1/MzMzMjI1OC9waG90/by9kb25hdGlvbi1j/b25jZXB0LXRoZS12/b2x1bnRlZXItZ2l2/aW5nLWEtZG9uYXRl/LWJveC10by10aGUt/cmVjaXBpZW50LXN0/YW5kaW5nLWFnYWlu/c3QtdGhlLXdhbGwu/d2VicD9iPTEmcz0x/NzA2NjdhJnc9MCZr/PTIwJmM9RDUzZHk0/SFBsZkxpOXlDTzhv/dW93SW45SHFJV2Zr/akV4NC1DMDVCOFRZ/VT0',
    'https://imgs.search.brave.com/IzCeCU8PrEZ9T52ad2djo7oiwnH7Oue-3x_MKTRFZek/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9tZWRp/YS5pc3RvY2twaG90/by5jb20vaWQvMTM1/MzMzMjI1OC9waG90/by9kb25hdGlvbi1j/b25jZXB0LXRoZS12/b2x1bnRlZXItZ2l2/aW5nLWEtZG9uYXRl/LWJveC10by10aGUt/cmVjaXBpZW50LXN0/YW5kaW5nLWFnYWlu/c3QtdGhlLXdhbGwu/d2VicD9iPTEmcz0x/NzA2NjdhJnc9MCZr/PTIwJmM9RDUzZHk0/SFBsZkxpOXlDTzhv/dW93SW45SHFJV2Zr/akV4NC1DMDVCOFRZ/VT0',
    'https://imgs.search.brave.com/IzCeCU8PrEZ9T52ad2djo7oiwnH7Oue-3x_MKTRFZek/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9tZWRp/YS5pc3RvY2twaG90/by5jb20vaWQvMTM1/MzMzMjI1OC9waG90/by9kb25hdGlvbi1j/b25jZXB0LXRoZS12/b2x1bnRlZXItZ2l2/aW5nLWEtZG9uYXRl/LWJveC10by10aGUt/cmVjaXBpZW50LXN0/YW5kaW5nLWFnYWlu/c3QtdGhlLXdhbGwu/d2VicD9iPTEmcz0x/NzA2NjdhJnc9MCZr/PTIwJmM9RDUzZHk0/SFBsZkxpOXlDTzhv/dW93SW45SHFJV2Zr/akV4NC1DMDVCOFRZ/VT0',
    'https://imgs.search.brave.com/IzCeCU8PrEZ9T52ad2djo7oiwnH7Oue-3x_MKTRFZek/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9tZWRp/YS5pc3RvY2twaG90/by5jb20vaWQvMTM1/MzMzMjI1OC9waG90/by9kb25hdGlvbi1j/b25jZXB0LXRoZS12/b2x1bnRlZXItZ2l2/aW5nLWEtZG9uYXRl/LWJveC10by10aGUt/cmVjaXBpZW50LXN0/YW5kaW5nLWFnYWlu/c3QtdGhlLXdhbGwu/d2VicD9iPTEmcz0x/NzA2NjdhJnc9MCZr/PTIwJmM9RDUzZHk0/SFBsZkxpOXlDTzhv/dW93SW45SHFJV2Zr/akV4NC1DMDVCOFRZ/VT0',
    'https://imgs.search.brave.com/IzCeCU8PrEZ9T52ad2djo7oiwnH7Oue-3x_MKTRFZek/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9tZWRp/YS5pc3RvY2twaG90/by5jb20vaWQvMTM1/MzMzMjI1OC9waG90/by9kb25hdGlvbi1j/b25jZXB0LXRoZS12/b2x1bnRlZXItZ2l2/aW5nLWEtZG9uYXRl/LWJveC10by10aGUt/cmVjaXBpZW50LXN0/YW5kaW5nLWFnYWlu/c3QtdGhlLXdhbGwu/d2VicD9iPTEmcz0x/NzA2NjdhJnc9MCZr/PTIwJmM9RDUzZHk0/SFBsZkxpOXlDTzhv/dW93SW45SHFJV2Zr/akV4NC1DMDVCOFRZ/VT0',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Scaffold(
        body: Expanded(
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            children: imageUrls.map(_createGridTileWidget).toList(),
          ),
        ),
      ),
    );
  }

  Widget _createGridTileWidget(String url) => SizedBox(
        height: 200,
        width: 300,
        child: Builder(
          builder: (context) => GestureDetector(
            onLongPress: () {
              _popupDialog = _createPopupDialog(url);
              Overlay.of(context).insert(_popupDialog);
            },
            onLongPressEnd: (details) => _popupDialog.remove(),
            child: Image.network(url, fit: BoxFit.cover),
          ),
        ),
      );

  OverlayEntry _createPopupDialog(String url) {
    return OverlayEntry(
      builder: (context) => AnimatedDialog(
        child: _createPopupContent(url),
      ),
    );
  }

  Widget _createPhotoTitle() => Container(
      width: double.infinity,
      color: ConstantsColors.whiteShade900,
      child: const ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage('https://placeimg.com/640/480/people'),
        ),
        title: Text(
          'john.doe',
          style: TextStylesConstants.kgalleryStateText,
        ),
      ));

  Widget _createActionBar() => Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        color: ConstantsColors.whiteShade900,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.favorite_border,
              color: ConstantsColors.blackShade900,
            ),
            Icon(
              Icons.chat_bubble_outline_outlined,
              color: ConstantsColors.blackShade900,
            ),
            Icon(
              Icons.send,
              color: ConstantsColors.blackShade900,
            ),
          ],
        ),
      );

  Widget _createPopupContent(String url) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _createPhotoTitle(),
              Image.network(url, fit: BoxFit.fitWidth),
              _createActionBar(),
            ],
          ),
        ),
      );
}

class AnimatedDialog extends StatefulWidget {
  const AnimatedDialog({super.key, this.child});

  final Widget? child;

  @override
  State<StatefulWidget> createState() => AnimatedDialogState();
}

class AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> opacityAnimation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeOutExpo);
    opacityAnimation = Tween<double>(begin: 0.0, end: 0.6).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutExpo));

    controller.addListener(() => setState(() {}));
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ConstantsColors.blackShade900.withOpacity(opacityAnimation.value),
      child: Center(
        child: FadeTransition(
          opacity: scaleAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
