import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:appdonationsgestor/pages/favorites_page.dart';
import 'package:appdonationsgestor/pages/home_page.dart';
import 'package:appdonationsgestor/pages/search_pages/search_page.dart';
import 'package:appdonationsgestor/pages/profile_pages/manager_profile_page.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _bottomNavIndex = 0;

  //lista das paginas
  List<Widget> pages = const [
    HomePage(),
    SearchPage(),
    SizedBox.shrink(),
    FavoritesPage(),
    ManagerProfilePage(),
  ];

  //lista de icones das paginas
  List<IconData> iconList = [
    Icons.home,
    Icons.list,
    Icons.add,
    Icons.favorite_outline,
    Icons.person_outline,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _bottomNavIndex,
        children: pages,
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        splashColor: ConstantsColors.blueShade500,
        activeColor: ConstantsColors.blueShade900,
        inactiveColor: ConstantsColors.blueShade900.withOpacity(.6),
        icons: iconList,
        iconSize: 28.0,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.none,
        notchSmoothness: NotchSmoothness.softEdge,
        onTap: (index) {
          if (index == 2) {
            _showBottomMenu(context);
          } else {
            setState(() {
              _bottomNavIndex = index;
            });
          }
        },
      ),
    );
  }

  void _showBottomMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 205, 239, 251),
            borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: ConstantsColors.blueShade900,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Text(
                'Comece a postar',
                style: const TextStyle(
                        fontSize: 20, color: ConstantsColors.blueShade900)
                    .merge(TextStylesConstants.kinterSemiBold),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.only(bottom: 30, left: 15, right: 15),
                    child: _BottomMenuOption(
                      icon: Icons.volunteer_activism_outlined,
                      label: 'Criar Necessidade/Doação',
                      onTap: () {
                        GoRouter.of(context).go("/itemPostPage");
                      },
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(bottom: 30, left: 15, right: 15),
                    child: _BottomMenuOption(
                      icon: Icons.post_add,
                      label: 'Criar publicação',
                      onTap: () {
                        GoRouter.of(context).go("/postPage");
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

class _BottomMenuOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BottomMenuOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Material(
            elevation: 8,
            shape: const CircleBorder(),
            shadowColor: ConstantsColors.blackShade900,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: const Color.fromARGB(255, 205, 239, 251),
              child: Icon(icon, size: 28, color: ConstantsColors.greyShade900),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
                    fontSize: 14, color: ConstantsColors.blueShade900)
                .merge(TextStylesConstants.kinterRegular),
          ),
        ],
      ),
    );
  }
}
