import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  double height;

  SmallText({Key? key,
    this.color = const Color(0xFFccc7c5),
    required this.text,
    this.height = 1.2,
    this.size = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      key: Key(text),
      style: TextStyle(
        color: color,
        fontSize: size,
        height: height,
        fontFamily: "Roboto",
      ),
    );
  }
}
