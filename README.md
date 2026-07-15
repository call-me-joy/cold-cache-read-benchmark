# cold-cache-read-benchmark
code repo to benchmark cold read from l1 cache

## 🚀 Build & Run
Use the provided `Makefile` to compile and run the benchmark.

- `make` — compile `benchmark`
- `make run` — compile and execute `./benchmark`
- `make clean` — remove the generated binary

### Notes
- `make` prefers `pkg-config` for `benchmark` flags.
- If `pkg-config` is unavailable, the Makefile falls back to common system paths.
- On macOS, it uses Homebrew defaults; on Linux/WSL it uses `/usr/local`.
