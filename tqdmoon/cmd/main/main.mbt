///|
fn main {
  let items = [1, 2, 3, 4, 5].iter()
  let t = @tqdmoon.tqdm(items, total=Some(5))
  for x in t {
    ignore(x)
  }
}
