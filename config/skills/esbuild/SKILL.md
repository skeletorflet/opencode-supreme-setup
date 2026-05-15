---
name: esbuild
description: esbuild — ultra-fast bundler with JSX/TS transforms, plugins, watch, serve, code splitting.
---

## esbuild

### Bundling
- `require('esbuild').build({ entryPoints: ['src/index.ts'], outfile: 'dist/bundle.js', bundle: true })`.
- `format: 'esm' | 'cjs' | 'iife'` — output module format.
- `platform: 'browser' | 'node' | 'neutral'` — target environment defaults.
- External: `external: ['react', 'react-dom']` — exclude from bundle.

### Transforms
- JSX: automatic runtime (`"jsx": "automatic"`) or classic.
- TypeScript: strips types, no type-checking — use `tsc --noEmit` separately.
- Target: `target: 'es2020'` — downlevel syntax to specified JS version.
- JSX transform standalone: `transformSync('<div/>', { loader: 'jsx' })`.

### Plugins
- Plugin API: `{ name: 'my-plugin', setup(build) { build.onResolve(...) / onLoad(...) } }`.
- Virtual modules: `onLoad({ filter: /.*/ }, () => ({ contents: '...', loader: 'ts' }))`.
- Popular: `esbuild-plugin-inline-import`, `esbuild-plugin-html`, `esbuild-sass-plugin`.
- Namespace isolation: `namespace: 'http'` for custom URL resolution.

### Watch & Serve
- `watch: { onRebuild(err, result) { ... } }` — file watcher + rebuild.
- `serve({ servedir: 'dist', port: 8000 })` — dev server with live reload.
- `context = await build(...)` then `context.watch()` / `context.serve()` / `context.rebuild()`.
- `context.dispose()` — clean up watchers and servers.

### Minification & Code Splitting
- `minify: true` / `minifyWhitespace: true` / `minifySyntax: true` / `minifyIdentifiers: true`.
- `splitting: true` + `format: 'esm'` — shared chunks for code splitting.
- `treeShaking: true` — remove unused exports (default for bundle: true).
- `sourcemap: true | 'inline' | 'external'` — control source map generation.
