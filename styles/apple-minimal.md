# 风格：Apple 官网风（apple-minimal）

参考对象：apple.com 产品页。大留白、超大字号、滚动叙事、克制而高级。

## 设计 Token

```css
:root {
  --bg: #ffffff;
  --bg-alt: #f5f5f7;
  --text: #1d1d1f;
  --text-secondary: #6e6e73;
  --accent: #0071e3;
  --accent-hover: #0077ed;
  --radius: 18px;
  --font: -apple-system, BlinkMacSystemFont, "SF Pro Display", "Helvetica Neue", "PingFang SC", sans-serif;
}
```

- 禁止使用纯黑 `#000` 做正文，用 `#1d1d1f`
- 背景只用白色和 `#f5f5f7` 交替分区
- 强调色只用一个（蓝 `#0071e3`），其余靠字号和字重区分层次

## 排版

- Hero 标题：`clamp(48px, 8vw, 96px)`，font-weight 600，letter-spacing `-0.015em`
- 副标题：`clamp(24px, 3vw, 32px)`，color `var(--text-secondary)`
- 正文：17px / 1.47，最大宽度 `720px` 居中
- 章节标题短促有力（2-5 个词），如"快得飞起。""为速度而生。"

## 布局

- 单列居中叙事，章节之间用 `#f5f5f7` / 白色交替
- 大量留白：章节 padding 至少 `120px 0`
- 特性展示用 2-3 列圆角卡片（radius 18px，背景 `#f5f5f7`，无边框无阴影）
- 截图/产品图占满内容宽度，居中，可加轻微圆角

## 动效（克制）

- 滚动淡入：`opacity 0→1` + `translateY(24px)→0`，duration 0.8s，ease-out，一次性触发
- Hero 元素依次 stagger 进入（延迟 0.1s 递增）
- 按钮 hover：背景色 0.2s 过渡，无位移无阴影
- 禁止：弹跳、旋转、霓虹、视差滥用

## 组件规范

- 主按钮：胶囊形（radius 980px），背景 `--accent`，白字，padding `12px 24px`
- 次按钮：胶囊形，透明背景 + 蓝色文字 + "了解更多 >"
- 导航：半透明毛玻璃 sticky 顶栏，高度 48px，元素极简（logo + 4-5 个链接）
- 代码块：深灰底（`#1d1d1f`）圆角卡片，浅色等宽字

## Do / Don't

- ✅ 每屏只讲一件事，标题 + 一句话 + 一个视觉
- ✅ 数字用超大字号展示（如"快 2 倍"）
- ❌ 不要渐变背景、不要彩色图标堆砌、不要超过两种字体
- ❌ 不要在首屏塞超过一个 CTA
