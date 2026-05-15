---
name: flutter
description: Google's UI toolkit for natively compiled apps — widget tree composition, state management, Material/Cupertino design, Navigator 2.0, animations, platform channels, and testing.
trigger: flutter, flutter widget, flutter riverpod, flutter bloc, navigator 2.0, go_router, flutter animation, platform channel, flutter test
---

# Flutter

## Widget Tree Composition
Everything is a widget. UIs are built by composing small widgets into trees. `StatelessWidget` for fixed UI, `StatefulWidget` for mutable state.

## State Management
- **Riverpod** — compile-safe, testable provider system
- **Bloc** — event-driven state machine pattern
- Provider, GetX, and Redux alternatives available

## Material and Cupertino
Built-in design systems. `MaterialApp` for Android-style widgets, `CupertinoApp` for iOS-style. Mix within the same app using platform detection.

## Navigator 2.0
Declarative routing with `Router` and `RouteInformationParser`. Libraries like `go_router` simplify deep linking, nested navigation, and redirect guards.

## Animations
`AnimationController`, `Tween`, and `CurvedAnimation` for fine-grained control. Higher-level APIs include `AnimatedContainer`, `Hero`, and `AnimatedBuilder`.

## Platform Channels
Bidirectional communication between Dart and native Kotlin/Swift. `MethodChannel` for invoking native APIs, `EventChannel` for streaming data.

## Testing
- **Widget tests** — component-level UI verification
- **Unit tests** — business logic without UI
- **Integration tests** — full app flows via `flutter_driver` or `integration_test`
