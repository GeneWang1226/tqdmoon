///|
test "repeat_string basic" {
  assert_eq(repeat_string("a", 0), "")
  assert_eq(repeat_string("a", 1), "a")
  assert_eq(repeat_string("ab", 3), "ababab")
  assert_eq(repeat_string("", 5), "")
}

///|
test "repeat_string negative" {
  assert_eq(repeat_string("x", -1), "")
}

///|
test "build_bar_body with prefix skin" {
  let body0 = build_bar_body(tqdmoon_google, 0)
  assert_eq(body0, "tqdm" + repeat_string("●", 20) + "n")

  let body5 = build_bar_body(tqdmoon_google, 5)
  assert_eq(
    body5,
    "tqdm" + repeat_string("o", 5) + repeat_string("●", 15) + "n",
  )

  let body20 = build_bar_body(tqdmoon_google, 20)
  assert_eq(body20, "tqdm" + repeat_string("o", 20) + "on")
}

///|
test "build_bar_body non-prefix empty" {
  let body = build_bar_body(tqdmoon_ascii, 0)
  assert_eq(body, ">                   ")
}

///|
test "build_bar_body non-prefix full" {
  let body = build_bar_body(tqdmoon_ascii, 20)
  assert_eq(body, "====================")
}

///|
test "build_bar_body non-prefix partial" {
  let body = build_bar_body(tqdmoon_ascii, 5)
  assert_eq(body, "=====>              ")
}

///|
test "build_bar_body classic full" {
  let body = build_bar_body(tqdmoon_classic, 20)
  assert_eq(
    body, "████████████████████",
  )
}

///|
test "format_time zero seconds" {
  assert_eq(format_time(0.0), "00:00")
}

///|
test "format_time single digit minutes" {
  assert_eq(format_time(6.4), "00:06")
}

///|
test "format_time two digit minutes" {
  assert_eq(format_time(125.0), "02:05")
}

///|
test "format_rate basic" {
  let r = format_rate(10.5, "items")
  assert_eq(r, "10.5 items/s")
}

///|
test "format_rate zero" {
  let r = format_rate(0.0, "items")
  assert_true(r.contains("items/s"))
  assert_true(r.has_prefix("0"))
}

///|
test "format_rate integer" {
  let r = format_rate(14.0, "items")
  assert_eq(r, "14 items/s")
}

///|
test "format_rate custom unit" {
  let r = format_rate(8.0, "B")
  assert_eq(r, "8 B/s")
}

///|
test "apply_desc_prefix empty" {
  assert_eq(apply_desc_prefix("", "50%"), "50%")
}

///|
test "apply_desc_prefix with desc" {
  assert_eq(apply_desc_prefix("Loading", "50%"), "Loading: 50%")
}

///|
test "render_bar fallback mode" {
  let bar = render_bar(None, 42, tqdmoon_ascii, 3.0, "", "items")
  assert_true(bar.contains("42 items"))
  assert_true(bar.contains("00:03"))
}

///|
test "render_bar fallback mode custom unit" {
  let bar = render_bar(None, 1024, tqdmoon_ascii, 2.0, "", "B")
  assert_true(bar.contains("1024 B"))
  assert_true(bar.contains("B/s"))
}

///|
test "render_bar with desc" {
  let bar = render_bar(Some(10), 5, tqdmoon_ascii, 1.0, "Loading", "items")
  assert_true(bar.has_prefix("Loading: "))
  assert_true(bar.contains("50%"))
}

///|
test "render_bar zero total" {
  let bar = render_bar(Some(0), 0, tqdmoon_ascii, 0.0, "", "items")
  assert_true(bar.contains("0/0"))
}

///|
test "render_bar partial progress" {
  let bar = render_bar(Some(10), 5, tqdmoon_ascii, 1.0, "", "items")
  assert_true(bar.contains("50%"))
  assert_true(bar.contains("5/10"))
  assert_true(bar.contains("["))
  assert_true(bar.contains("]"))
}

///|
test "render_bar full progress" {
  let bar = render_bar(Some(5), 5, tqdmoon_ascii, 2.0, "", "items")
  assert_true(bar.contains("100%"))
  assert_true(bar.contains("5/5"))
}

///|
test "Tqdm::set_style preserves other Tqdm fields" {
  let items = [1, 2].iter()
  let t = tqdm(items, total=Some(2))
  let styled = t.set_style(tqdmoon_google)
  assert_true(styled.total is Some(_))
  assert_eq(styled.current, 0)
}

///|
test "Tqdm::set_disabled preserves other Tqdm fields" {
  let items = [1, 2].iter()
  let t = tqdm(items, total=Some(2))
  let disabled_t = t.set_disabled(true)
  assert_eq(disabled_t.disabled, true)
  assert_true(disabled_t.total is Some(_))
  assert_eq(disabled_t.current, 0)
}

///|
test "format_time with hours" {
  assert_eq(format_time(3600.0), "01:00:00")
  assert_eq(format_time(3661.0), "01:01:01")
  assert_eq(format_time(7200.0), "02:00:00")
  assert_eq(format_time(86399.0), "23:59:59")
}

///|
test "format_time large hours" {
  assert_eq(format_time(100000.0), "27:46:40")
}

///|
test "format_time boundary" {
  assert_eq(format_time(59.9), "00:59")
  assert_eq(format_time(60.0), "01:00")
  assert_eq(format_time(3599.0), "59:59")
}

///|
test "format_rate large value" {
  let r = format_rate(12345.6, "items")
  assert_eq(r, "12345.6 items/s")
}

///|
test "format_rate very small" {
  let r = format_rate(0.1, "items")
  assert_eq(r, "0.1 items/s")
}

///|
test "render_bar classic style" {
  let bar = render_bar(Some(10), 5, tqdmoon_classic, 1.0, "", "items")
  assert_true(bar.contains("50%"))
  assert_true(bar.contains("|"))
  assert_true(bar.contains("█"))
}

///|
test "render_bar google style" {
  let bar = render_bar(Some(10), 5, tqdmoon_google, 1.0, "", "items")
  assert_true(bar.contains("tqdm"))
  assert_true(bar.contains("50%"))
}

///|
test "render_bar style skin" {
  let bar = render_bar(Some(10), 5, tqdmoon_style, 1.0, "", "items")
  assert_true(bar.contains("50%"))
  assert_true(bar.contains("🌕"))
  assert_true(bar.contains("🌑"))
}

///|
test "render_bar fallback with desc" {
  let bar = render_bar(None, 10, tqdmoon_ascii, 1.0, "Download", "B")
  assert_true(bar.has_prefix("Download: "))
  assert_true(bar.contains("10 B"))
}

///|
test "render_bar at 0 percent" {
  let bar = render_bar(Some(10), 0, tqdmoon_ascii, 0.0, "", "items")
  assert_true(bar.contains("0%"))
  assert_true(bar.contains("0/10"))
}

///|
test "render_bar at 100 percent classic" {
  let bar = render_bar(Some(10), 10, tqdmoon_classic, 5.0, "", "items")
  assert_true(bar.contains("100%"))
  assert_true(bar.contains("10/10"))
}

///|
test "render_bar zero elapsed" {
  let bar = render_bar(Some(10), 5, tqdmoon_ascii, 0.0, "", "items")
  assert_true(bar.contains("50%"))
  assert_true(bar.contains("00:00"))
}

///|
test "progress_fill_char before filled" {
  let style = tqdmoon_google
  assert_eq(progress_fill_char(style, 0, 5), "o")
  assert_eq(progress_fill_char(style, 3, 5), "o")
}

///|
test "progress_fill_char after filled" {
  let style = tqdmoon_google
  assert_eq(progress_fill_char(style, 5, 5), "●")
  assert_eq(progress_fill_char(style, 6, 5), "●")
}

///|
test "progress_fill_char at boundary" {
  let style = tqdmoon_google
  assert_eq(progress_fill_char(style, 4, 5), "o")
  assert_eq(progress_fill_char(style, 5, 5), "●")
}

///|
test "build_progressive_fill empty" {
  let result = build_progressive_fill(tqdmoon_google, 0)
  assert_eq(result, repeat_string("●", 20))
}

///|
test "build_progressive_fill full" {
  let result = build_progressive_fill(tqdmoon_google, 20)
  assert_eq(result, repeat_string("o", 20))
}

///|
test "build_progressive_fill partial" {
  let result = build_progressive_fill(tqdmoon_google, 5)
  assert_eq(result, repeat_string("o", 5) + repeat_string("●", 15))
}

///|
test "build_bar_body style skin partial" {
  let body = build_bar_body(tqdmoon_style, 5)
  assert_eq(body, repeat_string("🌕", 5) + repeat_string("🌑", 5))
}

///|
test "build_bar_body style skin full" {
  let body = build_bar_body(tqdmoon_style, 10)
  assert_eq(body, repeat_string("🌕", 10))
}

///|
test "build_bar_body classic partial" {
  let body = build_bar_body(tqdmoon_classic, 10)
  assert_eq(body, repeat_string("█", 10) + repeat_string(" ", 10))
}

///|
test "build_bar_body non-prefix gradient" {
  let style = BarStyle::{
    left: "[",
    right: "]",
    fill: "=",
    head: ">",
    tail: "",
    empty: " ",
    width: 20,
    is_prefix: false,
    is_gradient: true,
  }
  let body = build_bar_body(style, 5)
  assert_eq(body, "=====>              ")
}

///|
test "repeat_string large n" {
  let result = repeat_string("x", 100)
  assert_eq(result.length(), 100)
  assert_eq(result, repeat_string("x", 50) + repeat_string("x", 50))
}

///|
test "build_bar_body google halfway" {
  let body = build_bar_body(tqdmoon_google, 10)
  assert_eq(
    body,
    "tqdm" + repeat_string("o", 10) + repeat_string("●", 10) + "n",
  )
}

///|
test "render_bar with custom narrow style" {
  let custom = BarStyle::{
    left: "<",
    right: ">",
    fill: "=",
    head: ">",
    tail: "",
    empty: "-",
    width: 10,
    is_prefix: false,
    is_gradient: false,
  }
  let bar = render_bar(Some(10), 5, custom, 1.0, "", "items")
  assert_true(bar.contains("50%"))
  assert_true(bar.has_prefix("<"))
  assert_true(bar.contains(">"))
}

///|
test "Tqdm::set_desc preserves other Tqdm fields" {
  let items = [1, 2].iter()
  let t = tqdm(items, total=Some(2))
  let updated = t.set_desc("Test")
  assert_eq(updated.desc, "Test")
  assert_true(updated.total is Some(_))
  assert_eq(updated.current, 0)
}

///|
test "Tqdm::set_unit preserves other Tqdm fields" {
  let items = [1, 2].iter()
  let t = tqdm(items, total=Some(2))
  let updated = t.set_unit("B")
  assert_eq(updated.unit, "B")
  assert_true(updated.total is Some(_))
  assert_eq(updated.current, 0)
}
