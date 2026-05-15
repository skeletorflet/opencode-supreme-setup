---
name: motion-framer
description: Motion (formerly Framer Motion) — declarative animation library for React with layout animations, gestures, and spring physics.
---

### motion components
`<motion.div>`, `<motion.span>`, etc. Props: `initial`, `animate`, `exit`, `transition`. Variants for named states. Spring defaults for natural motion.

### layout animations
`layout` prop auto-animates position/size changes. `layoutId` shared between elements for smooth morphing (magic motion). `LayoutGroup` for coordinating sibling animations.

### AnimatePresence
Wrap conditional mounts for enter/exit animations. `mode="wait"` for sequential. `mode="popLayout"` for layout shift animations. `onExitComplete` callback.

### gestures
`whileHover`, `whileTap`, `whileDrag`, `whileFocus`, `whileInView`. `drag="x"` for axis-locked drag. `dragConstraints` for boundaries. `onDragEnd` for callbacks.

### variants
Named animation objects. `variants={{ open: { opacity: 1 }, closed: { opacity: 0 } }}`. Pass to `initial`/`animate`/`exit`. Parent variants cascade to children with `transition={{ staggerChildren: 0.1 }}`.

### scroll-triggered
`useInView()` hook. `whileInView` prop. `useScroll()` for scroll progress. `useTransform()` to map scroll to motion values. `useSpring()` for smoothed scroll-driven motion.

### motion values
`useMotionValue(0)` — reactive value driving animations. `useSpring()` wraps it in spring. `useTransform(value, [input], [output])` for mapping. Read via `useMotionValueEvent()`.

### performance
Use `transform` instead of layout properties. Set `will-change` via `style={{ willChange: "transform" }}`. Use `layoutDependency` to limit recalculations. Prefer CSS animations for simple opacity/rotation.
