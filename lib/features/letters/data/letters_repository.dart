import 'letter_data.dart';

class LettersRepository {
  LettersRepository._();

  static const List<LetterData> _letters = [
    LetterData(
        letra: 'A',
        palabraEjemplo: 'Árbol',
        imagenAsset: 'assets/images/letters/arbol.png'),
    LetterData(
        letra: 'B',
        palabraEjemplo: 'Barco',
        imagenAsset: 'assets/images/letters/barco.png'),
    LetterData(
        letra: 'C',
        palabraEjemplo: 'Casa',
        imagenAsset: 'assets/images/letters/casa.png'),
    LetterData(
        letra: 'D',
        palabraEjemplo: 'Delfín',
        imagenAsset: 'assets/images/letters/delfin.png'),
    LetterData(
        letra: 'E',
        palabraEjemplo: 'Estrella',
        imagenAsset: 'assets/images/letters/estrella.png'),
    LetterData(
        letra: 'F',
        palabraEjemplo: 'Flor',
        imagenAsset: 'assets/images/letters/flor.png'),
    LetterData(
        letra: 'G',
        palabraEjemplo: 'Gato',
        imagenAsset: 'assets/images/letters/gato.png'),
    LetterData(
        letra: 'H',
        palabraEjemplo: 'Helado',
        imagenAsset: 'assets/images/letters/helado.png'),
    LetterData(
        letra: 'I',
        palabraEjemplo: 'Iguana',
        imagenAsset: 'assets/images/letters/iguana.png'),
    LetterData(
        letra: 'J',
        palabraEjemplo: 'Jabón',
        imagenAsset: 'assets/images/letters/jabon.png'),
    LetterData(
        letra: 'K',
        palabraEjemplo: 'Koala',
        imagenAsset: 'assets/images/letters/koala.png'),
    LetterData(
        letra: 'L',
        palabraEjemplo: 'León',
        imagenAsset: 'assets/images/letters/leon.png'),
    LetterData(
        letra: 'M',
        palabraEjemplo: 'Mariposa',
        imagenAsset: 'assets/images/letters/mariposa.png'),
    LetterData(
        letra: 'N',
        palabraEjemplo: 'Nube',
        imagenAsset: 'assets/images/letters/nube.png'),
    LetterData(
        letra: 'Ñ',
        palabraEjemplo: 'Ñoño',
        imagenAsset: 'assets/images/letters/nonio.png'),
    LetterData(
        letra: 'O',
        palabraEjemplo: 'Oso',
        imagenAsset: 'assets/images/letters/oso.png'),
    LetterData(
        letra: 'P',
        palabraEjemplo: 'Pato',
        imagenAsset: 'assets/images/letters/pato.png'),
    LetterData(
        letra: 'Q',
        palabraEjemplo: 'Queso',
        imagenAsset: 'assets/images/letters/queso.png'),
    LetterData(
        letra: 'R',
        palabraEjemplo: 'Ratón',
        imagenAsset: 'assets/images/letters/raton.png'),
    LetterData(
        letra: 'S',
        palabraEjemplo: 'Sol',
        imagenAsset: 'assets/images/letters/sol.png'),
    LetterData(
        letra: 'T',
        palabraEjemplo: 'Tortuga',
        imagenAsset: 'assets/images/letters/tortuga.png'),
    LetterData(
        letra: 'U',
        palabraEjemplo: 'Uva',
        imagenAsset: 'assets/images/letters/uva.png'),
    LetterData(
        letra: 'V',
        palabraEjemplo: 'Vaca',
        imagenAsset: 'assets/images/letters/vaca.png'),
    LetterData(
        letra: 'W',
        palabraEjemplo: 'Wafle',
        imagenAsset: 'assets/images/letters/wafle.png'),
    LetterData(
        letra: 'X',
        palabraEjemplo: 'Xilófono',
        imagenAsset: 'assets/images/letters/xilofono.png'),
    LetterData(
        letra: 'Y',
        palabraEjemplo: 'Yoyo',
        imagenAsset: 'assets/images/letters/yoyo.png'),
    LetterData(
        letra: 'Z',
        palabraEjemplo: 'Zapato',
        imagenAsset: 'assets/images/letters/zapato.png'),
  ];

  static List<LetterData> getAll() => List.unmodifiable(_letters);

  static LetterData? getByLetter(String letter) {
    final upper = letter.toUpperCase();
    try {
      return _letters.firstWhere((l) => l.letra.toUpperCase() == upper);
    } catch (_) {
      return null;
    }
  }

  static LetterData? getNext(String letter) {
    final upper = letter.toUpperCase();
    final index = _letters.indexWhere((l) => l.letra.toUpperCase() == upper);
    if (index == -1) return null;
    return _letters[(index + 1) % _letters.length];
  }

  static LetterData? getPrevious(String letter) {
    final upper = letter.toUpperCase();
    final index = _letters.indexWhere((l) => l.letra.toUpperCase() == upper);
    if (index == -1) return null;
    return _letters[(index - 1 + _letters.length) % _letters.length];
  }
}
