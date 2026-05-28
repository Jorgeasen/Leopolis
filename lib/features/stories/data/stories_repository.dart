import 'story_data.dart';

class StoriesRepository {
  StoriesRepository._();

  static const List<StoryData> _stories = [
    StoryData(
      id: 'gato_raton',
      titulo: 'El gato y el ratón',
      emoji: '🐱',
      paginas: [
        StoryPage(
          frase: 'El gato ve al ratón.',
          imagenAsset: 'assets/images/stories/gato_raton_1.png',
          emoji: '🐱👀',
        ),
        StoryPage(
          frase: 'El ratón corre rápido.',
          imagenAsset: 'assets/images/stories/gato_raton_2.png',
          emoji: '🐭💨',
        ),
        StoryPage(
          frase: 'El gato corre también.',
          imagenAsset: 'assets/images/stories/gato_raton_3.png',
          emoji: '🐱🏃',
        ),
        StoryPage(
          frase: 'El ratón se esconde.',
          imagenAsset: 'assets/images/stories/gato_raton_4.png',
          emoji: '🐭🌿',
        ),
        StoryPage(
          frase: 'El gato no lo ve.',
          imagenAsset: 'assets/images/stories/gato_raton_5.png',
          emoji: '🐱❓',
        ),
        StoryPage(
          frase: 'El ratón está contento.',
          imagenAsset: 'assets/images/stories/gato_raton_6.png',
          emoji: '🐭😊',
        ),
      ],
    ),
    StoryData(
      id: 'casa_leo',
      titulo: 'La casa de Leo',
      emoji: '🏠',
      paginas: [
        StoryPage(
          frase: 'Leo vive en una casa.',
          imagenAsset: 'assets/images/stories/casa_leo_1.png',
          emoji: '👦🏠',
        ),
        StoryPage(
          frase: 'La casa es roja.',
          imagenAsset: 'assets/images/stories/casa_leo_2.png',
          emoji: '🏠❤️',
        ),
        StoryPage(
          frase: 'Leo tiene un perro.',
          imagenAsset: 'assets/images/stories/casa_leo_3.png',
          emoji: '👦🐶',
        ),
        StoryPage(
          frase: 'El perro se llama Luna.',
          imagenAsset: 'assets/images/stories/casa_leo_4.png',
          emoji: '🐾🌙',
        ),
        StoryPage(
          frase: 'Leo y Luna son amigos.',
          imagenAsset: 'assets/images/stories/casa_leo_5.png',
          emoji: '👦🤝🐶',
        ),
      ],
    ),
    StoryData(
      id: 'sol_lluvia',
      titulo: 'El sol y la lluvia',
      emoji: '☀️',
      paginas: [
        StoryPage(
          frase: 'El sol brilla en el cielo.',
          imagenAsset: 'assets/images/stories/sol_lluvia_1.png',
          emoji: '☀️',
        ),
        StoryPage(
          frase: 'Las flores abren sus pétalos.',
          imagenAsset: 'assets/images/stories/sol_lluvia_2.png',
          emoji: '🌸',
        ),
        StoryPage(
          frase: 'Llegan las nubes grises.',
          imagenAsset: 'assets/images/stories/sol_lluvia_3.png',
          emoji: '☁️',
        ),
        StoryPage(
          frase: 'Cae la lluvia sobre las flores.',
          imagenAsset: 'assets/images/stories/sol_lluvia_4.png',
          emoji: '🌧️',
        ),
        StoryPage(
          frase: 'Las flores beben el agua.',
          imagenAsset: 'assets/images/stories/sol_lluvia_5.png',
          emoji: '💧🌸',
        ),
        StoryPage(
          frase: 'El sol vuelve a brillar.',
          imagenAsset: 'assets/images/stories/sol_lluvia_6.png',
          emoji: '☀️🌈',
        ),
      ],
    ),
    StoryData(
      id: 'pez_mar',
      titulo: 'El pez en el mar',
      emoji: '🐟',
      paginas: [
        StoryPage(
          frase: 'Hay un pez en el mar.',
          imagenAsset: 'assets/images/stories/pez_mar_1.png',
          emoji: '🐟🌊',
        ),
        StoryPage(
          frase: 'El pez es azul y grande.',
          imagenAsset: 'assets/images/stories/pez_mar_2.png',
          emoji: '🐟💙',
        ),
        StoryPage(
          frase: 'El pez nada y nada.',
          imagenAsset: 'assets/images/stories/pez_mar_3.png',
          emoji: '🌊',
        ),
        StoryPage(
          frase: 'Ve a un cangrejo rojo.',
          imagenAsset: 'assets/images/stories/pez_mar_4.png',
          emoji: '🦀',
        ),
        StoryPage(
          frase: 'Los dos son amigos del mar.',
          imagenAsset: 'assets/images/stories/pez_mar_5.png',
          emoji: '🐟🦀',
        ),
      ],
    ),
  ];

  static List<StoryData> getAll() => _stories;

  static StoryData? getById(String id) {
    for (final story in _stories) {
      if (story.id == id) return story;
    }
    return null;
  }
}
