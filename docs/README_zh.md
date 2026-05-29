# moontqdm

> 纯函数式、零额外开销、基于迭代器包装的 MoonBit 进度条库，灵感来源于 Python 的 `tqdm`。

## 特性

- **迭代器包装** — 只需把 `Iter[T]` 丢进去，计数、渲染、终端刷新全部自动完成
- **零手动干预** — 无需手动调用 `update()` 或 `render()`
- **自动收尾** — 迭代器耗尽时自动打印换行，后续输出不会覆盖进度条
- **降级模式** — 无总数时自动切换为计量器模式，显示已用时间和处理速率
- **多皮肤系统** — 4 种预设皮肤 + 支持自定义 `BarStyle`
- **零外部依赖** — 仅使用 MoonBit 核心原语

## 导入

在你的 `moon.pkg` 中添加：

```moonbit
import {
  "GeneWang1226/tqdmoon",
}
```

## 快速上手

### 基本用法（带总数）

```moonbit
fn main {
  let items = [1, 2, 3, 4, 5].iter()
  for x in @tqdmoon.tqdm(items, total=Some(5)) {
    ignore(x)
  }
}
```

输出：`|████████████████████| 100% 5/5 [00:00<00:00, 30138.6 items/s]`

### 降级模式（无总数）

```moonbit
for x in @tqdmoon.tqdm([10, 20, 30].iter()) {
  ignore(x)
}
```

输出：`3 items [00:00, 405405.4 items/s]`

## 皮肤切换

四种预设皮肤：

```moonbit
// tqd_classic — 默认，实心方块
@tqdmoon.tqdm(items, total=Some(5), style=@tqdmoon.tqd_classic)

// tqd_ascii — ASCII 字符
@tqdmoon.tqdm(items, total=Some(5), style=@tqdmoon.tqd_ascii)

// tqd_moon — 月相图标
@tqdmoon.tqdm(items, total=Some(5), style=@tqdmoon.tqd_moon)

// tqd_google — 趣味梗，链式调用
@tqdmoon.tqdm(items, total=Some(5)).set_style(@tqdmoon.tqd_google)
```

皮肤效果：

| 皮肤 | 示例 |
|---|---|
| `tqd_classic` | `\|████████░░░░░░░░░░░░\|  50% 5/10` |
| `tqd_ascii` | `[=====>               ]  25%` |
| `tqd_moon` | `\|🌕🌕🌕🌕🌕🌑🌑🌑🌑🌑\|  50%` |
| `tqd_google` | `tqdooooooooooooom  60%` |

### 自定义皮肤

通过构造 `BarStyle` 结构体自定义外观：

```moonbit
let my_style = @tqdmoon.BarStyle::{
  left: "(",
  right: ")",
  fill: "#",
  head: "",
  tail: "",
  empty: "-",
  width: 30,
  is_prefix: false,
}

for x in @tqdmoon.tqdm(items, total=Some(10), style=my_style) {
  ignore(x)
}
```

## API

```moonbit
// 创建进度条
pub fn[T] tqdm(
  iterable : Iter[T],
  total~   : Option[Int] = None,
  style~   : BarStyle     = tqd_classic,
) -> Tqdm[T]

// 链式切换皮肤（返回新实例）
pub fn[T] Tqdm::set_style(self : Tqdm[T], style : BarStyle) -> Tqdm[T]
```

### BarStyle

| 字段 | 类型 | 说明 |
|---|---|---|
| `left` | `String` | 进度条左边界 |
| `right` | `String` | 进度条右边界 |
| `fill` | `String` | 已填充字符 |
| `head` | `String` | 进度条头部（前缀模式下为前缀） |
| `tail` | `String` | 进度条尾部（前缀模式下为后缀） |
| `empty` | `String` | 未填充字符 |
| `width` | `Int` | 进度条总宽度 |
| `is_prefix` | `Bool` | 是否为前缀模式（如 `tqd_google`） |

## 测试

```bash
# 运行单元测试（25 个用例）
moon test

# 运行示例程序（演示所有皮肤）
moon run cmd/main

# 运行 test 目录下的独立示例
moon run test
```

## 目录结构

```
tqdmoon/
├── moon.pkg              # 包依赖声明
├── tqdmoon.mbt           # 核心库代码
├── tqdmoon_test.mbt      # 黑盒测试（公开 API）
├── tqdmoon_wbtest.mbt    # 白盒测试（内部函数）
├── test/
│   ├── moon.pkg
│   └── main.mbt          # 独立演示程序
└── cmd/main/
    ├── moon.pkg
    └── main.mbt          # 皮肤对比示例
```