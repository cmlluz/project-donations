import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';

class RoundedBackgroundComponent extends StatelessWidget {
  final double height;
  final Widget child;

  const RoundedBackgroundComponent({
    super.key,
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: height),
                  decoration: const BoxDecoration(
                    color: ConstantsColors.whiteShade900,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: child,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
