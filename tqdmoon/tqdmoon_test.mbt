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
