import 'dart:math';

import 'word_category.dart';
import 'word_data.dart';

class WordsRepository {
  WordsRepository._();

  static const List<WordData> _words = [
    // --- ANIMALES ---
    WordData(
        palabra: 'gato',
        imagenAsset: 'assets/images/words/gato.png',
        silabas: ['ga', 'to'],
        nivelDificultad: 1,
        emoji: '🐱',
        category: WordCategory.animales),
    WordData(
        palabra: 'pato',
        imagenAsset: 'assets/images/words/pato.png',
        silabas: ['pa', 'to'],
        nivelDificultad: 1,
        emoji: '🦆',
        category: WordCategory.animales),
    WordData(
        palabra: 'perro',
        imagenAsset: 'assets/images/words/perro.png',
        silabas: ['pe', 'rro'],
        nivelDificultad: 1,
        emoji: '🐶',
        category: WordCategory.animales),
    WordData(
        palabra: 'vaca',
        imagenAsset: 'assets/images/words/vaca.png',
        silabas: ['va', 'ca'],
        nivelDificultad: 1,
        emoji: '🐮',
        category: WordCategory.animales),
    WordData(
        palabra: 'oso',
        imagenAsset: 'assets/images/words/oso.png',
        silabas: ['o', 'so'],
        nivelDificultad: 1,
        emoji: '🐻',
        category: WordCategory.animales),
    WordData(
        palabra: 'pez',
        imagenAsset: 'assets/images/words/pez.png',
        silabas: ['pez'],
        nivelDificultad: 1,
        emoji: '🐟',
        category: WordCategory.animales),
    WordData(
        palabra: 'rana',
        imagenAsset: 'assets/images/words/rana.png',
        silabas: ['ra', 'na'],
        nivelDificultad: 1,
        emoji: '🐸',
        category: WordCategory.animales),
    WordData(
        palabra: 'lobo',
        imagenAsset: 'assets/images/words/lobo.png',
        silabas: ['lo', 'bo'],
        nivelDificultad: 1,
        emoji: '🐺',
        category: WordCategory.animales),
    WordData(
        palabra: 'zorro',
        imagenAsset: 'assets/images/words/zorro.png',
        silabas: ['zo', 'rro'],
        nivelDificultad: 1,
        emoji: '🦊',
        category: WordCategory.animales),
    WordData(
        palabra: 'mono',
        imagenAsset: 'assets/images/words/mono.png',
        silabas: ['mo', 'no'],
        nivelDificultad: 1,
        emoji: '🐒',
        category: WordCategory.animales),
    WordData(
        palabra: 'conejo',
        imagenAsset: 'assets/images/words/conejo.png',
        silabas: ['co', 'ne', 'jo'],
        nivelDificultad: 2,
        emoji: '🐰',
        category: WordCategory.animales),
    WordData(
        palabra: 'tortuga',
        imagenAsset: 'assets/images/words/tortuga.png',
        silabas: ['tor', 'tu', 'ga'],
        nivelDificultad: 2,
        emoji: '🐢',
        category: WordCategory.animales),
    WordData(
        palabra: 'mariposa',
        imagenAsset: 'assets/images/words/mariposa.png',
        silabas: ['ma', 'ri', 'po', 'sa'],
        nivelDificultad: 2,
        emoji: '🦋',
        category: WordCategory.animales),
    WordData(
        palabra: 'elefante',
        imagenAsset: 'assets/images/words/elefante.png',
        silabas: ['e', 'le', 'fan', 'te'],
        nivelDificultad: 3,
        emoji: '🐘',
        category: WordCategory.animales),
    WordData(
        palabra: 'cocodrilo',
        imagenAsset: 'assets/images/words/cocodrilo.png',
        silabas: ['co', 'co', 'dri', 'lo'],
        nivelDificultad: 3,
        emoji: '🐊',
        category: WordCategory.animales),

    // --- FAMILIA ---
    WordData(
        palabra: 'mamá',
        imagenAsset: 'assets/images/words/mama.png',
        silabas: ['ma', 'má'],
        nivelDificultad: 1,
        emoji: '👩',
        category: WordCategory.familia),
    WordData(
        palabra: 'papá',
        imagenAsset: 'assets/images/words/papa.png',
        silabas: ['pa', 'pá'],
        nivelDificultad: 1,
        emoji: '👨',
        category: WordCategory.familia),
    WordData(
        palabra: 'niño',
        imagenAsset: 'assets/images/words/nino.png',
        silabas: ['ni', 'ño'],
        nivelDificultad: 1,
        emoji: '👦',
        category: WordCategory.familia),
    WordData(
        palabra: 'niña',
        imagenAsset: 'assets/images/words/nina.png',
        silabas: ['ni', 'ña'],
        nivelDificultad: 1,
        emoji: '👧',
        category: WordCategory.familia),
    WordData(
        palabra: 'bebé',
        imagenAsset: 'assets/images/words/bebe.png',
        silabas: ['be', 'bé'],
        nivelDificultad: 1,
        emoji: '👶',
        category: WordCategory.familia),
    WordData(
        palabra: 'abuelo',
        imagenAsset: 'assets/images/words/abuelo.png',
        silabas: ['a', 'bue', 'lo'],
        nivelDificultad: 2,
        emoji: '👴',
        category: WordCategory.familia),
    WordData(
        palabra: 'abuela',
        imagenAsset: 'assets/images/words/abuela.png',
        silabas: ['a', 'bue', 'la'],
        nivelDificultad: 2,
        emoji: '👵',
        category: WordCategory.familia),
    WordData(
        palabra: 'tío',
        imagenAsset: 'assets/images/words/tio.png',
        silabas: ['tí', 'o'],
        nivelDificultad: 1,
        emoji: '🧔',
        category: WordCategory.familia),
    WordData(
        palabra: 'tía',
        imagenAsset: 'assets/images/words/tia.png',
        silabas: ['tí', 'a'],
        nivelDificultad: 1,
        emoji: '👩',
        category: WordCategory.familia),
    WordData(
        palabra: 'primo',
        imagenAsset: 'assets/images/words/primo.png',
        silabas: ['pri', 'mo'],
        nivelDificultad: 1,
        emoji: '👦',
        category: WordCategory.familia),
    WordData(
        palabra: 'prima',
        imagenAsset: 'assets/images/words/prima.png',
        silabas: ['pri', 'ma'],
        nivelDificultad: 1,
        emoji: '👧',
        category: WordCategory.familia),
    WordData(
        palabra: 'hermano',
        imagenAsset: 'assets/images/words/hermano.png',
        silabas: ['her', 'ma', 'no'],
        nivelDificultad: 2,
        emoji: '👦',
        category: WordCategory.familia),
    WordData(
        palabra: 'hermana',
        imagenAsset: 'assets/images/words/hermana.png',
        silabas: ['her', 'ma', 'na'],
        nivelDificultad: 2,
        emoji: '👧',
        category: WordCategory.familia),
    WordData(
        palabra: 'familia',
        imagenAsset: 'assets/images/words/familia.png',
        silabas: ['fa', 'mi', 'lia'],
        nivelDificultad: 2,
        emoji: '👨‍👩‍👧',
        category: WordCategory.familia),
    WordData(
        palabra: 'amigo',
        imagenAsset: 'assets/images/words/amigo.png',
        silabas: ['a', 'mi', 'go'],
        nivelDificultad: 2,
        emoji: '🤝',
        category: WordCategory.familia),

    // --- COMIDA ---
    WordData(
        palabra: 'sopa',
        imagenAsset: 'assets/images/words/sopa.png',
        silabas: ['so', 'pa'],
        nivelDificultad: 1,
        emoji: '🍲',
        category: WordCategory.comida),
    WordData(
        palabra: 'pan',
        imagenAsset: 'assets/images/words/pan.png',
        silabas: ['pan'],
        nivelDificultad: 1,
        emoji: '🍞',
        category: WordCategory.comida),
    WordData(
        palabra: 'leche',
        imagenAsset: 'assets/images/words/leche.png',
        silabas: ['le', 'che'],
        nivelDificultad: 1,
        emoji: '🥛',
        category: WordCategory.comida),
    WordData(
        palabra: 'huevo',
        imagenAsset: 'assets/images/words/huevo.png',
        silabas: ['hue', 'vo'],
        nivelDificultad: 1,
        emoji: '🥚',
        category: WordCategory.comida),
    WordData(
        palabra: 'arroz',
        imagenAsset: 'assets/images/words/arroz.png',
        silabas: ['a', 'rroz'],
        nivelDificultad: 1,
        emoji: '🍚',
        category: WordCategory.comida),
    WordData(
        palabra: 'manzana',
        imagenAsset: 'assets/images/words/manzana.png',
        silabas: ['man', 'za', 'na'],
        nivelDificultad: 2,
        emoji: '🍎',
        category: WordCategory.comida),
    WordData(
        palabra: 'uva',
        imagenAsset: 'assets/images/words/uva.png',
        silabas: ['u', 'va'],
        nivelDificultad: 1,
        emoji: '🍇',
        category: WordCategory.comida),
    WordData(
        palabra: 'pera',
        imagenAsset: 'assets/images/words/pera.png',
        silabas: ['pe', 'ra'],
        nivelDificultad: 1,
        emoji: '🍐',
        category: WordCategory.comida),
    WordData(
        palabra: 'fresa',
        imagenAsset: 'assets/images/words/fresa.png',
        silabas: ['fre', 'sa'],
        nivelDificultad: 1,
        emoji: '🍓',
        category: WordCategory.comida),
    WordData(
        palabra: 'limón',
        imagenAsset: 'assets/images/words/limon.png',
        silabas: ['li', 'món'],
        nivelDificultad: 1,
        emoji: '🍋',
        category: WordCategory.comida),
    WordData(
        palabra: 'pollo',
        imagenAsset: 'assets/images/words/pollo.png',
        silabas: ['po', 'llo'],
        nivelDificultad: 1,
        emoji: '🍗',
        category: WordCategory.comida),
    WordData(
        palabra: 'queso',
        imagenAsset: 'assets/images/words/queso.png',
        silabas: ['que', 'so'],
        nivelDificultad: 1,
        emoji: '🧀',
        category: WordCategory.comida),
    WordData(
        palabra: 'pizza',
        imagenAsset: 'assets/images/words/pizza.png',
        silabas: ['pi', 'zza'],
        nivelDificultad: 1,
        emoji: '🍕',
        category: WordCategory.comida),
    WordData(
        palabra: 'pasta',
        imagenAsset: 'assets/images/words/pasta.png',
        silabas: ['pas', 'ta'],
        nivelDificultad: 1,
        emoji: '🍝',
        category: WordCategory.comida),
    WordData(
        palabra: 'torta',
        imagenAsset: 'assets/images/words/torta.png',
        silabas: ['tor', 'ta'],
        nivelDificultad: 1,
        emoji: '🎂',
        category: WordCategory.comida),

    // --- COLORES ---
    WordData(
        palabra: 'rojo',
        imagenAsset: 'assets/images/words/rojo.png',
        silabas: ['ro', 'jo'],
        nivelDificultad: 1,
        emoji: '🔴',
        category: WordCategory.colores),
    WordData(
        palabra: 'azul',
        imagenAsset: 'assets/images/words/azul.png',
        silabas: ['a', 'zul'],
        nivelDificultad: 1,
        emoji: '🔵',
        category: WordCategory.colores),
    WordData(
        palabra: 'verde',
        imagenAsset: 'assets/images/words/verde.png',
        silabas: ['ver', 'de'],
        nivelDificultad: 1,
        emoji: '🟢',
        category: WordCategory.colores),
    WordData(
        palabra: 'negro',
        imagenAsset: 'assets/images/words/negro.png',
        silabas: ['ne', 'gro'],
        nivelDificultad: 1,
        emoji: '⚫',
        category: WordCategory.colores),
    WordData(
        palabra: 'blanco',
        imagenAsset: 'assets/images/words/blanco.png',
        silabas: ['blan', 'co'],
        nivelDificultad: 1,
        emoji: '⚪',
        category: WordCategory.colores),
    WordData(
        palabra: 'rosa',
        imagenAsset: 'assets/images/words/rosa.png',
        silabas: ['ro', 'sa'],
        nivelDificultad: 1,
        emoji: '🌸',
        category: WordCategory.colores),
    WordData(
        palabra: 'gris',
        imagenAsset: 'assets/images/words/gris.png',
        silabas: ['gris'],
        nivelDificultad: 1,
        emoji: '🪨',
        category: WordCategory.colores),
    WordData(
        palabra: 'morado',
        imagenAsset: 'assets/images/words/morado.png',
        silabas: ['mo', 'ra', 'do'],
        nivelDificultad: 2,
        emoji: '🟣',
        category: WordCategory.colores),
    WordData(
        palabra: 'naranja',
        imagenAsset: 'assets/images/words/naranja.png',
        silabas: ['na', 'ran', 'ja'],
        nivelDificultad: 2,
        emoji: '🟠',
        category: WordCategory.colores),
    WordData(
        palabra: 'marrón',
        imagenAsset: 'assets/images/words/marron.png',
        silabas: ['ma', 'rrón'],
        nivelDificultad: 1,
        emoji: '🟤',
        category: WordCategory.colores),
    WordData(
        palabra: 'dorado',
        imagenAsset: 'assets/images/words/dorado.png',
        silabas: ['do', 'ra', 'do'],
        nivelDificultad: 2,
        emoji: '✨',
        category: WordCategory.colores),
    WordData(
        palabra: 'celeste',
        imagenAsset: 'assets/images/words/celeste.png',
        silabas: ['ce', 'les', 'te'],
        nivelDificultad: 2,
        emoji: '🌊',
        category: WordCategory.colores),
    WordData(
        palabra: 'lila',
        imagenAsset: 'assets/images/words/lila.png',
        silabas: ['li', 'la'],
        nivelDificultad: 1,
        emoji: '💜',
        category: WordCategory.colores),
    WordData(
        palabra: 'amarillo',
        imagenAsset: 'assets/images/words/amarillo.png',
        silabas: ['a', 'ma', 'ri', 'llo'],
        nivelDificultad: 2,
        emoji: '🟡',
        category: WordCategory.colores),
    WordData(
        palabra: 'violeta',
        imagenAsset: 'assets/images/words/violeta.png',
        silabas: ['vio', 'le', 'ta'],
        nivelDificultad: 2,
        emoji: '🫐',
        category: WordCategory.colores),

    // --- CUERPO ---
    WordData(
        palabra: 'mano',
        imagenAsset: 'assets/images/words/mano.png',
        silabas: ['ma', 'no'],
        nivelDificultad: 1,
        emoji: '✋',
        category: WordCategory.cuerpo),
    WordData(
        palabra: 'boca',
        imagenAsset: 'assets/images/words/boca.png',
        silabas: ['bo', 'ca'],
        nivelDificultad: 1,
        emoji: '👄',
        category: WordCategory.cuerpo),
    WordData(
        palabra: 'ojo',
        imagenAsset: 'assets/images/words/ojo.png',
        silabas: ['o', 'jo'],
        nivelDificultad: 1,
        emoji: '👁️',
        category: WordCategory.cuerpo),
    WordData(
        palabra: 'nariz',
        imagenAsset: 'assets/images/words/nariz.png',
        silabas: ['na', 'riz'],
        nivelDificultad: 1,
        emoji: '👃',
        category: WordCategory.cuerpo),
    WordData(
        palabra: 'pie',
        imagenAsset: 'assets/images/words/pie.png',
        silabas: ['pie'],
        nivelDificultad: 1,
        emoji: '🦶',
        category: WordCategory.cuerpo),
    WordData(
        palabra: 'oreja',
        imagenAsset: 'assets/images/words/oreja.png',
        silabas: ['o', 're', 'ja'],
        nivelDificultad: 1,
        emoji: '👂',
        category: WordCategory.cuerpo),
    WordData(
        palabra: 'dedo',
        imagenAsset: 'assets/images/words/dedo.png',
        silabas: ['de', 'do'],
        nivelDificultad: 1,
        emoji: '👆',
        category: WordCategory.cuerpo),
    WordData(
        palabra: 'rodilla',
        imagenAsset: 'assets/images/words/rodilla.png',
        silabas: ['ro', 'di', 'lla'],
        nivelDificultad: 2,
        emoji: '🦵',
        category: WordCategory.cuerpo),
    WordData(
        palabra: 'codo',
        imagenAsset: 'assets/images/words/codo.png',
        silabas: ['co', 'do'],
        nivelDificultad: 1,
        emoji: '💪',
        category: WordCategory.cuerpo),
    WordData(
        palabra: 'cuello',
        imagenAsset: 'assets/images/words/cuello.png',
        silabas: ['cue', 'llo'],
        nivelDificultad: 1,
        emoji: '🧣',
        category: WordCategory.cuerpo),
    WordData(
        palabra: 'hombro',
        imagenAsset: 'assets/images/words/hombro.png',
        silabas: ['hom', 'bro'],
        nivelDificultad: 1,
        emoji: '💪',
        category: WordCategory.cuerpo),
    WordData(
        palabra: 'frente',
        imagenAsset: 'assets/images/words/frente.png',
        silabas: ['fren', 'te'],
        nivelDificultad: 1,
        emoji: '😊',
        category: WordCategory.cuerpo),
    WordData(
        palabra: 'barriga',
        imagenAsset: 'assets/images/words/barriga.png',
        silabas: ['ba', 'rri', 'ga'],
        nivelDificultad: 2,
        emoji: '🫃',
        category: WordCategory.cuerpo),
    WordData(
        palabra: 'pierna',
        imagenAsset: 'assets/images/words/pierna.png',
        silabas: ['pier', 'na'],
        nivelDificultad: 1,
        emoji: '🦵',
        category: WordCategory.cuerpo),
    WordData(
        palabra: 'espalda',
        imagenAsset: 'assets/images/words/espalda.png',
        silabas: ['es', 'pal', 'da'],
        nivelDificultad: 2,
        emoji: '🧍',
        category: WordCategory.cuerpo),

    // --- OBJETOS ---
    WordData(
        palabra: 'casa',
        imagenAsset: 'assets/images/words/casa.png',
        silabas: ['ca', 'sa'],
        nivelDificultad: 1,
        emoji: '🏠',
        category: WordCategory.objetos),
    WordData(
        palabra: 'luna',
        imagenAsset: 'assets/images/words/luna.png',
        silabas: ['lu', 'na'],
        nivelDificultad: 1,
        emoji: '🌙',
        category: WordCategory.objetos),
    WordData(
        palabra: 'sol',
        imagenAsset: 'assets/images/words/sol.png',
        silabas: ['sol'],
        nivelDificultad: 1,
        emoji: '☀️',
        category: WordCategory.objetos),
    WordData(
        palabra: 'mar',
        imagenAsset: 'assets/images/words/mar.png',
        silabas: ['mar'],
        nivelDificultad: 1,
        emoji: '🌊',
        category: WordCategory.objetos),
    WordData(
        palabra: 'árbol',
        imagenAsset: 'assets/images/words/arbol.png',
        silabas: ['ár', 'bol'],
        nivelDificultad: 2,
        emoji: '🌳',
        category: WordCategory.objetos),
    WordData(
        palabra: 'agua',
        imagenAsset: 'assets/images/words/agua.png',
        silabas: ['a', 'gua'],
        nivelDificultad: 1,
        emoji: '💧',
        category: WordCategory.objetos),
    WordData(
        palabra: 'fuego',
        imagenAsset: 'assets/images/words/fuego.png',
        silabas: ['fue', 'go'],
        nivelDificultad: 1,
        emoji: '🔥',
        category: WordCategory.objetos),
    WordData(
        palabra: 'aire',
        imagenAsset: 'assets/images/words/aire.png',
        silabas: ['ai', 're'],
        nivelDificultad: 1,
        emoji: '💨',
        category: WordCategory.objetos),
    WordData(
        palabra: 'pelota',
        imagenAsset: 'assets/images/words/pelota.png',
        silabas: ['pe', 'lo', 'ta'],
        nivelDificultad: 2,
        emoji: '⚽',
        category: WordCategory.objetos),
    WordData(
        palabra: 'camisa',
        imagenAsset: 'assets/images/words/camisa.png',
        silabas: ['ca', 'mi', 'sa'],
        nivelDificultad: 2,
        emoji: '👕',
        category: WordCategory.objetos),
    WordData(
        palabra: 'zapato',
        imagenAsset: 'assets/images/words/zapato.png',
        silabas: ['za', 'pa', 'to'],
        nivelDificultad: 2,
        emoji: '👟',
        category: WordCategory.objetos),
    WordData(
        palabra: 'dinosaurio',
        imagenAsset: 'assets/images/words/dinosaurio.png',
        silabas: ['di', 'no', 'sau', 'rio'],
        nivelDificultad: 3,
        emoji: '🦕',
        category: WordCategory.animales),
    WordData(
        palabra: 'mesa',
        imagenAsset: 'assets/images/words/mesa.png',
        silabas: ['me', 'sa'],
        nivelDificultad: 1,
        emoji: '🪑',
        category: WordCategory.objetos),
    WordData(
        palabra: 'silla',
        imagenAsset: 'assets/images/words/silla.png',
        silabas: ['si', 'lla'],
        nivelDificultad: 1,
        emoji: '🪑',
        category: WordCategory.objetos),
    WordData(
        palabra: 'libro',
        imagenAsset: 'assets/images/words/libro.png',
        silabas: ['li', 'bro'],
        nivelDificultad: 1,
        emoji: '📚',
        category: WordCategory.objetos),
    WordData(
        palabra: 'lápiz',
        imagenAsset: 'assets/images/words/lapiz.png',
        silabas: ['lá', 'piz'],
        nivelDificultad: 1,
        emoji: '✏️',
        category: WordCategory.objetos),
    WordData(
        palabra: 'puerta',
        imagenAsset: 'assets/images/words/puerta.png',
        silabas: ['puer', 'ta'],
        nivelDificultad: 1,
        emoji: '🚪',
        category: WordCategory.objetos),
    WordData(
        palabra: 'cama',
        imagenAsset: 'assets/images/words/cama.png',
        silabas: ['ca', 'ma'],
        nivelDificultad: 1,
        emoji: '🛏️',
        category: WordCategory.objetos),
  ];

  static List<WordData> getAll() => List.unmodifiable(_words);

  static List<WordData> getByCategory(WordCategory category) =>
      _words.where((w) => w.category == category).toList();

  static List<WordData> getByLevel(int nivel) =>
      _words.where((w) => w.nivelDificultad == nivel).toList();

  static WordData? getByPalabra(String palabra) {
    try {
      return _words.firstWhere(
        (w) => w.palabra.toLowerCase() == palabra.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  static List<WordData> getRandomDistractors(
    String palabra,
    int count, {
    WordCategory? category,
  }) {
    final pool = category != null
        ? _words.where((w) => w.category == category).toList()
        : _words.toList();
    final others = pool.where((w) => w.palabra != palabra).toList()
      ..shuffle(Random());
    // Rellena con palabras de otras categorías si no hay suficientes distractores
    if (others.length < count) {
      final extra = _words
          .where(
            (w) => w.palabra != palabra && !others.contains(w),
          )
          .toList()
        ..shuffle(Random());
      others.addAll(extra.take(count - others.length));
    }
    return others.take(count).toList();
  }

  static List<String> getRandomSyllableDistractors(
    String syllable,
    int count, {
    WordCategory? category,
  }) {
    final pool = category != null
        ? _words.where((w) => w.category == category)
        : _words.cast<WordData>();
    final all = pool
        .expand((w) => w.silabas)
        .toSet()
        .where((s) => s != syllable)
        .toList()
      ..shuffle(Random());
    // Rellena si la categoría tiene pocas sílabas
    if (all.length < count) {
      final extra = _words
          .expand((w) => w.silabas)
          .toSet()
          .where((s) => s != syllable && !all.contains(s))
          .toList()
        ..shuffle(Random());
      all.addAll(extra.take(count - all.length));
    }
    return all.take(count).toList();
  }
}
