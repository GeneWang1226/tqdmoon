# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- **Standalone native CLI** — `cmd/main` builds a native executable that wraps `stdin` with `tqdmoon`, enabling pipe usage such as `seq 1 100000 | tqdmoon`.
- **CLI flags** — native binary supports `--style` / `-s` (`classic`, `ascii`, `moon`, `google`), `--desc` / `-d`, and `--unit` / `-u`.
- **WebAssembly target** — `cmd/wasm` produces `tqdmoon.wasm` for frontend/edge deployment; added `web/` demo page that runs the Wasm module in a browser with a minimal WASI shim.
- **One-line installer** — `scripts/install.sh` auto-detects Linux/macOS and downloads the matching release archive; supports `VERSION` and `INSTALL_DIR` overrides.
- **All-in-one release packaging** — GitHub Actions matrix builds native binaries plus Wasm bytecode and bundles both into `tqdmoon-<os>.tar.gz` (`dist/bin/tqdmoon`, `dist/lib/tqdmoon.wasm`, `README.md`).
- **Dev-only release test workflow** — `.github/workflows/release-test.yml` builds and uploads artifacts on every push to `dev` without touching GitHub Releases.
- **Partial-fill skin support** — `BarStyle` gained `part1`, `part2`, `part3` fields for quarter/half/three-quarter cell rendering, enabling smoother progress granularity.
- **`make_bar_style` constructor** — public factory function for creating custom `BarStyle` values from black-box (external) packages.
- **72 tests** — expanded from 27 to 72 test cases (23 black-box + 49 white-box), covering large iterations, all four skin presets, custom styles, fallback meter mode, zero-total edge case, `format_time` hours, `progress_fill_char`, `build_progressive_fill`, and `elapsed_secs`.

### Changed

- **Renamed moon skin** — `tqdmoon_style` is now `tqdmoon_moon`; CLI flag changed from `--style style` to `--style moon`.
- **CI pipeline** — aligned with competition pre-acceptance requirements: `moon check --deny-warn`, `moon fmt --check`, `moon info` + `git diff --exit-code`, `moon test --deny-warn --enable-coverage` with coverage reporting, multi-platform matrix (ubuntu, macos, windows), and native target testing.
- **Release workflow** — automated cross-platform builds and asset upload via `softprops/action-gh-release`.

### Fixed

- **CLI argument parsing** — skip program name (`argv[0]`) so flags such as `--style moon` are parsed correctly.
- **Flicker-free rendering** — replaced `\u001b[1A` with `\u001b[1A\u001b[K` (cursor up + clear line) to eliminate residual characters from previous bar frames.
- **`format_time` hours support** — durations >= 1 hour now render as `HH:MM:SS` instead of overflowing the minute field.

## [0.1.2] - 2026-06-07

### Added

- **`desc` option** — `tqdm(iterable, desc="Loading...")` prepends a description prefix to every bar line (e.g. `Loading...: |████| 50% 5/10 [...]`). Also exposed via `Tqdm::set_desc(string)` for fluent switching.
- **`unit` option** — `tqdm(iterable, unit="B")` customizes the count and rate labels (default `"items"`; e.g. `"it"`, `"B"` → `1024 B [00:02, 512 B/s]`). Also exposed via `Tqdm::set_unit(string)`.
- **`disabled` option** — `tqdm(iterable, disabled=true)` disables all progress-bar output while still yielding every item; useful for debugging and silent mode. Also exposed via `Tqdm::set_disabled(bool)` for fluent switching.
- **GitHub Actions CI** — `.github/workflows/ci.yml` runs `moon fmt`, `moon info`, and `moon test` on every push and pull request.
- **GitHub Actions Release** — `.github/workflows/release.yml` runs validation checks on tags matching `v*.*.*` and creates a GitHub Release using the latest section from `CHANGELOG.md`.
- **Contributing guide** — documented the CI setup and added a reusable AI-agent prompt for future workflow changes (`CONTRIBUTING.md`).

## [0.1.1] - 2026-06-01

### Changed

- **Renamed built-in skins** for consistent `tqdmoon_` prefix:
  - `tqd_classic` → `tqdmoon_classic`
  - `tqd_ascii` → `tqdmoon_ascii`
  - `tqd_moon` → `tqdmoon_style`
  - `tqd_google` → `tqdmoon_google`
- **`tqdmoon_google` bar** — progressive solid-to-hollow animation spelling `tqdm...oon`.
- **Tests** — trimmed redundant cases (22 total); removed duplicate `test/` demo package.
- **Contributing guide** — documented standard release workflow: GitHub push/merge first, then `moon publish` to Mooncake (`CONTRIBUTING.md`).
- **README.md** — added official repository links (Mooncakes & GitHub) and `moon add` installation instructions.

## [0.1.0] - 2025-05-29

### Added

- **Core progress bar engine** — `tqdm[T]` wrapper around `Iter[T]` with automatic counting, rendering, and terminal flushing on every `.next()` call.
- **Auto cleanup** — Prints a trailing newline when the iterator is exhausted so subsequent output never overwrites the bar.
- **Fallback meter mode** — When `total` is `None`, degrades gracefully to a counter showing elapsed time and processing rate (e.g. `50 items [00:04, 12.5 items/s]`).
- **BarStyle / skin system** — Fully customizable `BarStyle` struct plus four built-in presets:
  - `tqdmoon_classic` — solid block bar
  - `tqdmoon_ascii` — ASCII bracket bar
  - `tqdmoon_style` — moon-phase emoji bar
  - `tqdmoon_google` — fun prefix-mode meme bar (`tqdm...oon`)
- **Chainable API** — `Tqdm::set_style(style)` returns a new instance for fluent skin switching.
- **Unit tests** — Black-box tests for public API (`tqdmoon_test.mbt`) and white-box tests for internal helpers (`tqdmoon_wbtest.mbt`).
- **Demo program** — `cmd/main/main.mbt` (skin comparison).
- **Documentation** — English `README.md` and Chinese `docs/README_zh.md` with usage, API reference, and directory structure.

### Fixed

- README.md table rendering: escaped `|` characters so progress-bar previews display correctly in Markdown tables.

## Earlier commits

- `418a089` — Added initial README.
- `49102ad` — Implemented progress bar component and ensured all tests pass.
- `e8b4981` — Added testing module.
- `31e8cfc` — Added core components.
- `b5ecb19` — Implemented progress bar logic with styles.
- `3355a9b` — Updated LICENSE and initialized `moon new tqdmoon`.
- `a0ae8ae` — Added project docs: AGENTS, LICENSE, and CONTRIBUTING guidelines.
- `bef98eb` — Initial commit.