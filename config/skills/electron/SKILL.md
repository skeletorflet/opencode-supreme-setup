---
name: electron
description: Cross-platform desktop apps using Chromium and Node.js — main/renderer process, IPC, contextBridge, native APIs, electron-builder, auto-update, and security best practices.
trigger: electron, electron app, electron main process, electron renderer, ipcMain, ipcRenderer, contextBridge, preload, electron-builder, electron auto-update
---

# Electron

## Main and Renderer Processes
Two process types: main (Node.js backend) and renderer (Chromium frontend). Main process manages windows, menus, and system APIs. Renderer handles the UI.

## IPC (Inter-Process Communication)
`ipcMain` / `ipcRenderer` for async message passing. Use `invoke`/`handle` for request-response patterns and `send`/`on` for fire-and-forget events.

## Context Bridge and Preload
Security boundary between main and renderer. Preload scripts run before renderer code and use `contextBridge.exposeInMainWorld()` to expose specific APIs.

## Native APIs
`dialog` (file pickers), `Notification`, `Tray`, `Menu`, `shell.openExternal`, `clipboard`, `desktopCapturer`, and `screen` for native functionality.

## electron-builder
Package apps for distribution. Supports `.dmg` / `.zip` (macOS), `.exe` / `.msi` (Windows), `.AppImage` / `.deb` (Linux). Auto-update via `electron-updater`.

## Auto-Update
`electron-updater` checks for updates, downloads in background, and installs on restart. Supports GitHub Releases, S3, and custom servers.

## Security Best Practices
Enable `sandbox: true`, set restrictive `Content-Security-Policy`, disable `nodeIntegration` in renderers, validate IPC inputs, and use `contextIsolation: true`.
