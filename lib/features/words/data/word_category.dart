enum WordCategory { animales, familia, comida, colores, cuerpo, objetos }

extension WordCategoryX on WordCategory {
  String get nombre {
    switch (this) {
      case WordCategory.animales:
        return 'Animales';
      case WordCategory.familia:
        return 'Familia';
      case WordCategory.comida:
        return 'Comida';
      case WordCategory.colores:
        return 'Colores';
      case WordCategory.cuerpo:
        return 'Cuerpo';
      case WordCategory.objetos:
        return 'Objetos';
    }
  }

  String get emoji {
    switch (this) {
      case WordCategory.animales:
        return '🐾';
      case WordCategory.familia:
        return '👨‍👩‍👧';
      case WordCategory.comida:
        return '🍎';
      case WordCategory.colores:
        return '🎨';
      case WordCategory.cuerpo:
        return '👤';
      case WordCategory.objetos:
        return '🏠';
    }
  }
}
