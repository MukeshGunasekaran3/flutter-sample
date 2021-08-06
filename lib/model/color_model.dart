import 'package:flutter/material.dart';

class ColorModel {
  Color? _color1;
  Color? _color2;

  Color? get color1 => _color1;

  Color? get color2 => _color2;

  ColorModel({Color? color1, Color? color2}) {
    _color1 = color1;
    _color2 = color2;
  }
}
