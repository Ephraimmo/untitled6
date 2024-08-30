import 'package:flutter/material.dart';
import 'package:untitled6/utils/dimensions.dart';

class BigText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  TextOverflow overFlow;

  BigText({Key? key,
    this.color = const Color(0xFF332d2b),
    required this.text,
    this.size = 20,
    this.overFlow = TextOverflow.ellipsis
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      key: Key(text),
      maxLines: 1,
      overflow: overFlow,
      style: TextStyle(
        color: color,
        fontSize: Size == 0? Dimensions.font20 : size,
        fontWeight: FontWeight.w400,
        fontFamily: "Roboto",
      ),
    );
  }
}
