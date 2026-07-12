///|
fn parse_style(name : String) -> @tqdmoon.BarStyle {
  match name {
    "ascii" => @tqdmoon.tqdmoon_ascii
    "moon" => @tqdmoon.tqdmoon_moon
    "google" => @tqdmoon.tqdmoon_google
    _ => @tqdmoon.tqdmoon_classic
  }
}

///|
fn build_command() -> @argparse.Command {
  @argparse.Command("tqdmoon", about="A pipe-friendly progress bar", options=[
    @argparse.OptionArg(
      "style",
      short='s',
      about="Bar style: classic, ascii, moon, google",
    ),
    @argparse.OptionArg(
      "desc",
      short='d',
      about="Description prefix shown before the bar",
    ),
    @argparse.OptionArg(
      "unit",
      short='u',
      about="Unit label for counts and rates",
    ),
  ])
}

///|
async fn main {
  let args = @env.args()
  let argv = if args.length() > 0 { args[1:] } else { args }
  let matches = @argparse.parse(build_command(), argv~)
  let values = matches.values
  let style_name = match values.get("style") {
    Some([name, ..]) => name
    _ => "classic"
  }
  let desc = match values.get("desc") {
    Some([d, ..]) => d
    _ => "Piping"
  }
  let unit = match values.get("unit") {
    Some([u, ..]) => u
    _ => "lines"
  }
  let style = parse_style(style_name)
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
      style~,
      desc~,
      unit~,
    ).iter() {
    ()
  }
}
