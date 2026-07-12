# tqdmoon

> 一个纯函数式、零额外开销、基于迭代器包装的 MoonBit 进度条库，灵感来源于 Python 的 `tqdm`。

[![GitHub release](https://img.shields.io/github/v/release/GeneWang1226/tqdmoon)](https://github.com/GeneWang1226/tqdmoon/releases)
[![Build Status](https://img.shields.io/github/actions/workflow/status/GeneWang1226/tqdmoon/ci.yml?label=build)](https://github.com/GeneWang1226/tqdmoon/actions/workflows/ci.yml)
[![License](https://img.shields.io/github/license/GeneWang1226/tqdmoon)](../LICENSE)

**[English README](../README.md)**

- **Mooncakes**: <https://mooncakes.io/docs/GeneWang1226/tqdmoon>
- **GitHub**: <https://github.com/GeneWang1226/tqdmoon>

## 特性

- **迭代器包装** — 只需传入一个 `Iter[T]`，计数、渲染、终端刷新全部自动完成
- **零手动干预** — 无需手动调用 `update()` 或 `render()`
- **自动收尾** — 迭代器耗尽时自动打印换行，后续输出不会覆盖进度条
- **降级模式** — 无总数时自动切换为计量器模式，显示已用时间和处理速率
- **描述与单位** — 可选的 `desc` 前缀和可自定义的 `unit`（默认 `"items"`）
- **多皮肤系统** — 4 种内置预设 + 完全可自定义的 `BarStyle`
- **零外部依赖** — 仅使用 MoonBit 核心原语

## 导入

### 使用 `moon add`（推荐）

```bash
# 添加最新版本
moon add GeneWang1226/tqdmoon

# 或添加指定版本
moon add GeneWang1226/tqdmoon@0.2.0
```

### 手动导入

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
  let items = (0).until(9000000)
  for _ in @tqdmoon.tqdm(items, total=Some(9000000)) {}
}
```

输出：`|████████████████████| 100% 9000000/9000000 [00:00<00:00, 21801311.5 items/s]`

### 预编译 CLI

安装原生二进制文件，然后像管道监控器一样使用它：

#### 一行命令安装

```bash
curl -fsSL https://raw.githubusercontent.com/GeneWang1226/tqdmoon/main/scripts/install.sh | sh
```

然后可以在任何地方运行：

```bash
seq 1 100000 | tqdmoon
```

<img src="../assets/tqdmoon_demo.gif" width="50%" align="left" alt="tqdmoon demo" />

<br />

安装到自定义前缀（例如 `~/.local`）：

```bash
curl -fsSL https://raw.githubusercontent.com/GeneWang1226/tqdmoon/main/scripts/install.sh | INSTALL_DIR=$HOME/.local sh
```

安装指定版本：

```bash
curl -fsSL https://raw.githubusercontent.com/GeneWang1226/tqdmoon/main/scripts/install.sh | VERSION=v0.2.0 sh
```

> **开发构建：** 安装脚本从 GitHub Releases 下载。如果还没有 Release，请从最新的成功 GitHub Actions 运行中下载 artifact。

#### CLI 选项

```bash
seq 1 100000 | tqdmoon --style moon
seq 1 100000 | tqdmoon -s google -d Download -u bytes
```

可用参数：

| 参数 | 说明 | 默认值 |
| --- | --- | --- |
| `-s, --style` | 进度条样式：`classic`、`ascii`、`moon`、`google` | `classic` |
| `-d, --desc` | 显示在进度条前的描述前缀 | `Piping` |
| `-u, --unit` | 计数和速率的单位标签 | `lines` |

#### 通过 .deb 安装（Ubuntu/Debian）

```bash
curl -fsSL -o tqdmoon.deb https://github.com/GeneWang1226/tqdmoon/releases/latest/download/tqdmoon_amd64.deb
sudo dpkg -i tqdmoon.deb
```

该包将原生二进制文件安装到 `/usr/local/bin/tqdmoon`，将 WebAssembly 字节码安装到 `/usr/local/lib/tqdmoon.wasm`。

### WebAssembly 演示

直接在浏览器中运行编译好的 `tqdmoon.wasm`。

首先从 `tqdmoon/` 模块目录构建 wasm 目标：

```bash
cd tqdmoon
moon build --target wasm --release
cp _build/wasm/release/build/cmd/wasm/wasm.wasm ../web/tqdmoon.wasm
```

然后启动 `web/` 目录服务：

```bash
cd ../web
python -m http.server 8000
```

打开 <http://localhost:8000>。页面会加载 WebAssembly 模块，为 stdout 和计时器提供最小 WASI shim，并实时渲染进度条。

复制 `.wasm` 文件后，你也可以将 `web/` 目录部署到任何静态托管服务（GitHub Pages、Vercel 等）。

### 降级模式（无总数）

```moonbit
for x in @tqdmoon.tqdm([10, 20, 30].iter()) {
  ignore(x)
}
```

输出：`3 items [00:00, 405405.4 items/s]`

### 描述与单位

```moonbit
// 描述前缀 + 自定义单位
for x in @tqdmoon.tqdm(items, total=Some(100), desc="Loading", unit="B") {
  ignore(x)
}
```

输出：`Loading: |██████████          | 50% 50/100 [00:01<00:01, 50 B/s]`

```moonbit
// 链式 setter
@tqdmoon.tqdm(items, total=Some(10))
  .set_desc("Processing")
  .set_unit("it")
```

## 皮肤

四种内置预设：

```moonbit
// tqdmoon_classic — 默认，实心方块
@tqdmoon.tqdm(items, total=Some(5), style=@tqdmoon.tqdmoon_classic)

// tqdmoon_ascii — ASCII 字符
@tqdmoon.tqdm(items, total=Some(5), style=@tqdmoon.tqdmoon_ascii)

// tqdmoon_moon — 月相图标
@tqdmoon.tqdm(items, total=Some(5), style=@tqdmoon.tqdmoon_moon)

// tqdmoon_google — 趣味梗，链式调用
@tqdmoon.tqdm(items, total=Some(5)).set_style(@tqdmoon.tqdmoon_google)
```

效果预览：

| 皮肤 | 示例 |
| --- | --- |
| `tqdmoon_classic` | `\|████████░░░░░░░░░░░░\|  50% 5/10` |
| `tqdmoon_ascii` | `[=====>               ]  25%` |
| `tqdmoon_moon` | `\|🌕🌕🌕🌕🌕🌑🌑🌑🌑🌑\|  50%` |
| `tqdmoon_google` | `tqdmooooooooooooooooooooon  100%` |

### 自定义皮肤

通过构造 `BarStyle` 自定义外观：

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
  total~    : Int?    = None,
  style~    : BarStyle = tqdmoon_classic,
  desc~     : String  = "",
  unit~     : String  = "items",
  disabled~ : Bool    = false,
) -> Tqdm[T]

// 链式 setter（每个都返回新实例）
pub fn[T] Tqdm::set_style(self : Tqdm[T], style : BarStyle) -> Tqdm[T]
pub fn[T] Tqdm::set_desc(self : Tqdm[T], desc : String) -> Tqdm[T]
pub fn[T] Tqdm::set_unit(self : Tqdm[T], unit : String) -> Tqdm[T]
pub fn[T] Tqdm::set_disabled(self : Tqdm[T], disabled : Bool) -> Tqdm[T]
```

### BarStyle

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `left` | `String` | 进度条左边界 |
| `right` | `String` | 进度条右边界 |
| `fill` | `String` | 已填充字符 |
| `head` | `String` | 进度条头部（前缀模式下为前缀） |
| `tail` | `String` | 进度条尾部（前缀模式下为后缀） |
| `empty` | `String` | 未填充字符 |
| `width` | `Int` | 进度条总宽度 |
| `is_prefix` | `Bool` | 是否为前缀模式（如 `tqdmoon_google`） |

## 测试

在 `tqdmoon/` 包目录下执行：

```bash
cd tqdmoon

# 运行单元测试（72 个用例）
moon test

# 运行皮肤展示示例
moon run cmd/main
```

## 目录结构

```
tqdmoon/
├── moon.pkg              # 包依赖声明
├── tqdmoon.mbt           # 核心库代码
├── tqdmoon_test.mbt      # 黑盒测试（公开 API）
├── tqdmoon_wbtest.mbt    # 白盒测试（内部函数）
└── cmd/main/
    ├── moon.pkg
    └── main.mbt          # 皮肤对比示例
```
