---
name: tailwind
description: Tailwind CSS — utility-first CSS framework with responsive prefixes, dark mode, JIT engine, and customization via config.
---

### core philosophy
Utility-first. Compose designs using single-purpose classes. No context switching between HTML and CSS files.

### responsive & state
Prefix breakpoints: `sm:` `md:` `lg:` `xl:` `2xl:`. State variants: `hover:` `focus:` `active:` `disabled:`. Group variants: `group-hover:` `peer-invalid:`. Dark mode: `dark:` prefix or `class` strategy in config.

### custom theme
Edit `tailwind.config.{js,ts}`: extend colors, spacing, fonts, breakpoints. Use `theme()` function in CSS. Arbitrary values: `w-[123px]` `bg-[#1da1f1]` `grid-cols-[1fr_2fr]`.

### @apply & components
Extract repeated utility groups with `@apply` in CSS. Use `@layer components` for component classes. Avoid `@apply` for truly atomic patterns.

### plugins
`require('@tailwindcss/forms')`, `@tailwindcss/typography` (prose), `@tailwindcss/aspect-ratio`, `@tailwindcss/container-queries`. Write custom plugins with `addUtilities`, `addComponents`, `matchUtilities`.

### v4 changes
CSS-first config (no `tailwind.config` needed). `@import "tailwindcss"` in CSS entry. `@theme` directive for design tokens. Built-in container queries. Simplified dark mode. New `@variant` system.

### JIT engine
On-demand generation. Zero unused CSS in production. Every combination is valid without config. Rebuilds in milliseconds.

### best practices
Mobile-first responsive design. Use design tokens (spacing scale, color palette). Purge unused classes in production. Prefer `gap` over margin for layouts.
