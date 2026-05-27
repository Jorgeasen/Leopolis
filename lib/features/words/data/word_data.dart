import 'word_category.dart';

class WordData {
  const WordData({
    required this.palabra,
    required this.imagenAsset,
    required this.silabas,
    required this.nivelDificultad,
    this.emoji = '',
    this.category = WordCategory.objetos,
  });

  final String palabra;
  final String imagenAsset;
  final List<String> silabas;
  final int nivelDificultad;
  final String emoji;
  final WordCategory category;

  String get palabraCompleta => silabas.join();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordData &&
          runtimeType == other.runtimeType &&
          palabra == other.palabra;

  @override
  int get hashCode => palabra.hashCode;
}
