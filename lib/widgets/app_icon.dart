import 'package:flutter/material.dart';
import 'package:untitled6/utils/dimensions.dart';

class AppIcon extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final double size;
  var size45 = Dimensions.height45;
  AppIcon({Key? key,
    required this.icon,
    this.backgroundColor = const Color(0xFFfcf4ef),
    this.iconColor = const Color(0xFF756d54),
    this.size = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size/2),
        color: backgroundColor,
      ),
      child: Icon(icon,size: Dimensions.iconSize16,color: iconColor),
    );
  }
}
