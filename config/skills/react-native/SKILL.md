---
name: react-native
description: Cross-platform mobile development with React — Expo framework, core components, navigation, native modules, EAS Build, OTA updates, and debugging.
trigger: react native, react-native, expo, expo router, eas build, flatlist, react native navigation, native modules, ota updates
---

# React Native

## Expo Framework
Expo is the recommended framework for React Native. Provides managed workflow, pre-built native modules, and over-the-air updates via EAS.

## Core Components
- `View` — layout container (flexbox)
- `Text` — text rendering with nesting and styling
- `FlatList` — performant virtualized scrolling lists
- `TextInput` — keyboard-aware text entry
- `ScrollView` — scrollable content container
- `Pressable` — touch interaction with state feedback

## Navigation (Expo Router)
File-based routing similar to Next.js. Supports stacks, tabs, drawers, and deep links. Dynamic routes with `[param]` syntax.

## State Management
Options include React Context, Zustand, Redux Toolkit, and Jotai. Expo Router integrates search params for URL-driven state.

## Native Modules
Custom native code via Expo modules API or New Architecture (Fabric / TurboModules). Supports Swift, Kotlin, and C++.

## EAS Build
Cloud-based build service for iOS and Android. Manages provisioning profiles, certificates, and app signing.

## OTA Updates
Expo Updates delivers JavaScript bundle updates without app store review. Supports rollbacks and channels.

## Debugging
React DevTools, Flipper, Hermes debugger, and Metro bundler with fast refresh for instant iteration.
