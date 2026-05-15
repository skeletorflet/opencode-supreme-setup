---
name: threejs
description: Three.js — WebGL library for 3D graphics in the browser with scene graph, materials, loaders, and post-processing.
---

### scene setup
`new THREE.Scene()`, `new THREE.PerspectiveCamera(75, aspect, 0.1, 1000)`, `new THREE.WebGLRenderer({ antialias: true })`. `renderer.setSize()`, `renderer.setAnimationLoop()`. Append canvas to DOM.

### geometries & materials
BoxGeometry, SphereGeometry, PlaneGeometry, BufferGeometry with custom attributes. MeshStandardMaterial, MeshPhysicalMaterial (PBR), MeshBasicMaterial (unlit). Map textures via `material.map`.

### lighting
AmbientLight (base fill), DirectionalLight (sun), PointLight (bulb), SpotLight (cone). HemisphereLight for sky/ground color. Shadows: `renderer.shadowMap.enabled = true`, `light.castShadow = true`.

### animations
`requestAnimationFrame` loop or `renderer.setAnimationLoop`. Update properties per frame. GSAP + three.js for tweened values. Use `Clock` for delta time.

### OrbitControls
`import { OrbitControls } from 'three/addons/controls/OrbitControls.js'`. Attach to camera + domElement. Enable damping, zoom limits, auto-rotate.

### loaders
`GLTFLoader` (models), `FBXLoader`, `TextureLoader`, `DRACOLoader` (compressed). Use `useLoader` in R3F + React. Manage loading state with `LoadingManager`.

### shaders
`ShaderMaterial` with custom vertex/fragment GLSL. `RawShaderMaterial` for no built-in uniforms. `uniforms` object for JS-to-GPU data. Post-processing via `EffectComposer`.

### post-processing
`EffectComposer`, `RenderPass`, `UnrealBloomPass`, `SSAOPass`, `DotScreenPass`. Import from `three/addons/postprocessing/`. Multi-pass rendering pipeline.

### best practices
Dispose geometries/materials on unmount (`geometry.dispose()`). Use `BufferGeometry` over `Geometry`. Batch draw calls. Use LOD for distance-based detail. Prefer instancing for many similar objects.
