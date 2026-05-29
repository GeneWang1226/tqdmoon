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
  let body0 = build_bar_body(tqd_google, 0)
  assert_eq(body0, "tqdm")
  assert_eq(body0.length(), 4)

  let body5 = build_bar_body(tqd_google, 5)
  assert_eq(body5.length(), 9)
  assert_true(body5.has_prefix("tqd"))
  assert_true(body5.has_suffix("m"))

  let body20 = build_bar_body(tqd_google, 20)
  assert_eq(body20.length(), 24)
  assert_true(body20.has_prefix("tqd"))
  assert_true(body20.has_suffix("m"))
}

///|
test "build_bar_body non-prefix empty" {
  let body = build_bar_body(tqd_ascii, 0)
  assert_eq(body, ">                   ")
}

///|
test "build_bar_body non-prefix full" {
  let body = build_bar_body(tqd_ascii, 20)
  assert_eq(body, "====================")
}

///|
test "build_bar_body non-prefix partial" {
  let body = build_bar_body(tqd_ascii, 5)
  assert_eq(body, "=====>              ")
}

///|
test "build_bar_body classic full" {
  let body = build_bar_body(tqd_classic, 20)
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
  let r = format_rate(10.5)
  assert_eq(r, "10.5 items/s")
}

///|
test "format_rate zero" {
  let r = format_rate(0.0)
  assert_true(r.contains("items/s"))
  assert_true(r.has_prefix("0"))
}

///|
test "format_rate integer" {
  let r = format_rate(14.0)
  assert_eq(r, "14 items/s")
}

///|
test "render_bar fallback mode" {
  let bar = render_bar(None, 42, tqd_ascii, 3.0)
  assert_true(bar.contains("42 items"))
  assert_true(bar.contains("00:03"))
}

///|
test "render_bar zero total" {
  let bar = render_bar(Some(0), 0, tqd_ascii, 0.0)
  assert_true(bar.contains("0/0"))
}

///|
test "render_bar partial progress" {
  let bar = render_bar(Some(10), 5, tqd_ascii, 1.0)
  assert_true(bar.contains("50%"))
  assert_true(bar.contains("5/10"))
  assert_true(bar.contains("["))
  assert_true(bar.contains("]"))
}

///|
test "render_bar full progress" {
  let bar = render_bar(Some(5), 5, tqd_ascii, 2.0)
  assert_true(bar.contains("100%"))
  assert_true(bar.contains("5/5"))
}

///|
test "elapsed_secs returns non-negative" {
  let start = @bench.monotonic_clock_start()
  let elapsed = elapsed_secs(start)
  assert_true(elapsed >= 0.0)
}

///|
test "Tqdm::iter wraps and yields all items" {
  let data = [1, 2, 3, 4, 5].iter()
  let t = tqdm(data, total=Some(5))
  let iter = t.iter()
  let mut i = 0
  for x in iter {
    i = i + 1
    ignore(x)
  }
  assert_eq(i, 5)
}

///|
test "Tqdm::set_style preserves other Tqdm fields" {
  let items = [1, 2].iter()
  let t = tqdm(items, total=Some(2))
  let styled = t.set_style(tqd_google)
  assert_eq(styled.total, Some(2))
  assert_eq(styled.first_render, true)
  assert_eq(styled.current, 0)
}
