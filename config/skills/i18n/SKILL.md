---
name: i18n
description: Internationalization (i18n) and localization (l10n). Use when adding multi-language support.
---

## i18n

Implement internationalization.

### Setup
- Extract strings to translation files
- Use ICU message format
- Support pluralization
- Handle RTL languages
- Format dates/numbers per locale

### Best practices
- Never concatenate translated strings
- Translation keys as default messages
- Context comments for translators
- Test with pseudo-locale
- Lazy-load locale data
