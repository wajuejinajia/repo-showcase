# 风格：极简清爽风（minimal-clean）

参考对象：Linear 早期官网、Notion 官网。干净、克制、内容优先，让项目本身说话。

## 设计 Token

```css
:root {
  --bg: #fafafa;
  --surface: #ffffff;
  --text: #18181b;
  --text-secondary: #71717a;
  --border: #e4e4e7;
  --accent: #18181b;
  --radius: 10px;
  --font: "Inter", -apple-system, "Segoe UI", "PingFang SC", sans-serif;
  --font-mono: "JetBrains Mono", ui-monospace, monospace;
}
```

- 中性色为主，强调色最多一个且低饱和（可从项目 logo 取色）
- 大量使用细边框 `1px solid var(--border)` 分隔，而非阴影
- 阴影只允许极轻的一档：`0 1px 2px rgba(0,0,0,0.04)`

## 排版

- Hero 标题：`clamp(36px, 6vw, 64px)`，font-weight 650，letter-spacing `-0.03em`
- 正文：15-16px / 1.6，最大宽度 `680px`
- 层次靠字重（400/500/650）和灰度，不靠颜色

## 布局

- 最大内容宽度 `1120px` 居中，两侧留白充足
- 特性区用网格卡片：白底、细边框、radius 10px、hover 时边框加深
- 分区间距 `96px`，用细分隔线或留白过渡
- 导航：白色 sticky 顶栏 + 底部细边框，logo 左、链接右

## 动效（几乎无）

- 页面加载：内容直接呈现，最多一个 0.3s 的整体淡入
- hover：边框颜色或背景 0.15s 过渡
- 禁止：滚动动画、视差、任何吸睛动效

## 组件规范

- 主按钮：深色实底（`--accent`）白字，radius 8px，padding `10px 20px`
- 次按钮：白底细边框
- 代码块：`--surface` 底 + 细边框 + radius 8px，右上角复制按钮
- 徽章（badge）：小圆角、浅灰底、12px 字号，用于版本号、license

## Do / Don't

- ✅ 信息密度可以高，但视觉噪音必须低
- ✅ 截图放进带细边框的"浏览器窗口"容器里展示
- ❌ 不要大色块、不要渐变、不要 emoji 当图标（用线性图标）
- ❌ 不要超过一种强调色
