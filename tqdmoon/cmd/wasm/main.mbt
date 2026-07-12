///|
fn main {
  let items = [1, 2, 3, 4, 5]
  for
    _ in @tqdmoon.tqdm(
      items.iter(),
      total=Some(items.length()),
      desc="Wasm",
      unit="items",
    ).iter() {
    ()
  }
}
