# tqdmoon

> A pure-functional, zero-overhead, iterator-wrapping progress bar library for MoonBit, inspired by Python's `tqdm`.

**[中文文档](./docs/README_zh.md)**

- **Mooncakes**: https://mooncakes.io/docs/GeneWang1226/tqdmoon
- **GitHub**: https://github.com/GeneWang1226/tqdmoon

## Features

- **Iterator Wrapping** — Just pass an `Iter[T]` in; counting, rendering, and terminal flushing are all automatic
- **Zero Manual Intervention** — No need to manually call `update()` or `render()`
- **Auto Cleanup** — Automatically prints a newline when the iterator is exhausted, so subsequent output won't overwrite the bar
- **Fallback Mode** — When total is unknown, degrades gracefully to a meter mode showing elapsed time and processing rate
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
  let items = [1, 2, 3, 4, 5].iter()
  for x in @tqdmoon.tqdm(items, total=Some(5)) {
    ignore(x)
  }
}
```

Output: `|████████████████████| 100% 5/5 [00:00<00:00, 30138.6 items/s]`

### Fallback Mode (without total)

```moonbit
for x in @tqdmoon.tqdm([10, 20, 30].iter()) {
  ignore(x)
}
```

Output: `3 items [00:00, 405405.4 items/s]`

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

| Skin | Example |
|---|---|
| `tqdmoon_classic` | `\|████████░░░░░░░░░░░░\|  50% 5/10` |
| `tqdmoon_ascii` | `[=====>               ]  25%` |
| `tqdmoon_style` | `\|🌕🌕🌕🌕🌕🌑🌑🌑🌑🌑\|  50%` |
| `tqdmoon_google` | `tqdmooooooooooooooooooooon  100%` |

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
  total~   : Option[Int] = None,
  style~   : BarStyle     = tqdmoon_classic,
) -> Tqdm[T]

// Chainable skin switcher (returns a new instance)
pub fn[T] Tqdm::set_style(self : Tqdm[T], style : BarStyle) -> Tqdm[T]
```

### BarStyle

| Field | Type | Description |
|---|---|---|
| `left` | `String` | Left boundary of the bar |
| `right` | `String` | Right boundary of the bar |
| `fill` | `String` | Filled character |
| `head` | `String` | Bar head (or prefix in prefix mode) |
| `tail` | `String` | Bar tail (or suffix in prefix mode) |
| `empty` | `String` | Empty character |
| `width` | `Int` | Total width of the bar |
| `is_prefix` | `Bool` | Whether to use prefix mode (e.g. `tqdmoon_google`) |

## Testing

Run from the `tqdmoon/` package directory:

```bash
cd tqdmoon

# Run unit tests (22 cases)
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
