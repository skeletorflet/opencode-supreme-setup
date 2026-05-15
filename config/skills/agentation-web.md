---
description: "Configures and integrates Agentation into a web application to enable visual annotations for OpenCode"
tags: ["agentation", "mcp", "react", "nextjs", "setup"]
---

# Agentation Web App Integration Skill

Use this skill to configure and integrate **Agentation** into a web application. Agentation allows you (the agent) to visually interact with the web app through the Agentation MCP server.

## 1. Prerequisites

1.  **Agentation MCP Server:** Ensure the `agentation-mcp` server is running or configured in the `opencode.json` of the user.
2.  **Environment:** Determine if the project is using React (Vite/CRA) or Next.js (Pages/App Router).

## 2. Installation

Install the required Agentation client package.
*If a specific package isn't provided by the user, assume standard integration scripts or `@agentation/client` if applicable. (Adjust according to the official documentation).*

```bash
npm install @agentation/client
```

## 3. Integration

Add the `<Agentation />` provider/component to the root of the application so it wraps the entire app and can capture the DOM.

### For Next.js (App Router - `app/layout.tsx`):
```tsx
import { Agentation } from '@agentation/client';

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>
        <Agentation />
        {children}
      </body>
    </html>
  );
}
```

### For React (Vite - `src/main.tsx` or `src/App.tsx`):
```tsx
import { Agentation } from '@agentation/client';

function App() {
  return (
    <>
      <Agentation />
      <YourMainComponent />
    </>
  );
}
```

## 4. Verification

1.  Ensure no build errors are introduced.
2.  Remind the user to run the app (`npm run dev`) and ensure the visual annotations appear on interactive elements.
3.  The agent can now use the `agentation` MCP tools to inspect and interact with the UI.
