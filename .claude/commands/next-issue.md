# /next-issue — Implementar el siguiente issue pendiente

Implementa el siguiente issue de GitHub que esté listo (label `agent-ready`, sin dependencias bloqueantes). Sigue este proceso **paso a paso, sin saltarte ninguno**.

---

## PASO 1: Encontrar el siguiente issue implementable

```bash
gh issue list \
  --repo Jorgeasen/Leopolis \
  --label agent-ready \
  --state open \
  --json number,title,body,assignees \
  --limit 30
```

Ordena por número ascendente. Para cada issue:

1. Extrae los números de issue referenciados en la sección `## Dependencias` del body (formato `#N` o `` Issue `[X.Y]` `` con número de issue mencionado).
2. Para cada número encontrado, verifica si está cerrado:
   ```bash
   gh issue view N --repo Jorgeasen/Leopolis --json state --jq '.state'
   ```
3. Si **todas** las dependencias están cerradas (o no hay dependencias) → **este es el issue a implementar**.
4. Si alguna dependencia está abierta → salta al siguiente issue.

Si ningún issue está desbloqueado, muestra el estado actual (qué está bloqueando qué) y detente.

---

## PASO 2: Asignar el issue

```bash
gh issue edit NUMERO --repo Jorgeasen/Leopolis --add-assignee "@me"
gh issue edit NUMERO --repo Jorgeasen/Leopolis --add-label "in-progress"
```

---

## PASO 3: Crear rama de trabajo

Crea el nombre de rama: `feature/issue-N-slug` donde `slug` son las primeras 4-5 palabras del título en kebab-case, máximo 40 chars totales.

```bash
git checkout main
git pull origin main
git checkout -b feature/issue-N-slug
```

---

## PASO 4: Leer el issue completo y planificar

Lee el body completo del issue. Identifica:
- Qué archivos crear (sección "Archivos a crear")
- Qué archivos modificar ("También modificar")
- Cada ítem del checklist de tareas
- Dependencias técnicas (qué código ya existe que necesitas usar)

Antes de escribir código, lee los archivos existentes relevantes para entender el contexto actual.

---

## PASO 5: Implementar

Implementa **todos** los ítems del checklist del issue, en este orden preferido:
1. Primero capa de datos (modelos, repositorios)
2. Luego providers de estado (Riverpod)
3. Finalmente pantallas y widgets (UI)

### Reglas obligatorias (CLAUDE.md):
- Single quotes en todo el código Dart
- `const` constructors donde sea posible
- Touch targets mínimo **64px** — dedos de 6 años
- Fuente **Fredoka** — no cambiar nunca
- Todo texto de UI en **español**
- TTS locale `es-ES`
- Nunca mostrar pantallas de error intimidantes — usar el leoncito
- Botón "← Volver" siempre visible en cada pantalla
- Feedback inmediato (< 100ms) en cada toque
- Alto contraste: texto oscuro sobre fondo claro

### Después de tocar `app_router.dart` o cualquier provider con anotaciones Riverpod:
```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## PASO 6: Formatear y validar

```bash
dart format .
flutter analyze --fatal-infos
flutter test
```

Si `flutter analyze` da errores: **corrígelos todos** antes de continuar. No uses `// ignore:` salvo en archivos `.g.dart`.

Si `flutter test` falla por tests rotos (no por tests de código nuevo): corrige también.

Si no hay tests para el nuevo código: añade al menos un test básico en `test/` que verifique que el widget/clase existe.

---

## PASO 7: Commit

Stage solo los archivos que has creado o modificado (nunca `git add .` indiscriminado):

```bash
git add lib/path/to/new_file.dart lib/path/to/modified_file.dart test/...
git commit -m "$(cat <<'EOF'
feat: [#N] Título corto descriptivo

- Implementado LetterData con 27 letras del abecedario
- Añadido LettersRepository con métodos getAll/getNext/getPrevious
- Tests básicos del repositorio

Closes #N

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
EOF
)"
git push -u origin feature/issue-N-slug
```

---

## PASO 8: Abrir Pull Request

```bash
gh pr create \
  --repo Jorgeasen/Leopolis \
  --title "feat: [#N] Título que coincide con el issue" \
  --body "$(cat <<'EOF'
## Qué hace este PR

Breve descripción de 2-3 líneas de qué implementa y por qué.

## Cambios principales

- `lib/features/letters/data/letter_data.dart` — modelo LetterData creado
- `lib/features/letters/data/letters_repository.dart` — repositorio con 27 letras

## Checklist de calidad

- [x] `dart format .` pasa sin cambios
- [x] `flutter analyze --fatal-infos` sin errores ni warnings
- [x] `flutter test` pasa
- [x] Touch targets ≥ 64px verificados
- [x] Texto UI en español
- [x] Sin strings literales de SharedPreferences (uso de AppConstants)

## Issues relacionados

Closes #N

---
🤖 Implementado por Claude Code · Revísame en [GitHub](https://github.com/Jorgeasen/Leopolis/pulls)
EOF
)" \
  --label "enhancement"
```

Captura el número de PR del output.

---

## PASO 9: Activar auto-merge

```bash
gh pr merge --auto --squash --repo Jorgeasen/Leopolis PR_NUMBER
```

El PR se fusionará automáticamente cuando CI pase. Si CI falla, el PR queda abierto para revisión manual.

---

## PASO 10: Reportar

Muestra al usuario:
- Issue resuelto: `#N — Título`
- PR creado: URL del PR
- Auto-merge: activado ✓
- Qué revisar: menciona si hay algo que verificar manualmente (assets, integraciones externas)
- Próximo issue: cuál será el siguiente según las dependencias

---

## En caso de errores irrecuperables

Si encuentras un error que no puedes resolver (ej: API de Flutter no documentada, dependencia de package que falta):
1. Haz commit del trabajo parcial con mensaje claro `wip: [#N] trabajo parcial — bloqueado por X`
2. Abre el PR como borrador: `gh pr create --draft ...`
3. Deja un comentario en el issue explicando el bloqueo
4. Reporta al usuario qué necesita resolverse manualmente
