///|
test "tqdm yields correct items with total" {
  let items = [10, 20, 30].iter()
  let t = @tqdmoon.tqdm(items, total=Some(3))
  let mut count = 0
  let mut sum = 0
  for x in t {
    count = count + 1
    sum = sum + x
  }
  assert_eq(count, 3)
  assert_eq(sum, 60)
}

///|
test "tqdm yields correct items without total" {
  let items = [100, 200].iter()
  let t = @tqdmoon.tqdm(items)
  let mut count = 0
  for x in t {
    count = count + 1
    ignore(x)
  }
  assert_eq(count, 2)
}

///|
test "tqdm yields nothing for empty iterator" {
  let items : Array[Int] = []
  let t = @tqdmoon.tqdm(items.iter(), total=Some(0))
  let mut count = 0
  for x in t {
    count = count + 1
    ignore(x)
  }
  assert_eq(count, 0)
}

///|
test "set_style returns a Tqdm with updated style" {
  let items = [1].iter()
  let t = @tqdmoon.tqdm(items, total=Some(1))
  let styled = t.set_style(@tqdmoon.tqdmoon_ascii)
  assert_eq(styled.bar_style.fill, "=")
  assert_eq(styled.bar_style.head, ">")
}

///|
test "disabled tqdm still yields all items" {
  let items = [10, 20, 30].iter()
  let t = @tqdmoon.tqdm(items, total=Some(3), disabled=true)
  let mut count = 0
  let mut sum = 0
  for x in t {
    count = count + 1
    sum = sum + x
  }
  assert_eq(count, 3)
  assert_eq(sum, 60)
}

///|
test "set_disabled returns a Tqdm with updated disabled flag" {
  let items = [1, 2].iter()
  let t = @tqdmoon.tqdm(items, total=Some(2))
  let disabled_t = t.set_disabled(true)
  assert_eq(disabled_t.disabled, true)
  assert_eq(t.disabled, false)
}

///|
test "tqdm accepts desc and unit" {
  let items = [1, 2].iter()
  let t = @tqdmoon.tqdm(items, total=Some(2), desc="Loading", unit="B")
  assert_eq(t.desc, "Loading")
  assert_eq(t.unit, "B")
}

///|
test "set_desc returns a Tqdm with updated desc" {
  let items = [1].iter()
  let t = @tqdmoon.tqdm(items, total=Some(1))
  let updated = t.set_desc("Processing")
  assert_eq(updated.desc, "Processing")
  assert_eq(t.desc, "")
}

///|
test "set_unit returns a Tqdm with updated unit" {
  let items = [1].iter()
  let t = @tqdmoon.tqdm(items, total=Some(1))
  let updated = t.set_unit("it")
  assert_eq(updated.unit, "it")
  assert_eq(t.unit, "items")
}

///|
test "tqdm large iteration yields all items" {
  let items = Array::makei(1000, fn(i) { i })
  let t = @tqdmoon.tqdm(items.iter(), total=Some(1000))
  let mut count = 0
  for x in t {
    count = count + 1
    ignore(x)
  }
  assert_eq(count, 1000)
}

///|
test "tqdm with custom BarStyle" {
  let items = [1, 2, 3].iter()
  let custom = @tqdmoon.make_bar_style(
    left="(",
    right=")",
    fill="#",
    empty="-",
    width=10,
  )
  let t = @tqdmoon.tqdm(items, total=Some(3), style=custom)
  let mut count = 0
  for x in t {
    count = count + 1
    ignore(x)
  }
  assert_eq(count, 3)
}

///|
test "tqdm with all four preset styles works" {
  let styles = [
    @tqdmoon.tqdmoon_classic, @tqdmoon.tqdmoon_ascii, @tqdmoon.tqdmoon_style, @tqdmoon.tqdmoon_google,
  ]
  for style in styles {
    let items = [1, 2].iter()
    let t = @tqdmoon.tqdm(items, total=Some(2), style~)
    let mut count = 0
    for x in t {
      count = count + 1
      ignore(x)
    }
    assert_eq(count, 2)
  }
}

///|
test "tqdm with desc and unit in fallback mode" {
  let items = [10, 20].iter()
  let t = @tqdmoon.tqdm(items, desc="Data", unit="B")
  assert_eq(t.desc, "Data")
  assert_eq(t.unit, "B")
  let mut count = 0
  for x in t {
    count = count + 1
    ignore(x)
  }
  assert_eq(count, 2)
}

///|
test "tqdm with zero total yields all items" {
  let items : Array[Int] = []
  let t = @tqdmoon.tqdm(items.iter(), total=Some(0))
  let mut count = 0
  for x in t {
    count = count + 1
    ignore(x)
  }
  assert_eq(count, 0)
}

///|
test "tqdm with total=1 yields single item" {
  let items = [42].iter()
  let t = @tqdmoon.tqdm(items, total=Some(1))
  let mut count = 0
  let mut val = 0
  for x in t {
    count = count + 1
    val = x
  }
  assert_eq(count, 1)
  assert_eq(val, 42)
}

///|
test "tqdmoon_style preset has correct fields" {
  assert_eq(@tqdmoon.tqdmoon_style.fill, "🌕")
  assert_eq(@tqdmoon.tqdmoon_style.empty, "🌑")
  assert_eq(@tqdmoon.tqdmoon_style.width, 10)
}

///|
test "tqdmoon_google preset has is_prefix and is_gradient" {
  assert_eq(@tqdmoon.tqdmoon_google.is_prefix, true)
  assert_eq(@tqdmoon.tqdmoon_google.is_gradient, true)
  assert_eq(@tqdmoon.tqdmoon_google.head, "tqdm")
  assert_eq(@tqdmoon.tqdmoon_google.tail, "on")
}

///|
test "set_desc and set_unit chained" {
  let items = [1, 2].iter()
  let t = @tqdmoon.tqdm(items, total=Some(2)).set_desc("Test").set_unit("it")
  assert_eq(t.desc, "Test")
  assert_eq(t.unit, "it")
}

///|
test "disabled tqdm with desc preserves all items" {
  let items = [5, 10, 15].iter()
  let t = @tqdmoon.tqdm(items, total=Some(3), desc="Hidden", disabled=true)
  let mut sum = 0
  for x in t {
    sum = sum + x
  }
  assert_eq(sum, 30)
  assert_eq(t.desc, "Hidden")
}

///|
test "tqdm with no optional args uses defaults" {
  let items = [1].iter()
  let t = @tqdmoon.tqdm(items)
  assert_eq(t.desc, "")
  assert_eq(t.unit, "items")
  assert_eq(t.disabled, false)
  assert_eq(t.current, 0)
}

///|
test "tqdm default style is classic" {
  let items = [1].iter()
  let t = @tqdmoon.tqdm(items)
  assert_eq(t.bar_style.fill, "█")
  assert_eq(t.bar_style.empty, " ")
}
