import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({
    super.key,
    required this.textName,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w500,
    this.color = Colors.black,
    this.textOverflow = TextOverflow.fade,
    this.textAlign = TextAlign.justify,
  });
  final String textName;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final TextOverflow textOverflow;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      textName,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        overflow: textOverflow,
      ),
    );
  }
}
