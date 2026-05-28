class StoryData {
  const StoryData({
    required this.id,
    required this.titulo,
    required this.emoji,
    required this.paginas,
  });

  final String id;
  final String titulo;
  final String emoji;
  final List<StoryPage> paginas;
}

class StoryPage {
  const StoryPage({
    required this.frase,
    required this.imagenAsset,
    required this.emoji,
  });

  final String frase;
  final String imagenAsset;
  final String emoji;
}
