///|
fn main {
  println("=== moontqdm demo ===\n")

  // 1. 基本用法（带总数）
  println("--- tqd_classic ---")
  let t1 = @tqdmoon.tqdm([1, 2, 3, 4, 5].iter(), total=Some(5))
  for x in t1 {
    ignore(x)
  }

  // 2. ASCII 皮肤
  println("\n--- tqd_ascii ---")
  let t2 = @tqdmoon.tqdm(
    [1, 2, 3, 4, 5].iter(),
    total=Some(5),
    style=@tqdmoon.tqd_ascii,
  )
  for x in t2 {
    ignore(x)
  }

  // 3. 月相皮肤
  println("\n--- tqd_moon ---")
  let t3 = @tqdmoon.tqdm(
    [1, 2, 3, 4, 5].iter(),
    total=Some(5),
    style=@tqdmoon.tqd_moon,
  )
  for x in t3 {
    ignore(x)
  }

  // 4. Google 皮肤（链式调用）
  println("\n--- tqd_google (链式调用) ---")
  let t4 = @tqdmoon.tqdm([1, 2, 3, 4, 5].iter(), total=Some(5)).set_style(
    @tqdmoon.tqd_google,
  )
  for x in t4 {
    ignore(x)
  }

  // 5. 降级模式（无总数 → 计量器）
  println("\n--- 降级模式（无总数） ---")
  let t5 = @tqdmoon.tqdm([10, 20, 30, 40, 50].iter())
  for x in t5 {
    ignore(x)
  }

  // 6. 长任务演示
  println("\n--- 长任务演示 ---")
  let long_task = @tqdmoon.tqdm(
    [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].iter(),
    total=Some(10),
  )
  for x in long_task {
    ignore(x)
  }

  println("\n=== demo 结束 ===")
}
