# CLAUDE.md

This file provides guidance to Claude Code when working in this repository.

## Project Overview

**Leópolis** es una app educativa Flutter para que **Leo** (6 años) aprenda el abecedario español, palabras y escritura. Targets: Windows 11, Android tablet, iPad.

- Repo: https://github.com/Jorgeasen/Leopolis
- Dev principal: Jorge (experiencia .NET, aprendiendo Flutter e IA)
- CI/CD: GitHub Actions (.github/workflows/) — sin secrets externos, usa GITHUB_TOKEN gratuito
- Agentes IA: ai-review.yml (revisa PRs), ai-issue-agent.yml (analiza issues) — ambos con GitHub Models/GPT-4o

---

## Commands

```bash
# Instalar dependencias
flutter pub get

# Generar código (OBLIGATORIO tras tocar app_router.dart o providers Riverpod)
dart run build_runner build --delete-conflicting-outputs

# Ejecutar en Windows (target principal de desarrollo)
flutter run -d windows

# Tests
flutter test --coverage

# Análisis estático (CI usa --fatal-infos)
flutter analyze --fatal-infos

# Formato (CI falla si hay violaciones)
dart format --output=none --set-exit-if-changed .
dart format .   # para arreglar

# Builds
flutter build apk --debug
flutter build windows --debug

# Limpieza total
flutter clean && flutter pub get
```

---

## Architecture

Feature-based bajo `lib/`:

- `main.dart` — entrada, orientación landscape preferida en tablets
- `app.dart` — ProviderScope (Riverpod) + tema Material3 + go_router
- `core/`
  - `router/app_router.dart` — go_router con anotación Riverpod; `app_router.g.dart` es generado
  - `theme/app_theme.dart` — Material3, paleta por módulo
  - `constants/app_constants.dart` — rutas, claves SharedPreferences, reglas de gamificación
- `features/` — home/, letters/, words/, games/, rewards/ (cada uno con presentation/ y data/)
- `shared/` — widgets reutilizables (LeoButton) y modelos

**Estado**: Riverpod (infraestructura lista, uso mínimo en screens aún).
**Navegación**: go_router centralizado. Tras modificar app_router.dart → re-ejecutar build_runner.
**Audio/TTS**: flutter_tts configurado es-ES (velocidad 0.4, tono 1.1). audioplayers para efectos.

---

## Key Conventions

- Todo el texto de UI en **español**; TTS locale `es-ES`
- **Touch targets mínimo 64px** — dedos de 6 años
- **Fuente Fredoka** — redondeada, legible para niños. No cambiar a otra fuente
- Colores del tema: Primary `#FF8C00` naranja, Secondary `#4CAF50` verde, Background `#FFF8E1` crema
- Colores por módulo: Letters=Azul `#2196F3`, Words=Morado `#9C27B0`, Games=Rojo-naranja `#FF5722`, Rewards=Dorado `#FFD700`
- Linting: return types, const constructors, single quotes. Excluir `*.g.dart`, `*.freezed.dart`
- SharedPreferences keys: usar constantes de `app_constants.dart`, nunca strings literales
- Assets: images/ audio/ animations/ fonts/ — todas las carpetas deben existir aunque estén vacías

---

## UX Rules para niños de 6 años

Estas reglas son **no negociables** al diseñar cualquier pantalla:

1. **Feedback inmediato** — cada toque debe responder en < 100ms con sonido o animación
2. **Sin texto de instrucciones largas** — máximo 5 palabras por mensaje, mejor con emoji
3. **Sin pantallas de error intimidantes** — si algo falla, Leo ve al leoncito diciendo "¡Vamos a intentarlo otra vez! 🦁"
4. **Celebración exagerada** — cuando acierta: animación + sonido de fanfarria + estrellas
5. **Nunca mostrar puntuaciones negativas** — solo mostrar lo que ha conseguido, nunca lo que le falta
6. **Botón de volver siempre visible** — Leo no sabe que existe el gesto "atrás" del sistema
7. **Alto contraste** — fondo claro, texto oscuro, nunca gris claro sobre blanco

---

## Module Status

| Módulo   | Estado     | Notas |
|----------|------------|-------|
| Home     | ✅ Completo | 4 tarjetas de navegación, gradiente de fondo |
| Letters  | 🔧 Base    | Grid abecedario + TTS. Falta trazado de letras |
| Words    | 📋 Placeholder | Solo pantalla vacía |
| Games    | 📋 Placeholder | Solo pantalla vacía |
| Rewards  | 📋 Placeholder | Solo pantalla vacía |

---

## Development Roadmap

### 🔴 v1.0 — Las Letras (PRIORIDAD AHORA)

**Objetivo**: Leo puede ver, escuchar y trazar cada letra del abecedario.

#### 1.1 Pantalla de detalle de letra
- [ ] Al tocar una letra en el grid, navegar a `LetterDetailScreen`
- [ ] Mostrar la letra en mayúscula y minúscula (grande, centrada)
- [ ] Botón "Escuchar" → TTS pronuncia la letra
- [ ] Botón "Escuchar palabra" → TTS pronuncia una palabra de ejemplo (A de "Árbol")
- [ ] Imagen/ilustración de la palabra de ejemplo
- [ ] Botones Anterior / Siguiente para navegar entre letras
- [ ] Archivo: `lib/features/letters/presentation/letter_detail_screen.dart`

#### 1.2 Datos de letras
- [ ] Crear modelo `LetterData` con: letra, palabraEjemplo, imagenAsset, colorDestacado
- [ ] Crear `letters_repository.dart` con la lista completa de 27 letras
- [ ] Archivo: `lib/features/letters/data/letters_repository.dart`

#### 1.3 Trazado de letras con el dedo
- [ ] Usar `CustomPainter` + `GestureDetector` para capturar el trazo del dedo
- [ ] Mostrar la letra en gris de fondo como guía
- [ ] Evaluar si el trazo se aproxima a la letra (algoritmo simple de bounding box)
- [ ] Si es correcto: animación de estrella + sonido de acierto
- [ ] Archivo: `lib/features/letters/presentation/letter_tracing_screen.dart`
- [ ] Widget reutilizable: `lib/shared/widgets/tracing_canvas.dart`

#### 1.4 Progreso de letras
- [ ] Provider `lettersProgressProvider` — guarda qué letras ha completado Leo
- [ ] Persistir en SharedPreferences con clave `AppConstants.prefLettersCompleted`
- [ ] En el grid de letras: mostrar check verde en las ya completadas
- [ ] Archivo: `lib/features/letters/data/letters_progress_provider.dart`

---

### 🟡 v1.1 — Las Palabras

**Objetivo**: Leo asocia imagen con palabra escrita y aprende sílabas.

#### 2.1 Banco de palabras
- [ ] Crear modelo `WordData`: palabra, imagenAsset, silabas[], nivelDificultad
- [ ] Empezar con 30 palabras de 2-3 sílabas simples (mamá, papá, gato, casa…)
- [ ] Archivo: `lib/features/words/data/words_repository.dart`

#### 2.2 Ejercicio: imagen → palabra
- [ ] Mostrar imagen + 3 opciones de palabra (una correcta, dos distractores)
- [ ] Al tocar la correcta: celebración
- [ ] Al tocar incorrecta: shake animation + "¡Inténtalo otra vez!"
- [ ] Archivo: `lib/features/words/presentation/word_match_screen.dart`

#### 2.3 Ejercicio: completar sílaba
- [ ] Mostrar palabra con una sílaba faltando: "GA___" → el niño elige entre opciones
- [ ] Archivo: `lib/features/words/presentation/syllable_screen.dart`

---

### 🟢 v1.2 — Juegos

**Objetivo**: Consolidar lo aprendido jugando.

#### 3.1 Juego: Letras que caen
- [ ] Letras caen desde arriba, Leo toca la que el leoncito pide
- [ ] Velocidad aumenta progresivamente
- [ ] Archivo: `lib/features/games/presentation/falling_letters_game.dart`

#### 3.2 Juego: La letra perdida
- [ ] Mostrar una palabra con una letra faltando
- [ ] Leo elige entre 4 opciones
- [ ] Archivo: `lib/features/games/presentation/missing_letter_game.dart`

#### 3.3 Juego: Ordenar letras
- [ ] Letras desordenadas de una palabra con imagen
- [ ] Leo las arrastra al orden correcto (drag & drop)
- [ ] Archivo: `lib/features/games/presentation/word_scramble_game.dart`

---

### ⭐ v1.3 — Sistema de Premios

**Objetivo**: Leo ve su progreso y se siente motivado.

#### 4.1 Estrellas y niveles
- [ ] Provider global `rewardsProvider` — total de estrellas, nivel actual
- [ ] Regla: 3 estrellas por ejercicio completado, 9 estrellas para desbloquear siguiente nivel
- [ ] Constantes ya definidas en `AppConstants.starsPerExercise` y `starsToUnlockLevel`

#### 4.2 Pantalla de premios
- [ ] Mostrar total de estrellas con animación Lottie
- [ ] Grid de logros desbloqueados (insignias de animal: ratón → conejo → gato → León)
- [ ] Barra de progreso hacia el siguiente nivel

#### 4.3 Mascota Leo
- [ ] Widget `LeoMascot` reutilizable: el leoncito en distintos estados (feliz, animando, celebrando)
- [ ] Usar animaciones Lottie o SVG animado
- [ ] Archivo: `lib/shared/widgets/leo_mascot.dart`

---

### 🔵 v2.0 — Backend + Perfil en la nube (futuro)

- [ ] API en Dart Shelf (o Node) para sincronizar progreso entre dispositivos
- [ ] Autenticación con Google Sign-In (perfil de papá/mamá, no de Leo)
- [ ] Dashboard para padres: tiempo de uso, letras dominadas, progreso semanal
- [ ] Docker ya preparado en `docker/` para este backend

---

## Sounds & Animations Plan

| Evento | Sonido | Animación |
|--------|--------|-----------|
| Acierto | fanfare.mp3 | Estrellas + leo salta |
| Error | boing.mp3 | Shake del elemento |
| Subir nivel | levelup.mp3 | Lottie confetti |
| Tocar letra | click.mp3 | Scale up 1.2x → 1.0x |
| Abrir módulo | whoosh.mp3 | Slide in desde abajo |

Sonidos en `assets/audio/`. Usar `audioplayers` para efectos, `flutter_tts` solo para voz.

---

## CI/CD Pipeline

GitHub Actions en `.github/workflows/`:

1. `ci.yml` — analyze → test → build Android → build Windows (en cada push/PR)
2. `ai-review.yml` — Claude/GPT-4o revisa el diff de cada PR y comenta automáticamente
3. `ai-issue-agent.yml` — GPT-4o analiza cada issue nuevo y sugiere solución con código

**No se necesita ningún secret externo** — todo funciona con `GITHUB_TOKEN` automático de GitHub.

---

## Pending: First Run Setup

Antes de poder ejecutar por primera vez:

```bash
# 1. Crear carpetas de assets (Flutter las necesita aunque estén vacías)
mkdir assets/images assets/audio assets/animations assets/fonts

# 2. Generar código del router y riverpod
dart run build_runner build --delete-conflicting-outputs

# 3. Ejecutar
flutter run -d windows
```
