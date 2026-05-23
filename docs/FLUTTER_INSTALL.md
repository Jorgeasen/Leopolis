# 🦁 Guía de instalación — Flutter en Windows 11

## 1. Instalar Flutter SDK

### Opción A: Winget (recomendado)
```powershell
winget install Google.Flutter
```

### Opción B: Manual
1. Descarga el SDK desde https://docs.flutter.dev/get-started/install/windows
2. Extrae en `C:\flutter` (evita rutas con espacios)
3. Añade `C:\flutter\bin` al PATH:
   - Busca "Variables de entorno" en el menú Inicio
   - En "Variables de usuario" → edita `Path` → añade `C:\flutter\bin`

### Verificar instalación
```powershell
flutter doctor
```

---

## 2. Instalar Android Studio

Necesario para el SDK de Android y el emulador:

1. Descarga desde https://developer.android.com/studio
2. Instala con las opciones por defecto
3. Abre Android Studio → SDK Manager → instala:
   - Android SDK Platform 34
   - Android SDK Build-Tools 34

### Aceptar licencias Android
```powershell
flutter doctor --android-licenses
```

---

## 3. Configurar VSCode

1. Abre VSCode
2. Instala la extensión **Flutter** (dart-code.flutter) — instala Dart automáticamente
3. Abre la carpeta del proyecto: `File → Open Folder → D:\source\repos\Leopolis`
4. VSCode te sugerirá instalar las extensiones recomendadas → acepta todas

---

## 4. Primeros pasos con el proyecto

```powershell
cd D:\source\repos\Leopolis

# Instalar dependencias
flutter pub get

# Generar código (riverpod, router)
dart run build_runner build --delete-conflicting-outputs

# Ejecutar en Windows
flutter run -d windows

# Ejecutar tests
flutter test
```

---

## 5. Conectar dispositivos

### Android (tablet)
1. En la tablet: Ajustes → Acerca del dispositivo → toca 7 veces "Número de compilación"
2. Ajustes → Opciones de desarrollador → activa "Depuración USB"
3. Conecta por USB → en VSCode verás la tablet en la barra inferior

### iPad
> Compilar para iOS/iPadOS requiere una Mac o usar **Codemagic** (CI en la nube).
> Desde Windows puedes desarrollar y ver el resultado en Android o Windows.

---

## 6. Secrets necesarios en GitHub

Ve a tu repo → Settings → Secrets and variables → Actions:

| Secret | Descripción |
|--------|-------------|
| `ANTHROPIC_API_KEY` | API key de Anthropic (para los agentes de IA) |
| `CODECOV_TOKEN` | Token de Codecov (cobertura de tests, opcional) |

---

## 7. Variables útiles

```powershell
# Ver dispositivos conectados
flutter devices

# Compilar APK debug
flutter build apk --debug

# Compilar para Windows
flutter build windows

# Limpiar build
flutter clean && flutter pub get
```
