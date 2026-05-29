# Contributing to tqdmoon

Thank you for your interest in contributing to `tqdmoon`! We are building the most elegant, seamless, and high-performance progress manager for the MoonBit ecosystem.

To maintain engineering excellence, code purity, and strict alignment with MoonBit's native toolchain, please review the guidelines below before submitting a Pull Request.

---

## 🎨 Code Style & Aesthetics

We value clean, unpolluted source code that respects both MoonBit's compiler design and our minimalism philosophy:

- **Naming Standard:** - Use `snake_case` for all functions, local variables, methods, and filenames (e.g., `update_progress`, `remaining_time`).
  - Use `PascalCase` exclusively for Structs, Enums, and Traits (e.g., `ProgressManager`, `BarStyle`).
- **No Comment Pollution:** Avoid commenting on obvious logic. Write expressive code where the layout and naming explain *how* it works, leaving comments only for highly abstract architectural *whys*.
- **Block Style Organization:** MoonBit code must be organized in block style, with each block separated by `///|`. Ensure your refactoring or feature additions adhere to this structure. Keep any deprecated blocks in a file called `deprecated.mbt` within the directory.

---

## 🧪 Testing & Verification Protocols (Critical)

We rely heavily on MoonBit’s native testing suite to ensure `tqdmoon` does not cause terminal flickering, buffer overflows, or unexpected behavior.

### 1. Verification Workflow
Before submitting any code, you must execute the following toolchain pipeline in your terminal:
```bash
# 1. Update the generated interface file and format code
moon info && moon fmt

# 2. Run the test suite
moon test
```

### 2. Interface Lock (.mbti) Check
Always check the diffs of the generated .mbti file after running moon info.

If nothing in .mbti changes, your change is a safe internal refactoring.

If .mbti changes, ensure that any added public functions or types strictly follow the snake_case / PascalCase conventions and do not break backwards compatibility.

### 3. Snapshot & Assertion Testing
Snapshot Tests: For tests recording structured terminal/debugging output, derive Debug and use debug_inspect. If your intentional changes affect the visual layout of the progress bar, run moon test --update to refresh the snapshots. Do not derive Show for debugging purposes.

Assertion Tests: For solid, well-defined results (e.g., ETA math, percentage calculations), prefer assert_eq or assert_true(pattern is Pattern(...)).

Coverage: Run coverage analysis to ensure your logic is fully tested:

Bash


moon coverage analyze > uncovered.log
Review uncovered.log to make sure no critical rendering paths are left untested.

### 🗺️ Contribution Workflow
Fork & Clone: Fork the repository and create your feature branch from main.

Implement with AI: If you use Cursor or Trae, ensure they ingest our root-level agent.md context first so they match our strict styling and toolchain rules.

Run Toolchain Check: Ensure moon info && moon fmt && moon test passes with zero warnings.

Submit PR: Open a Pull Request targeting the main branch.

### 📜 Licensing & Credits
By contributing to tqdmoon, you agree that your contributions will be licensed under the project's MIT License.

Note: This project is a proud reimplementation inspired by Python's tqdm. We respect original authorship and ecosystem porting etiquette.