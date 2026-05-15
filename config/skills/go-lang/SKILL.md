---
name: go-lang
description: Go language skill covering goroutines, channels, interfaces, error handling, modules, and testing. Use when building Go applications.
trigger: go, golang, go-lang, goroutines, channels, go mod, go test, go interfaces, go error handling
---

## go-lang

### Core Concepts
- Goroutines: lightweight threads (go keyword), multiplexed onto OS threads by the runtime scheduler
- Channels: typed conduits for goroutine communication, support buffered/unbuffered and select for multiplexing
- Interfaces: implicit satisfaction, define behavior contracts with zero dependencies between types
- Structs + Methods: value receiver vs pointer receiver, composition over inheritance via embedding

### Error Handling
- errors.Is/As: error chain inspection, Is checks sentinel values, As unwraps to target type
- No exceptions: functions return error as last value, caller handles explicitly
- defer/panic/recover: cleanup resources, panic for programmer errors, recover in goroutines only

### Modules & Tooling
- go mod: dependency management, semantic import versioning, module cache, checksum database
- go fmt/vet: standardized formatting and static analysis
- go build/install: fast compilation, cross-compilation with GOOS/GOARCH

### Common Code Patterns
- Table-driven tests: slice of test cases with input/expected, run with t.Run subtests
- Context: deadline propagation, cancellation signals, request-scoped values through API boundaries
- Stdlib: net/http (ServeMux, Handler), encoding/json (Marshal/Unmarshal), io (Reader/Writer), sync (Mutex, WaitGroup, Map)
