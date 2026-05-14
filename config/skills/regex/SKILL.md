---
name: regex
description: Create, test, and debug regular expressions. Use when needing pattern matching, validation, or text extraction.
---

## regex

Craft and debug regular expressions.

### Common patterns
- Email: ^[\w.-]+@[\w.-]+\.\w+$
- URL: https?://[\w./?-]+
- Phone: ^\+?[\d\s()-]{7,15}$
- Date: \d{4}-\d{2}-\d{2}
- IP: \d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}

### Flags
- g - global (all matches)
- i - case insensitive
- m - multiline
- s - dotall (. matches newline)
