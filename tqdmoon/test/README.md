# moontqdm

A zero-overhead, wrapper-based progress bar library for the MoonBit ecosystem, inspired by Python's `tqdm`.

## Features

- **Automatic wrapping**: Wrap any `Iter[T]` — progress tracking happens automatically as you iterate
- **Auto clean-up**: Appends a newline when the iterator is exhausted
- **Fallback stream mode**: When `total` is unknown, degrades gracefully into a dynamic meter showing elapsed time and rates
- **Multi-skin system**: Four built-in themes with chainable style switching
- **Zero external dependencies**: Uses only `builtin` and `bench` core primitives

## Installation

Add this package to your project's `moon.pkg`:

```moonbit
import {
  "moonbitlang/core/builtin",
  "GeneWang1226/tqdmoon",
}
```

Or use the `moon add` command:

```bash
moon add GeneWang1226/tqdmoon
```

## Quick Start

```moonbit
import "GeneWang1226/tqdmoon"

fn main {
  let items = [1, 2, 3, 4, 5].iter()
  let bar = @tqdmoon.tqdm(items, total=Some(5))
  for x in bar {
    ignore(x)
  }
}
```

## Changing Styles

### Using the `style~` parameter

Pass the style directly when creating the tqdm:

```moonbit
let bar = @tqdmoon.tqdm(items, total=Some(5), style=@tqdmoon.tqd_ascii)
```

### Using `set_style()` for chainable calls

```moonbit
let bar = @tqdmoon.tqdm(items, total=Some(5))
  .set_style(@tqdmoon.tqd_google)
```

## Built-in Styles

| Style | Description | Example |
|-------|-------------|---------|
| `tqd_classic` | Traditional block bar | `\|████████░░░░░░░░░░░\| 50%` |
| `tqd_ascii` | ASCII art bar | `[=====>               ] 50%` |
| `tqd_moon` | Moon phase icons | `\|🌕🌕🌕🌑🌑🌑🌑🌑🌑🌑\| 50%` |
| `tqd_google` | Fun Google-style bar | `tqdoooooooooooooooooooom` |

## API Reference

### `tqdm[T](iterable, total?, style?)`

Creates a progress-wrapped iterator.

**Parameters:**
- `iterable : Iter[T]` — The iterator to wrap
- `total~ : Option[Int]` — Optional total count (omit for stream/meter mode)
- `style~ : BarStyle` — Visual style preset (default: `tqd_classic`)

**Returns:** `Tqdm[T]` — A wrapper that implements `Iter[T]`, usable in `for` loops

### `Tqdm::set_style(style)`

Returns a new `Tqdm[T]` with the specified style applied. All other fields are preserved.

### `BarStyle` Struct

For custom styles, construct a `BarStyle` directly:

```moonbit
pub struct BarStyle {
  left : String      // Left boundary character(s)
  right : String     // Right boundary character(s)
  fill : String      // Fill character(s)
  head : String      // Head character(s) at the progress front
  tail : String      // Tail character(s)
  empty : String     // Empty/remaining character(s)
  width : Int        // Bar width in characters
  is_prefix : Bool   // If true, head goes at the start (like tqd_google)
}
```

**Example — custom style:**

```moonbit
let my_style = BarStyle::{
  left: "[",
  right: "]",
  fill: "#",
  head: ">",
  tail: "",
  empty: "-",
  width: 20,
  is_prefix: false,
}

let bar = @tqdmoon.tqdm(items, total=Some(10), style=my_style)
```

## Stream Mode (Unknown Total)

When `total` is omitted or `None`, moontqdm enters stream/meter mode:

```moonbit
// No total count — shows dynamic meter
let stream = data_source.iter()
let meter = @tqdmoon.tqdm(stream)
for item in meter {
  process(item)
}
```

Output: `42 items [00:04, 10.5 items/s]`

## Complete Example

```moonbit
import "GeneWang1226/tqdmoon"

fn main {
  // Classic bar with known total
  let t1 = @tqdmoon.tqdm([1, 2, 3, 4, 5].iter(), total=Some(5))
  for x in t1 { ignore(x) }

  // Google-style bar via chainable set_style()
  let t2 = @tqdmoon.tqdm([1, 2, 3, 4, 5].iter(), total=Some(5))
    .set_style(@tqdmoon.tqd_google)
  for x in t2 { ignore(x) }

  // Stream mode — no total needed
  let t3 = @tqdmoon.tqdm([10, 20, 30].iter())
  for x in t3 { ignore(x) }
}
```

## Running Tests

```bash
moon test
```

## License

Apache-2.0