///|
async fn main {
  let lines = []
  try {
    while true {
      match @stdio.stdin.read_until("\n") {
        Some(line) => lines.push(line)
        None => break
      }
    }
  } catch {
    _ => ()
  }
  for
    _ in @tqdmoon.tqdm(
      lines.iter(),
      total=Some(lines.length()),
      desc="Piping",
      unit="lines",
    ).iter() {
    ()
  }
}
