# 风格：终端黑客风（terminal-hacker）

参考对象：cool-retro-term、hacker typer、经典 CLI 工具官网。等宽字体、命令行界面、绿字黑底、极客范。特别适合 CLI 工具、开发库。

## 设计 Token

```css
:root {
  --bg: #0a0e0a;
  --bg-alt: #050805;
  --surface: #0d120d;
  --text: #00ff41;        /* 经典终端绿 */
  --text-dim: #00b32d;
  --text-secondary: #3fae5a;
  --warn: #ffb000;        /* 琥珀色警告 */
  --err: #ff3e3e;
  --border: 1px solid #00ff4133;
  --font: "JetBrains Mono", "Fira Code", ui-monospace, monospace;
}
```

- 全站唯一字体：等宽字体，包括标题
- 绿色为主，琥珀色做强调/警告，禁止蓝色紫色等"现代"色
- CRT 质感：扫描线覆盖层 + 轻微文字闪烁（可选，默认关）

## 排版

- Hero "标题"其实是命令提示符：
  ```
  $ whoami
  > awesome-tool — 一句话简介
  $ ./install.sh --now
  ```
- 标题字号 `clamp(20px, 3.5vw, 32px)`，行高 1.8（终端行距）
- 所有列表用 `$`、`>`、`[x]`、`[ ]` 做项目符号
- 正文 15-16px / 1.8，颜色 --text-secondary（纯绿正文刺眼）

## 布局

- 整页是一个"终端会话"的隐喻：每个分区是一个命令的输出
- 分区标题格式：`┌── [SECTION 01] FEATURES ──┐` 或 `# features`
- 特性区用 ASCII 风格表格或对齐的键值对：
  ```
  [✓] blazing fast     — 10x faster than X
  [✓] zero config      — works out of the box
  [✓] cross platform   — macOS / Linux / Windows
  ```
- 导航：顶部状态栏，格式 `awesome-tool v2.1.0 | [features] [install] [docs] [github]`
- 最大宽度 `880px`（终端不会太宽）

## 动效（打字机）

- Hero 打字机效果：逐字输出命令和结果，带光标闪烁（`▊` 0.8s steps(2) 循环），~30 行 JS
- 滚动淡入可选，但更贴合风格的是"逐行打印"（IntersectionObserver + 逐行显示）
- 光标 hover 链接时反色（绿底黑字）
- 禁止：transform 动画、弹性缓动、任何"圆润"的动效

## 组件规范

- 主按钮：`[ 安装 ]` 方括号样式或绿边框黑底绿字，hover 反色
- 代码块：--bg-alt 底 + 绿字 + `$` 前缀 + 右上角 `[COPY]` 按钮，点击变 `[OK]`
- 徽章：`[STABLE]`、`[v2.1.0]`、`[MIT]` 方括号文本
- 分隔线：ASCII 风格 `────────` 或 `- - - - -`
- 彩蛋：页面标题 `<title>` 加闪烁效果（`document.title` 交替）

## Do / Don't

- ✅ 保持"一切皆文本"的纯粹感，图片要少
- ✅ ASCII art logo（用 figlet 风格生成项目名的字符画）放 Hero
- ❌ 不要引入非等宽字体，哪怕一个字
- ❌ 不要大面积纯绿正文（刺眼），用 --text-secondary
- ❌ 不要真实 CRT 弧形扭曲滤镜（性能差），扫描线足够
