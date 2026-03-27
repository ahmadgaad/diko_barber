# Diko Barber

A modern barbershop mobile application built with Flutter, following Clean Architecture principles to ensure scalability, maintainability, and testability.

---

## Features

- Animated splash screen
- Clean and modern UI with custom theming
- Scalable feature-based architecture ready for expansion
- Modular routing system

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart 3+) |
| State Management | flutter_bloc / Cubit |
| Dependency Injection | get_it |
| Navigation | go_router |
| Architecture | Clean Architecture (presentation → domain → data) |
| Linting | flutter_lints |

---

## Project Structure

```
lib/
├── core/
│   ├── di/             # Dependency injection (service locator)
│   ├── router/         # App routing (GoRouter)
│   └── theme/          # App colors and theme
├── features/
│   └── splash/
│       ├── domain/     # Use cases
│       └── presentation/
│           ├── cubit/  # State management
│           └── screens/ # UI screens
└── main.dart
```

---

## Screenshots

> Screenshots will be added as features are developed.

---

## Getting Started

### Prerequisites

- Flutter SDK `^3.11.4`
- Dart SDK `^3.11.4`
- Android Studio / Xcode (for device emulation)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/ahmadgaad/diko_barber.git
   cd diko_barber
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Build

```bash
# Android
flutter build apk --release

# iOS
flutter build ipa --release
```
