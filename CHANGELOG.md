# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- **GitHub Actions CI** — `.github/workflows/ci.yml` runs `moon fmt`, `moon info`, and `moon test` on every push to `main`/`master` and every pull request.
- **GitHub Actions Release** — `.github/workflows/release.yml` runs the same validation checks on tags matching `v*.*.*` and creates a GitHub Release using the latest section from `CHANGELOG.md`.
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