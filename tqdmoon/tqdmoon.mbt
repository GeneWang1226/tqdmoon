///|
pub struct BarStyle {
  left : String
  right : String
  fill : String
  head : String
  tail : String
  empty : String
  width : Int
  is_prefix : Bool
  is_gradient : Bool
}

///|
pub let tqdmoon_classic : BarStyle = BarStyle::{
  left: "|",
  right: "|",
  fill: "█",
  head: "",
  tail: "",
  empty: " ",
  width: 20,
  is_prefix: false,
  is_gradient: false,
}

///|
pub let tqdmoon_ascii : BarStyle = BarStyle::{
  left: "[",
  right: "]",
  fill: "=",
  head: ">",
  tail: "",
  empty: " ",
  width: 20,
  is_prefix: false,
  is_gradient: false,
}

///|
pub let tqdmoon_style : BarStyle = BarStyle::{
  left: "|",
  right: "|",
  fill: "🌕",
  head: "",
  tail: "",
  empty: "🌑",
  width: 10,
  is_prefix: false,
  is_gradient: false,
}

///|
pub let tqdmoon_google : BarStyle = BarStyle::{
  left: "",
  right: "",
  fill: "●",
  head: "tqdm",
  tail: "on",
  empty: "o",
  width: 20,
  is_prefix: true,
  is_gradient: true,
}

///|
pub fn make_bar_style(
  left? : String = "|",
  right? : String = "|",
  fill? : String = "█",
  head? : String = "",
  tail? : String = "",
  empty? : String = " ",
  width? : Int = 20,
  is_prefix? : Bool = false,
  is_gradient? : Bool = false,
) -> BarStyle {
  BarStyle::{
    left,
    right,
    fill,
    head,
    tail,
    empty,
    width,
    is_prefix,
    is_gradient,
  }
}

///|
pub struct Tqdm[T] {
  iterable : Iter[T]
  total : Int?
  start_instant : @bench.Timestamp
  bar_style : BarStyle
  desc : String
  unit : String
  current : Int
  last_render_time : Double
  disabled : Bool
}

///|
pub fn[T] tqdm(
  iterable : Iter[T],
  total? : Int? = None,
  style? : BarStyle = tqdmoon_classic,
  desc? : String = "",
  unit? : String = "items",
  disabled? : Bool = false,
) -> Tqdm[T] {
  Tqdm::{
    iterable,
    total,
    start_instant: @bench.monotonic_clock_start(),
    bar_style: style,
    desc,
    unit,
    current: 0,
    last_render_time: 0.0,
    disabled,
  }
}

///|
pub fn[T] Tqdm::set_style(self : Tqdm[T], style : BarStyle) -> Tqdm[T] {
  Tqdm::{ ..self, bar_style: style }
}

///|
pub fn[T] Tqdm::set_disabled(self : Tqdm[T], disabled : Bool) -> Tqdm[T] {
  Tqdm::{ ..self, disabled, }
}

///|
pub fn[T] Tqdm::set_desc(self : Tqdm[T], desc : String) -> Tqdm[T] {
  Tqdm::{ ..self, desc, }
}

///|
pub fn[T] Tqdm::set_unit(self : Tqdm[T], unit : String) -> Tqdm[T] {
  Tqdm::{ ..self, unit, }
}

///|
fn repeat_string(s : String, n : Int) -> String {
  if n <= 0 {
    ""
  } else {
    s + repeat_string(s, n - 1)
  }
}

///|
fn progress_fill_char(style : BarStyle, index : Int, filled : Int) -> String {
  if index < filled {
    style.empty
  } else {
    style.fill
  }
}

///|
fn build_progressive_fill(style : BarStyle, filled : Int) -> String {
  build_progressive_fill_loop(style, filled, style.width, 0, "")
}

///|
fn build_progressive_fill_loop(
  style : BarStyle,
  filled : Int,
  width : Int,
  index : Int,
  acc : String,
) -> String {
  if index >= width {
    acc
  } else {
    build_progressive_fill_loop(
      style,
      filled,
      width,
      index + 1,
      acc + progress_fill_char(style, index, filled),
    )
  }
}

///|
fn build_bar_body(style : BarStyle, progress : Int) -> String {
  if style.is_prefix {
    if style.is_gradient {
      let suffix = if progress >= style.width { style.tail } else { "n" }
      style.head + build_progressive_fill(style, progress) + suffix
    } else {
      style.head + repeat_string(style.fill, progress) + style.tail
    }
  } else {
    let n = progress
    let w = style.width
    if n >= w {
      repeat_string(style.fill, w)
    } else {
      let filled = repeat_string(style.fill, n) + style.head
      filled + repeat_string(style.empty, w - n - style.head.length())
    }
  }
}

///|
fn format_time(secs : Double) -> String {
  let total = secs.to_int()
  let hours = total / 3600
  let mins = total % 3600 / 60
  let sec = total % 60
  let pad = fn(x : Int) -> String {
    if x < 10 {
      "0" + x.to_string()
    } else {
      x.to_string()
    }
  }
  if hours > 0 {
    pad(hours) + ":" + pad(mins) + ":" + pad(sec)
  } else {
    pad(mins) + ":" + pad(sec)
  }
}

///|
fn format_rate(rate : Double, unit : String) -> String {
  let suffix = " " + unit + "/s"
  let int_part = rate.to_int()
  if int_part.to_double() == rate {
    int_part.to_string() + suffix
  } else {
    let tenth = (rate * 10.0).to_int()
    let whole = tenth / 10
    let frac = tenth % 10
    whole.to_string() + "." + frac.to_string() + suffix
  }
}

///|
fn apply_desc_prefix(desc : String, bar : String) -> String {
  if desc.is_empty() {
    bar
  } else {
    desc + ": " + bar
  }
}

///|
fn render_bar(
  total : Int?,
  current : Int,
  style : BarStyle,
  elapsed : Double,
  desc : String,
  unit : String,
) -> String {
  match total {
    None => {
      let rate = if elapsed > 0.0 { current.to_double() / elapsed } else { 0.0 }
      apply_desc_prefix(
        desc,
        current.to_string() +
        " " +
        unit +
        " [" +
        format_time(elapsed) +
        ", " +
        format_rate(rate, unit) +
        "]",
      )
    }
    Some(n) =>
      if n == 0 {
        apply_desc_prefix(desc, "0/0")
      } else {
        let pct = current * 100 / n
        let filled = current * style.width / n
        let body = build_bar_body(style, filled)
        let rate = if elapsed > 0.0 {
          current.to_double() / elapsed
        } else {
          0.0
        }
        let eta = if rate > 0.0 {
          (n - current).to_double() / rate
        } else {
          0.0
        }
        apply_desc_prefix(
          desc,
          style.left +
          body +
          style.right +
          " " +
          pct.to_string() +
          "% " +
          current.to_string() +
          "/" +
          n.to_string() +
          " [" +
          format_time(elapsed) +
          "<" +
          format_time(eta) +
          ", " +
          format_rate(rate, unit) +
          "]",
        )
      }
  }
}

///|
fn elapsed_secs(start : @bench.Timestamp) -> Double {
  @bench.monotonic_clock_end(start) / 1_000_000.0
}

///|
pub fn[T] Tqdm::iter(self : Tqdm[T]) -> Iter[T] {
  let iterable = self.iterable
  let total = self.total
  let start_instant = self.start_instant
  let bar_style = self.bar_style
  let desc = self.desc
  let unit = self.unit
  let disabled = self.disabled
  let mut current = self.current
  let mut last_render_time = self.last_render_time
  let mut first_render = true
  let size_hint = match total {
    None => -1
    Some(n) => n
  }

  Iter::new(
    fn() {
      let item = iterable.next()
      match item {
        None => {
          if disabled == false {
            let elapsed = elapsed_secs(start_instant)
            let bar = render_bar(total, current, bar_style, elapsed, desc, unit)
            if first_render {
              println(bar)
            } else {
              println("\u001b[1A\u001b[K" + bar)
            }
          }
          None
        }
        Some(x) => {
          current = current + 1
          if disabled == false {
            let elapsed = elapsed_secs(start_instant)
            if elapsed - last_render_time >= 0.05 {
              let bar = render_bar(
                total, current, bar_style, elapsed, desc, unit,
              )
              if first_render {
                println(bar)
                first_render = false
              } else {
                println("\u001b[1A\u001b[K" + bar)
              }
              last_render_time = elapsed
            }
          }
          Some(x)
        }
      }
    },
    size_hint~,
  )
}
