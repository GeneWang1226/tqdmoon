# tqdmoon

> A pure-functional, zero-overhead, iterator-wrapping progress bar library for MoonBit, inspired by Python's `tqdm`.

[![GitHub release](https://img.shields.io/github/v/release/GeneWang1226/tqdmoon)](https://github.com/GeneWang1226/tqdmoon/releases)
[![Build Status](https://img.shields.io/github/actions/workflow/status/GeneWang1226/tqdmoon/ci.yml?label=build)](https://github.com/GeneWang1226/tqdmoon/actions/workflows/ci.yml)
[![License](https://img.shields.io/github/license/GeneWang1226/tqdmoon)](./LICENSE)

**[中文文档](./docs/README_zh.md)**

- **Mooncakes**: <https://mooncakes.io/docs/GeneWang1226/tqdmoon>
- **GitHub**: <https://github.com/GeneWang1226/tqdmoon>

## Features

- **Iterator Wrapping** — Just pass an `Iter[T]` in; counting, rendering, and terminal flushing are all automatic
- **Zero Manual Intervention** — No need to manually call `update()` or `render()`
- **Auto Cleanup** — Automatically prints a newline when the iterator is exhausted, so subsequent output won't overwrite the bar
- **Fallback Mode** — When total is unknown, degrades gracefully to a meter mode showing elapsed time and processing rate
- **Description & Unit** — Optional `desc` prefix and customizable `unit` (default `"items"`) for count and rate labels
- **Multi-Skin System** — 4 built-in presets + fully customizable `BarStyle`
- **Zero External Dependencies** — Uses only MoonBit core primitives

## Import

### Using `moon add` (Recommended)

```bash
# Add the latest version
moon add GeneWang1226/tqdmoon

# Or add a specific version
moon add GeneWang1226/tqdmoon@0.1.1
```

### Manual Import

Add to your `moon.pkg`:

```moonbit
import {
  "GeneWang1226/tqdmoon",
}
```

## Quick Start

### Basic Usage (with total)

```moonbit
fn main {
  let items = (0).until(9000000)
  for _ in @tqdmoon.tqdm(items, total=Some(9000000)) {}
}
```

Output: `|████████████████████| 100% 9000000/9000000 [00:00<00:00, 21801311.5 items/s]`

### Fallback Mode (without total)

```moonbit
for x in @tqdmoon.tqdm([10, 20, 30].iter()) {
  ignore(x)
}
```

Output: `3 items [00:00, 405405.4 items/s]`

### Description & Unit

```moonbit
// Prefix description + custom unit
for x in @tqdmoon.tqdm(items, total=Some(100), desc="Loading", unit="B") {
  ignore(x)
}
```

Output: `Loading: |██████████          | 50% 50/100 [00:01<00:01, 50 B/s]`

```moonbit
// Chainable setters
@tqdmoon.tqdm(items, total=Some(10))
  .set_desc("Processing")
  .set_unit("it")
```

## Skins

Four built-in presets:

```moonbit
// tqdmoon_classic — default, solid block
@tqdmoon.tqdm(items, total=Some(5), style=@tqdmoon.tqdmoon_classic)

// tqdmoon_ascii — ASCII characters
@tqdmoon.tqdm(items, total=Some(5), style=@tqdmoon.tqdmoon_ascii)

// tqdmoon_style — moon phase icons
@tqdmoon.tqdm(items, total=Some(5), style=@tqdmoon.tqdmoon_style)

// tqdmoon_google — fun meme, chainable
@tqdmoon.tqdm(items, total=Some(5)).set_style(@tqdmoon.tqdmoon_google)
```

Preview:

| Skin              | Example                              |
| ----------------- | ------------------------------------ |
| `tqdmoon_classic` | `\|████████░░░░░░░░░░░░\|  50% 5/10` |
| `tqdmoon_ascii`   | `[=====>               ]  25%`       |
| `tqdmoon_style`   | `\|🌕🌕🌕🌕🌕🌑🌑🌑🌑🌑\|  50%`      |
| `tqdmoon_google`  | `tqdmooooooooooooooooooooon  100%`   |

### Custom Skin

Construct a `BarStyle` to customize appearance:

```moonbit
let my_style = @tqdmoon.BarStyle::{
  left: "(",
  right: ")",
  fill: "#",
  head: "",
  tail: "",
  empty: "-",
  width: 30,
  is_prefix: false,
}

for x in @tqdmoon.tqdm(items, total=Some(10), style=my_style) {
  ignore(x)
}
```

## API

```moonbit
// Create a progress bar
pub fn[T] tqdm(
  iterable : Iter[T],
  total~    : Int?    = None,
  style~    : BarStyle = tqdmoon_classic,
  desc~     : String  = "",
  unit~     : String  = "items",
  disabled~ : Bool    = false,
) -> Tqdm[T]

// Chainable setters (each returns a new instance)
pub fn[T] Tqdm::set_style(self : Tqdm[T], style : BarStyle) -> Tqdm[T]
pub fn[T] Tqdm::set_desc(self : Tqdm[T], desc : String) -> Tqdm[T]
pub fn[T] Tqdm::set_unit(self : Tqdm[T], unit : String) -> Tqdm[T]
pub fn[T] Tqdm::set_disabled(self : Tqdm[T], disabled : Bool) -> Tqdm[T]
```

### BarStyle

| Field       | Type     | Description                                        |
| ----------- | -------- | -------------------------------------------------- |
| `left`      | `String` | Left boundary of the bar                           |
| `right`     | `String` | Right boundary of the bar                          |
| `fill`      | `String` | Filled character                                   |
| `head`      | `String` | Bar head (or prefix in prefix mode)                |
| `tail`      | `String` | Bar tail (or suffix in prefix mode)                |
| `empty`     | `String` | Empty character                                    |
| `width`     | `Int`    | Total width of the bar                             |
| `is_prefix` | `Bool`   | Whether to use prefix mode (e.g. `tqdmoon_google`) |

## Testing

Run from the `tqdmoon/` package directory:

```bash
cd tqdmoon

# Run unit tests (33 cases)
moon test

# Run the skin showcase demo
moon run cmd/main
```

## Directory Structure

```
tqdmoon/
├── moon.pkg              # Package dependency declaration
├── tqdmoon.mbt           # Core library code
├── tqdmoon_test.mbt      # Black-box tests (public API)
├── tqdmoon_wbtest.mbt    # White-box tests (internal functions)
└── cmd/main/
    ├── moon.pkg
    └── main.mbt          # Skin comparison demo
```

