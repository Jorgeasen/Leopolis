# ─────────────────────────────────────────────────────────────────
# Leópolis — Entorno de CI/CD y desarrollo con Flutter
# Útil para: compilar APKs en CI, futura API backend, tools
# ─────────────────────────────────────────────────────────────────

FROM debian:bookworm-slim AS base

ARG FLUTTER_VERSION=3.22.0
ARG FLUTTER_CHANNEL=stable

ENV DEBIAN_FRONTEND=noninteractive
ENV FLUTTER_HOME=/opt/flutter
ENV PATH="${FLUTTER_HOME}/bin:${PATH}"
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH="${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:${PATH}"

# Dependencias del sistema
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-17-jdk \
    wget \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Instalar Flutter
RUN git clone --depth 1 --branch ${FLUTTER_VERSION} \
    https://github.com/flutter/flutter.git ${FLUTTER_HOME}

RUN flutter config --no-analytics \
    && flutter config --enable-android \
    && flutter precache --android

# Android SDK (para builds Android en CI)
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O /tmp/cmdline-tools.zip && \
    unzip -q /tmp/cmdline-tools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
    mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest && \
    rm /tmp/cmdline-tools.zip

RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

WORKDIR /app

# ─────────────────────────────────────────────────────────────────
# Stage: CI — solo para compilar y testear
# ─────────────────────────────────────────────────────────────────
FROM base AS ci

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

CMD ["flutter", "test"]

# ─────────────────────────────────────────────────────────────────
# Stage: Build APK
# ─────────────────────────────────────────────────────────────────
FROM base AS build-apk

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .
RUN flutter build apk --release

# El APK quedará en build/app/outputs/flutter-apk/app-release.apk
