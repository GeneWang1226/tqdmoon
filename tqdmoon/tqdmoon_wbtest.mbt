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
  let bar = render_bar(None, 42, tqdmoon_ascii, 3.0)
  assert_true(bar.contains("42 items"))
  assert_true(bar.contains("00:03"))
}

///|
test "render_bar zero total" {
  let bar = render_bar(Some(0), 0, tqdmoon_ascii, 0.0)
  assert_true(bar.contains("0/0"))
}

///|
test "render_bar partial progress" {
  let bar = render_bar(Some(10), 5, tqdmoon_ascii, 1.0)
  assert_true(bar.contains("50%"))
  assert_true(bar.contains("5/10"))
  assert_true(bar.contains("["))
  assert_true(bar.contains("]"))
}

///|
test "render_bar full progress" {
  let bar = render_bar(Some(5), 5, tqdmoon_ascii, 2.0)
  assert_true(bar.contains("100%"))
  assert_true(bar.contains("5/5"))
}

///|
test "Tqdm::set_style preserves other Tqdm fields" {
  let items = [1, 2].iter()
  let t = tqdm(items, total=Some(2))
  let styled = t.set_style(tqdmoon_google)
  assert_true(styled.total is Some(_))
  assert_eq(styled.first_render, true)
  assert_eq(styled.current, 0)
}

///|
test "Tqdm::set_disabled preserves other Tqdm fields" {
  let items = [1, 2].iter()
  let t = tqdm(items, total=Some(2))
  let disabled_t = t.set_disabled(true)
  assert_eq(disabled_t.disabled, true)
  assert_true(disabled_t.total is Some(_))
  assert_eq(disabled_t.first_render, true)
  assert_eq(disabled_t.current, 0)
}
