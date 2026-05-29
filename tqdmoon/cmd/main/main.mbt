fn main {
  // tqd_classic (默认)
  println("--- tqd_classic ---")
  for x in @tqdmoon.tqdm([1, 2, 3, 4, 5].iter(), total=Some(5)) {
    ignore(x)
  }

  // tqd_ascii
  println("\n--- tqd_ascii ---")
  for x in @tqdmoon.tqdm(
    [1, 2, 3, 4, 5].iter(),
    total=Some(5),
    style=@tqdmoon.tqd_ascii,
  ) {
    ignore(x)
  }

  // tqd_moon
  println("\n--- tqd_moon ---")
  for x in @tqdmoon.tqdm(
    [1, 2, 3, 4, 5].iter(),
    total=Some(5),
    style=@tqdmoon.tqd_moon,
  ) {
    ignore(x)
  }

  // tqd_google (链式调用)
  println("\n--- tqd_google ---")
  for x in @tqdmoon.tqdm([1, 2, 3, 4, 5].iter(), total=Some(5))
    .set_style(@tqdmoon.tqd_google) {
    ignore(x)
  }

  // 降级模式（无总数）
  println("\n--- 降级模式 ---")
  for x in @tqdmoon.tqdm([10, 20, 30].iter()) {
    ignore(x)
  }
}