---
name: material-ui
description: Material UI — React component library implementing Google Material Design with comprehensive theming and SSR support.
---

### components
Full suite: Button, TextField, Select, Dialog, Drawer, AppBar, DataGrid, Autocomplete, DatePicker. Each is production-grade with built-in accessibility, focus management, and keyboard nav.

### sx prop
`<Box sx={{ color: 'primary.main', p: 2, '&:hover': { bgcolor: 'action.hover' } }}>`. Responsive values: `{ width: { xs: '100%', md: '50%' } }`. Theme-aware tokens. Avoid for performance-critical lists.

### theming
`createTheme()`: palette, typography, spacing, breakpoints, shape, shadows, components (default props, style overrides). `ThemeProvider` wraps app. Nested themes for sections. CSS variables mode via `CssVarsProvider`.

### styled components
`styled(Button)(({ theme }) => ({ margin: theme.spacing(2) }))`. `styled('div')` for custom elements. Pass theme via props. Use `sx` for one-off, `styled` for reusable.

### Grid v2
`<Grid container spacing={2}><Grid item xs={12} md={6}>`. New Grid uses CSS Grid (not flexbox). `size` prop instead of `xs`/`md`. `offset`, `order` props.

### responsiveness
Breakpoint props on Grid, Container, Stack. `useMediaQuery(theme.breakpoints.up('md'))` for custom responsive logic. `hidden`-like via `sx={{ display: { xs: 'none', md: 'block' } }}`.

### SSR with Emotion
`createCache()` + `CacheProvider`. Extract critical CSS. `@emotion/server` `renderToString` + `extractCritical`. Next.js App Router: built-in with `@mui/material-nextjs`.

### autocomplete & date picker
Autocomplete: `options`, `getOptionLabel`, `renderInput`, async loading, grouping, freeSolo. DatePicker: `@mui/x-date-pickers`, `LocalizationProvider`, `AdapterDayjs`, single/range/desktop/mobile variants.

### best practices
Tree-shake unused components via path imports. Use `light`/`dark` theme toggle with `useMediaQuery`. Override via `components` theme key, not ad-hoc CSS. Use Stack for simple layouts.
