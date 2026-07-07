///|
fn main {
  println("--- tqdmoon_classic ---")
  for x in @tqdmoon.tqdm([1, 2, 3, 4, 5].iter(), total=Some(5)) {
    ignore(x)
  }

  println("\n--- tqdmoon_ascii ---")
  for
    x in @tqdmoon.tqdm(
      [1, 2, 3, 4, 5].iter(),
      total=Some(5),
      style=@tqdmoon.tqdmoon_ascii,
    ) {
    ignore(x)
  }

  println("\n--- tqdmoon_style ---")
  for
    x in @tqdmoon.tqdm(
      [1, 2, 3, 4, 5].iter(),
      total=Some(5),
      style=@tqdmoon.tqdmoon_style,
    ) {
    ignore(x)
  }

  println("\n--- tqdmoon_google ---")
  for
    x in @tqdmoon.tqdm([1, 2, 3, 4, 5].iter(), total=Some(5)).set_style(
      @tqdmoon.tqdmoon_google,
    ) {
    ignore(x)
  }

  println("\n--- desc + unit ---")
  for
    x in @tqdmoon.tqdm(
      [1, 2, 3, 4, 5].iter(),
      total=Some(5),
      desc="Loading",
      unit="it",
    ) {
    ignore(x)
  }

  println("\n--- fallback mode ---")
  for x in @tqdmoon.tqdm([10, 20, 30].iter()) {
    ignore(x)
  }
}
