# 🦁 Leópolis

> La ciudad donde **Leo** aprende a leer y escribir

Aplicación educativa multiplataforma (Windows, Android, iPad) construida con **Flutter** para que niños de 6 años aprendan el abecedario, las palabras y la escritura de forma divertida e interactiva.

---

## 🏗️ Arquitectura del proyecto

```
leopolis/
├── lib/
│   ├── main.dart                    # Punto de entrada
│   ├── app.dart                     # Widget raíz + router
│   ├── core/
│   │   ├── constants/               # Constantes globales
│   │   ├── router/                  # go_router + Riverpod
│   │   └── theme/                   # Colores, fuentes, estilos
│   ├── features/
│   │   ├── home/                    # Pantalla principal
│   │   ├── letters/                 # 🔤 Módulo: Las Letras
│   │   ├── words/                   # 📝 Módulo: Las Palabras
│   │   ├── games/                   # 🎮 Módulo: Juegos
│   │   └── rewards/                 # ⭐ Módulo: Mis Premios
│   └── shared/
│       ├── widgets/                 # Componentes reutilizables
│       └── models/                  # Modelos de datos
├── test/                            # Tests de widgets y unidad
├── .github/
│   ├── workflows/
│   │   ├── ci.yml                   # CI: analyze + test + build
│   │   ├── ai-review.yml            # Revisión automática de PRs con Claude
│   │   └── ai-issue-agent.yml       # Agente de análisis de issues
│   └── ISSUE_TEMPLATE/              # Templates para bugs y features
├── docker/
│   ├── Dockerfile                   # Multi-stage: CI y build APK
│   └── docker-compose.yml           # Servicios de desarrollo
└── docs/
    └── FLUTTER_INSTALL.md           # Guía de instalación paso a paso
```

---

## 🚀 Setup rápido

### Prerequisitos
- Flutter SDK 3.22+
- VSCode con extensión Flutter
- Android Studio (para builds Android)

Consulta la **[Guía de instalación completa](docs/FLUTTER_INSTALL.md)**.

### Comandos principales

```bash
# Instalar dependencias
flutter pub get

# Generar código (Riverpod, Router)
dart run build_runner build --delete-conflicting-outputs

# Ejecutar en Windows (desarrollo)
flutter run -d windows

# Tests
flutter test

# Análisis estático
flutter analyze
```

---

## 🤖 Agentes de IA integrados

Este proyecto incluye tres agentes de IA que funcionan automáticamente:

| Agente | Cuándo actúa | Qué hace |
|--------|-------------|----------|
| **AI Code Review** | Al abrir un Pull Request | Analiza el diff, detecta bugs, sugiere mejoras |
| **Issue Analyzer** | Al crear un issue | Clasifica, prioriza y sugiere solución con código |
| **CI Pipeline** | En cada push/PR | Analiza, testea y compila para Android y Windows |

Para activarlos necesitas añadir en GitHub → Settings → Secrets:
- `ANTHROPIC_API_KEY` — tu API key de Anthropic

---

## 🧩 Módulos de la app

| Módulo | Estado | Descripción |
|--------|--------|-------------|
| 🔤 Las Letras | ✅ Base lista | Escuchar y reconocer cada letra del abecedario |
| 📝 Las Palabras | 🚧 Próximamente | Relacionar imagen con palabra |
| 🎮 Juegos | 🚧 Próximamente | Minijuegos de completar palabras y ordenar letras |
| ⭐ Mis Premios | 🚧 Próximamente | Logros y estrellas ganadas |

---

## 🎨 Stack tecnológico

- **Framework**: Flutter 3.22 + Dart 3.3
- **Estado**: Riverpod 2.x
- **Navegación**: go_router
- **Voz**: flutter_tts (pronunciación en español)
- **Animaciones**: Lottie
- **Fuentes**: Google Fonts (Fredoka — perfecta para niños)
- **CI/CD**: GitHub Actions
- **Agentes IA**: Claude (Anthropic API)
- **Contenedores**: Docker (entorno CI + futuro backend)

---

## 🗺️ Roadmap

- [ ] v1.0 — Las Letras completo (ver, escuchar, trazar con el dedo)
- [ ] v1.1 — Las Palabras (imagen + palabra + sílabas)
- [ ] v1.2 — Juegos (completar palabras, sopa de letras sencilla)
- [ ] v1.3 — Sistema de premios y progreso persistente
- [ ] v2.0 — Backend API + perfil de Leo en la nube
- [ ] v2.1 — Modo multijugador (Leo + papá/mamá)

---

## 👨‍💻 Contribuir

1. Crea un fork del repo
2. Crea una rama: `git checkout -b feature/mi-mejora`
3. Haz tus cambios y tests: `flutter test`
4. Abre un Pull Request — el agente de IA lo revisará automáticamente

---

*Hecho con ❤️ por papá, para Leo 🦁*
