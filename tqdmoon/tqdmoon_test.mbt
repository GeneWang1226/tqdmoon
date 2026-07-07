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
