# Contributing to tqdmoon

Thank you for your interest in contributing to `tqdmoon`! We are building the most elegant, seamless, and high-performance progress manager for the MoonBit ecosystem.

To maintain engineering excellence, code purity, and strict alignment with MoonBit's native toolchain, please review the guidelines below before submitting a Pull Request.

---

## 🎨 Code Style & Aesthetics

We value clean, unpolluted source code that respects both MoonBit's compiler design and our minimalism philosophy:

- **Naming Standard:**
  - Use `snake_case` for all functions, local variables, methods, and filenames (e.g., `update_progress`, `remaining_time`).
  - Use `PascalCase` exclusively for Structs, Enums, and Traits (e.g., `ProgressManager`, `BarStyle`).
- **No Comment Pollution:** Avoid commenting on obvious logic. Write expressive code where the layout and naming explain *how* it works, leaving comments only for highly abstract architectural *whys*.
- **Block Style Organization:** MoonBit code must be organized in block style, with each block separated by `///|`. Ensure your refactoring or feature additions adhere to this structure. Keep any deprecated blocks in a file called `deprecated.mbt` within the directory.

---

## 🧪 Testing & Verification Protocols (Critical)

We rely heavily on MoonBit's native testing suite to ensure `tqdmoon` does not cause terminal flickering, buffer overflows, or unexpected behavior.

### 1. Verification Workflow

Before submitting any code, you must execute the following toolchain pipeline from the `tqdmoon/` package directory:

```bash
cd tqdmoon

# 1. Update the generated interface file and format code
moon info && moon fmt

# 2. Run the test suite
moon test
```

### 2. Interface Lock (.mbti) Check

Always check the diffs of the generated `.mbti` file after running `moon info`.

- If nothing in `.mbti` changes, your change is a safe internal refactoring.
- If `.mbti` changes, ensure that any added public functions or types strictly follow the snake_case / PascalCase conventions and do not break backwards compatibility.

### 3. Snapshot & Assertion Testing

- **Snapshot Tests:** For tests recording structured terminal/debugging output, derive `Debug` and use `debug_inspect`. If your intentional changes affect the visual layout of the progress bar, run `moon test --update` to refresh the snapshots. Do not derive `Show` for debugging purposes.
- **Assertion Tests:** For solid, well-defined results (e.g., ETA math, percentage calculations), prefer `assert_eq` or `assert_true(pattern is Pattern(...))`.
- **Coverage:** Run coverage analysis to ensure your logic is fully tested:

```bash
cd tqdmoon
moon coverage analyze > uncovered.log
```

Review `uncovered.log` to make sure no critical rendering paths are left untested.

---

## 🗺️ Contribution Workflow

1. **Fork & Clone** — Fork the repository and create your feature branch from `main`.
2. **Implement** — If you use Cursor or Trae, ingest our root-level `AGENTS.md` context first so generated code matches our styling and toolchain rules.
3. **Run Toolchain Check** — Ensure `moon info && moon fmt && moon test` passes with zero warnings.
4. **Submit PR** — Open a Pull Request targeting the `main` branch.

---

## 🔄 Continuous Integration

We use GitHub Actions to validate every change before it reaches `main`.

### Workflow files

| Workflow | Trigger | What it does |
|---|---|---|
| [`.github/workflows/ci.yml`](.github/workflows/ci.yml) | `push` to `main`/`master`, every `pull_request` to `main`/`master` | Installs MoonBit, checks formatting with `moon fmt`, regenerates the `.mbti` lock with `moon info`, runs `moon test` |
| [`.github/workflows/release.yml`](.github/workflows/release.yml) | `push` of a tag matching `v*.*.*` | Runs the same checks as CI, then creates a GitHub Release using the latest section from `CHANGELOG.md` |

### CI expectations

- **Formatting must be clean.** CI runs `moon fmt` and fails if any file changes.
- **Interface lock must be up to date.** CI runs `moon info` and fails if `.mbti` files drift.
- **All tests must pass.** `moon test` is the gate for both PRs and releases.

If a workflow fails, fix the reported issue locally and push again:

```bash
cd tqdmoon
moon fmt
moon info
moon test
```

---

## 🤖 AI Agent Prompt for CI Changes

When asking an AI agent (Cursor, Trae, Copilot, etc.) to modify or extend our GitHub Actions, use this prompt to keep behavior consistent with the project:

> Add or update GitHub Actions workflows for the MoonBit project in `.github/workflows/`. The MoonBit module root is the `tqdmoon/` subdirectory, so all `run` steps must use `working-directory: tqdmoon`. Provide two workflows:
>
> 1. A `ci.yml` workflow that triggers on pushes to `main`/`master` and on pull requests to `main`/`master`. It must install the MoonBit CLI from `https://cli.moonbitlang.com/install/unix.sh`, run `moon update`, run `moon fmt` and fail if the working tree is dirty, run `moon info` and fail if `.mbti` files drift, then run `moon test`.
>
> 2. A `release.yml` workflow that triggers on tags matching `v*.*.*`. It must run the same validation steps as CI, then extract the topmost version section from `CHANGELOG.md` (located at the repository root) and create a GitHub Release with that body.
>
> Do not add automatic publishing to Mooncake in the release workflow; Mooncake publishing remains a manual step performed from `main` after merge. Use `actions/checkout@v4` and `softprops/action-gh-release@v2`. Keep workflow permissions minimal (`contents: write` only for the release job).

---

## 📦 Release & Mooncake Publishing (Standard Workflow)

**GitHub is the source of truth. Mooncake is the distribution channel.**

Always follow this order — never publish to Mooncake before the matching code is merged on GitHub:

```
local branch → git push → PR merge to main → moon publish
```

### Step 1 — Push to GitHub and merge

```bash
git push -u origin <your-branch>
```

1. Open a Pull Request targeting `main`.
2. Ensure CI and `moon test` pass.
3. Merge the PR after review.

Do **not** run `moon publish` from unmerged local commits or stale branches. The Mooncake registry must reflect code that is already reachable on GitHub.

### Step 2 — Prepare the release on `main`

Check out `main`, pull the latest, then verify:

```bash
git checkout main
git pull
cd tqdmoon
moon info && moon fmt && moon test
```

Before publishing, confirm these items in `moon.mod`:

| Field | Requirement |
|---|---|
| `version` | Bumped per [Semantic Versioning](https://semver.org/); must not duplicate an existing Mooncake release |
| `repository` | Set to the GitHub URL (e.g. `https://github.com/GeneWang1226/tqdmoon`); empty values trigger `moon publish` warnings |
| `CHANGELOG.md` | Updated under the new version with all user-facing changes |

### Step 3 — Publish to Mooncake

Only after Steps 1 and 2 are complete, from `main`:

```bash
cd tqdmoon
moon publish
```

If Mooncake returns `409 Conflict` (version already exists), bump `version` in `moon.mod`, update `CHANGELOG.md`, commit, push to `main`, and publish again.

### Quick reference

| Step | Action | Command / location |
|---|---|---|
| 1 | Push & merge | `git push` → PR → merge to `main` |
| 2 | Verify & bump | `moon test`, `moon.mod`, `CHANGELOG.md` |
| 3 | Publish | `moon publish` (from `main` only) |

---

## 📜 Licensing & Credits

By contributing to tqdmoon, you agree that your contributions will be licensed under the project's MIT License.

Note: This project is a proud reimplementation inspired by Python's tqdm. We respect original authorship and ecosystem porting etiquette.
