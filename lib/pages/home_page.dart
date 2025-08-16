import 'package:appdonationsgestor/components/card_item.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/components/popup.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override

  // Display do popup de atualização cadastral
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) {
  //         final screenWidth = MediaQuery.of(context).size.width;
  //         final dialogWidth = screenWidth * 0.9;

  //         return AlertDialog(
  //           backgroundColor: ConstantsColors.blueShade400,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(20),
  //           ),
  //           content: SizedBox(
  //             width: dialogWidth,
  //             child: const Popup(
  //               title: "Seus dados estão desatualizados",
  //               subtitle:
  //                   "Complete as suas informações e utilize todas as funcionalidades que <nome do app> tem para lhe oferecer!",
  //               confirmText: "Atualizar agora",
  //               cancelText: "Me lembre mais tarde",
  //               confirmRoute: "/editProfilePage",
  //             ),
  //           ),
  //         );
  //       },
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromRGBO(252, 251, 248, 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                offset: const Offset(0, 1),
                blurRadius: 2,
                spreadRadius: 0,
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 21.0, vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () =>
                        GoRouter.of(context).pushNamed("managerProfilePage"),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size.zero,
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundImage: AssetImage("assets/profile.jpg"),
                        ),
                        const SizedBox(width: 11.0),
                        Text(
                          'Olá, Name 👋',
                          style: const TextStyle(
                            color: ConstantsColors.blueShade900,
                            fontSize: 20,
                          ).merge(TextStylesConstants.kpoppinsRegular),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      GoRouter.of(context).push('/notificationsPage');
                    },
                    icon: Image.asset("assets/icons/notification_icon.png"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          itemCount: 13,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.only(left: 10.0),
                    horizontalTitleGap: 12.0,
                    leading: const CircleAvatar(
                      backgroundImage: NetworkImage(
                        "https://imgs.search.brave.com/EH557LzfsHTfIMbszf0VhVSjTAxp2YIL1olc8zaL-ic/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9zdGF0/aWM2LmRlcG9zaXRw/aG90b3MuY29tLzEw/MzExNzQvNTk0L2kv/NDUwL2RlcG9zaXRw/aG90b3NfNTk0MjE0/MS1zdG9jay1waG90/by1ncm91cC1vZi1w/YXBlcmNoYWluLWhv/bGRpbmctaGFuZHMu/anBn",
                      ),
                    ),
                    title: Text(
                      "Lar dos idosos",
                      style: const TextStyle(
                        color: ConstantsColors.blackShade900,
                        fontSize: 16,
                      ).merge(TextStylesConstants.kinterSemiBold),
                    ),
                  ),
                  const CardItem(),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 10.0),
                    child: Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing",
                      style: const TextStyle(
                        color: ConstantsColors.greyShade900,
                        fontSize: 14,
                      ).merge(TextStylesConstants.kpoppinsMedium),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
