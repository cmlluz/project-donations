import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:appdonationsgestor/pages/home_page.dart';
import 'package:appdonationsgestor/pages/search_page.dart';
import 'package:appdonationsgestor/pages/popup_menu_state.dart';
import 'package:appdonationsgestor/pages/profile_pages/manager_profile_page.dart';
import 'package:appdonationsgestor/pages/settings_page.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:flutter/material.dart';
// import 'package:appdonationsgestor/resources/text_styles.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _bottomNavIndex = 0;

  //lista das paginas
  List<Widget> pages = const [
    HomePage(),
    SearchPage(),
    PopupMenuState(),
    SettingsPage(),
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

  //Lista de titulos
  // List<String> titleList = [
  //   'Olá, Name 👋',
  //   'Olá, Name 👋',
  //   '',
  //   'Configurações',
  //   '',
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: titleList[_bottomNavIndex] == ''
      //     ? PreferredSize(
      //         preferredSize: _bottomNavIndex != 4
      //             ? const Size.fromHeight(-20)
      //             : const Size.fromHeight(-10),
      //         child: Container(
      //           color: _bottomNavIndex != 4
      //               ? ConstantsColors.tealShade200
      //               : ConstantsColors.whiteShade900,
      //         ), // espaço vazio com altura 20
      //       )
      //     : AppBar(
      //         title: Padding(
      //           padding: const EdgeInsets.only(top: 25.0, bottom: 30.0),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               Text(
      //                 titleList[_bottomNavIndex],
      //                 style: const TextStyle(
      //                   color: ConstantsColors.greyShade900,
      //                   fontSize: 30,
      //                 ).merge(TextStylesConstants.kpoppinsBold),
      //               ),
      //             ],
      //           ),
      //         ),
      //         elevation: 0.0,
      //       ),
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
          setState(() {
            _bottomNavIndex = index;
          });
        },
      ),
    );
  }
}
