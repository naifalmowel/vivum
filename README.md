# VIVUM Digital Agency — Flutter Web

Premium Flutter Web website for VIVUM digital agency.

## Brand Colors
- Navy: `#2B2D5E`
- Teal: `#00B5CC`
- Amber: `#F5A61A`
- Background: `#07091A`

## Setup & Run

```bash
# Get dependencies
flutter pub get

# Run in Chrome (web)
flutter run -d chrome

# Build for production (Firebase Hosting)
flutter build web --release --web-renderer canvaskit
```

## Deploy to Firebase Hosting

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Init (choose Hosting, set public dir to "build/web")
firebase init

# Build + deploy
flutter build web --release --web-renderer canvaskit
firebase deploy
```

## Structure

```
lib/
├── main.dart               # App entry + routing (go_router)
├── theme/
│   └── app_theme.dart      # Brand colors + typography
├── l10n/
│   └── translations.dart   # EN/AR translations + LanguageProvider
├── widgets/
│   ├── scaffold_shell.dart  # Navbar + Footer shell
│   ├── navbar.dart          # Glassmorphism navbar with EN/AR toggle
│   ├── footer.dart          # Full footer
│   ├── glow_button.dart     # Animated CTA buttons
│   ├── section_reveal.dart  # Scroll-triggered reveal animations
│   └── particle_painter.dart # Hero particle + orbit animations
└── screens/
    ├── home_screen.dart     # Hero + services + stats + portfolio + CTA
    ├── about_screen.dart    # Story + pillars + markets + values
    ├── services_screen.dart # 4 service categories
    ├── portfolio_screen.dart # Filterable project case studies
    ├── process_screen.dart  # 5-step timeline + testimonials
    └── contact_screen.dart  # Form + WhatsApp + social links
```

## Key Features
- Dark premium UI with deep navy background
- Animated particle background with connecting lines
- Orbiting rings hero animation (CustomPainter)
- Scroll-triggered section reveals
- Hover glow effects on all cards
- Bilingual EN/AR with RTL support
- Firebase Hosting ready

## Packages Used
- `go_router` — page routing
- `flutter_animate` — smooth animations
- `google_fonts` — Syne + Inter typography
- `animated_text_kit` — typewriter effects
- `visibility_detector` — scroll triggers
