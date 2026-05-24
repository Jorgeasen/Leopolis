import 'dart:math';

import 'word_data.dart';

class WordsRepository {
  WordsRepository._();

  static const List<WordData> _words = [
    // Nivel 1 — 2 sílabas
    WordData(
      palabra: 'mamá',
      imagenAsset: 'assets/images/words/mama.png',
      silabas: ['ma', 'má'],
      nivelDificultad: 1,
    ),
    WordData(
      palabra: 'papá',
      imagenAsset: 'assets/images/words/papa.png',
      silabas: ['pa', 'pá'],
      nivelDificultad: 1,
    ),
    WordData(
      palabra: 'gato',
      imagenAsset: 'assets/images/words/gato.png',
      silabas: ['ga', 'to'],
      nivelDificultad: 1,
    ),
    WordData(
      palabra: 'casa',
      imagenAsset: 'assets/images/words/casa.png',
      silabas: ['ca', 'sa'],
      nivelDificultad: 1,
    ),
    WordData(
      palabra: 'luna',
      imagenAsset: 'assets/images/words/luna.png',
      silabas: ['lu', 'na'],
      nivelDificultad: 1,
    ),
    WordData(
      palabra: 'pato',
      imagenAsset: 'assets/images/words/pato.png',
      silabas: ['pa', 'to'],
      nivelDificultad: 1,
    ),
    WordData(
      palabra: 'sopa',
      imagenAsset: 'assets/images/words/sopa.png',
      silabas: ['so', 'pa'],
      nivelDificultad: 1,
    ),
    WordData(
      palabra: 'mano',
      imagenAsset: 'assets/images/words/mano.png',
      silabas: ['ma', 'no'],
      nivelDificultad: 1,
    ),
    WordData(
      palabra: 'boca',
      imagenAsset: 'assets/images/words/boca.png',
      silabas: ['bo', 'ca'],
      nivelDificultad: 1,
    ),
    WordData(
      palabra: 'ojo',
      imagenAsset: 'assets/images/words/ojo.png',
      silabas: ['o', 'jo'],
      nivelDificultad: 1,
    ),
    WordData(
      palabra: 'nariz',
      imagenAsset: 'assets/images/words/nariz.png',
      silabas: ['na', 'riz'],
      nivelDificultad: 1,
    ),
    WordData(
      palabra: 'niño',
      imagenAsset: 'assets/images/words/nino.png',
      silabas: ['ni', 'ño'],
      nivelDificultad: 1,
    ),
    WordData(
      palabra: 'niña',
      imagenAsset: 'assets/images/words/nina.png',
      silabas: ['ni', 'ña'],
      nivelDificultad: 1,
    ),
    WordData(
      palabra: 'agua',
      imagenAsset: 'assets/images/words/agua.png',
      silabas: ['a', 'gua'],
      nivelDificultad: 1,
    ),
    WordData(
      palabra: 'sol',
      imagenAsset: 'assets/images/words/sol.png',
      silabas: ['sol'],
      nivelDificultad: 1,
    ),
    WordData(
      palabra: 'mar',
      imagenAsset: 'assets/images/words/mar.png',
      silabas: ['mar'],
      nivelDificultad: 1,
    ),
    WordData(
      palabra: 'pie',
      imagenAsset: 'assets/images/words/pie.png',
      silabas: ['pie'],
      nivelDificultad: 1,
    ),
    WordData(
      palabra: 'oreja',
      imagenAsset: 'assets/images/words/oreja.png',
      silabas: ['o', 're', 'ja'],
      nivelDificultad: 1,
    ),
    WordData(
      palabra: 'fuego',
      imagenAsset: 'assets/images/words/fuego.png',
      silabas: ['fue', 'go'],
      nivelDificultad: 1,
    ),
    WordData(
      palabra: 'aire',
      imagenAsset: 'assets/images/words/aire.png',
      silabas: ['ai', 're'],
      nivelDificultad: 1,
    ),
    // Nivel 2 — 3 sílabas
    WordData(
      palabra: 'árbol',
      imagenAsset: 'assets/images/words/arbol.png',
      silabas: ['ár', 'bol'],
      nivelDificultad: 2,
    ),
    WordData(
      palabra: 'pelota',
      imagenAsset: 'assets/images/words/pelota.png',
      silabas: ['pe', 'lo', 'ta'],
      nivelDificultad: 2,
    ),
    WordData(
      palabra: 'camisa',
      imagenAsset: 'assets/images/words/camisa.png',
      silabas: ['ca', 'mi', 'sa'],
      nivelDificultad: 2,
    ),
    WordData(
      palabra: 'zapato',
      imagenAsset: 'assets/images/words/zapato.png',
      silabas: ['za', 'pa', 'to'],
      nivelDificultad: 2,
    ),
    WordData(
      palabra: 'conejo',
      imagenAsset: 'assets/images/words/conejo.png',
      silabas: ['co', 'ne', 'jo'],
      nivelDificultad: 2,
    ),
    WordData(
      palabra: 'tortuga',
      imagenAsset: 'assets/images/words/tortuga.png',
      silabas: ['tor', 'tu', 'ga'],
      nivelDificultad: 2,
    ),
    WordData(
      palabra: 'mariposa',
      imagenAsset: 'assets/images/words/mariposa.png',
      silabas: ['ma', 'ri', 'po', 'sa'],
      nivelDificultad: 2,
    ),
    WordData(
      palabra: 'elefante',
      imagenAsset: 'assets/images/words/elefante.png',
      silabas: ['e', 'le', 'fan', 'te'],
      nivelDificultad: 3,
    ),
    WordData(
      palabra: 'cocodrilo',
      imagenAsset: 'assets/images/words/cocodrilo.png',
      silabas: ['co', 'co', 'dri', 'lo'],
      nivelDificultad: 3,
    ),
    WordData(
      palabra: 'dinosaurio',
      imagenAsset: 'assets/images/words/dinosaurio.png',
      silabas: ['di', 'no', 'sau', 'rio'],
      nivelDificultad: 3,
    ),
  ];

  static List<WordData> getAll() => List.unmodifiable(_words);

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

  static List<WordData> getRandomDistractors(String palabra, int count) {
    final others = _words.where((w) => w.palabra != palabra).toList()
      ..shuffle(Random());
    return others.take(count).toList();
  }
}
