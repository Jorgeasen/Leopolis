import 'package:flutter/material.dart';

class LetterData {
  const LetterData({
    required this.letra,
    required this.palabraEjemplo,
    required this.imagenAsset,
    this.emoji = '',
    this.colorDestacado = const Color(0xFF2196F3),
  });

  final String letra;
  final String palabraEjemplo;
  final String imagenAsset;
  final String emoji;
  final Color colorDestacado;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LetterData &&
          runtimeType == other.runtimeType &&
          letra == other.letra;

  @override
  int get hashCode => letra.hashCode;
}
