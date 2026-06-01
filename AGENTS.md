# AI Agent Context: tqdmoon

This document serves as the system prompt and behavioral contract for AI Agents (Cursor, Trae, etc.) interacting with the `tqdmoon` codebase.

## 🎯 Project Vision & Philosophy
`tqdmoon` is a high-performance, zero-overhead, wrapper-based progress bar library for the MoonBit ecosystem, inspired by Python's `tqdm`. 
Unlike traditional renderers that require verbose manual updates, `tqdmoon` wraps native MoonBit `Iter[T]` to automate counting, rendering, and terminal flushing natively.

## 🛠️ Code Purity & Styling Rules
1. **Zero Redundant Comments:** Do not generate unnecessary docstrings or verbose line-by-line comments. Code must be expressive, clean, and self-documenting.
2. **Naming Convention (Strict snake_case):**
   - **Packages & Files:** Lowercase without separators (e.g., `tqdmoon`, `main.mbt`).
   - **Functions, Methods, Variables:** Strict `snake_case` (e.g., `current_progress`, `calculate_eta`, `set_style`).
   - **Types, Structs, Traits:** Strict `PascalCase` (e.g., `TqdmState`, `BarStyle`).
3. **No External Dependencies:** Rely solely on pure MoonBit core primitives (`print`, `Iter`, basic math).

## 🚀 Core Features to Maintain
- **Automatic Wrapping:** Intercept `.next()` on wrapped iterators to increment counters and flash the terminal seamlessly.
- **Auto Clean-up:** Automatically append a newline `\n` when the iterator is exhausted (`None`).
- **Fallback Stream Mode:** If `total` is `None`, degrade gracefully into a dynamic transaction counter/meter showing elapsed time and rates (e.g., `50 items [00:04, 12.5 items/s]`).
- **The Theme System:** Support pre-configured themes via `BarStyle`, specifically implementing the signature `tqdmoon_google` theme (`tqdm●...n` → `tqdm...oon`).

## 🚫 Guardrails
- NEVER let the terminal flash by printing without proper ANSI escape sequences (`\r`, `\x1B[K`).
- Do not introduce heavy OOP abstractions. Keep structural code lightweight for optimal WebAssembly compilation.

---

## 🏗️ MoonBit Native Tooling & Workflow (Official Guide)

This is a [MoonBit](https://docs.moonbitlang.com) project.
Extra skills library: <https://github.com/moonbitlang/skills>

### Project Structure
- MoonBit packages are organized per directory; each directory contains a `moon.pkg` file listing its dependencies. 
- Each package has its files, blackbox test files (`*_test.mbt`), and whitebox test files (`*_wbtest.mbt`).
- In the toplevel directory, there is a `moon.mod` file listing module metadata.

### Coding Convention
- MoonBit code is organized in block style, each block is separated by `///|`. The order of each block is irrelevant. In some refactorings, you can process block by block independently.
- Try to keep deprecated blocks in a file called `deprecated.mbt` in each directory.

### Tooling & Execution Steps
1. **Formatting:** Use `moon fmt` to format your code properly.
2. **Navigation:** Use `moon ide` helpers like `peek-def`, `outline`, and `find-references`. 
3. **Interface Lock (.mbti):** Use `moon info` to update the generated interface file `.mbti`. If nothing in `.mbti` changes, your changes do not bring visible changes to external users.
4. **Final Step Checklist:** In the last step, ALWAYS run `moon info && moon fmt` to update the interface and format the code. Check the diffs of `.mbti` file to see if the changes are expected.
5. **Testing & Coverage:** Run `moon test` to check tests pass. 
   - MoonBit supports snapshot testing. When changes affect outputs, run `moon test --update` to refresh snapshots.
   - Prefer `assert_eq` or `assert_true(pattern is Pattern(...))` for stable results. 
   - For snapshot tests recording structured debugging output, derive `Debug` and use `debug_inspect`. Do not derive `Show` for debugging.
   - Run `moon coverage analyze > uncovered.log` to check test coverage.