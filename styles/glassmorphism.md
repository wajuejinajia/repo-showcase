# 风格：玻璃拟态风（glassmorphism）

参考对象：macOS Big Sur、Apple Vision Pro 官网。毛玻璃、渐变光斑、轻盈通透。

## 设计 Token

```css
:root {
  --bg: #0f0f1a;                       /* 深色底衬托玻璃 */
  --text: #ffffff;
  --text-secondary: rgba(255,255,255,0.65);
  --glass: rgba(255,255,255,0.08);
  --glass-border: rgba(255,255,255,0.15);
  --accent: #7c6cff;
  --accent-2: #4ecdc4;
  --radius: 20px;
  --font: "Inter", -apple-system, "PingFang SC", sans-serif;
}
```

- 玻璃效果三件套：`background: var(--glass)` + `backdrop-filter: blur(20px)` + 1px 半透明边框
- 背景必须有 2-3 个大号模糊光斑（blob）做衬托，否则玻璃效果不可见
- 强调色允许 2 个（紫 + 青渐变），仅用于光斑和渐变文字

## 排版

- Hero 标题：`clamp(40px, 7vw, 76px)`，font-weight 700，letter-spacing `-0.02em`
- 渐变文字：`linear-gradient(90deg, var(--accent), var(--accent-2))` + background-clip
- 正文：16px / 1.7，--text-secondary
- 玻璃卡片上的文字对比度要额外注意（白字 + 深底光斑）

## 布局

- 背景：深底 + 3 个 `filter: blur(120px)` 的彩色圆形 div（紫/青/粉），固定定位，缓慢漂浮动画（60s 循环）
- 所有内容容器都是玻璃卡片：特性卡、导航栏、代码块、表格
- Hero 居中布局，下方特性区 3 列玻璃卡片
- 截图放在玻璃"相框"卡片内，可加轻微 3D tilt（鼠标跟随，~20 行 JS，可选）

## 动效（轻盈）

- 光斑漂浮：`translate` 缓慢移动 + `scale` 微缩放，60s 无限循环，用 `will-change` 优化
- 滚动淡入：opacity + translateY(20px)，0.7s ease-out
- 卡片 hover：背景透明度 0.08→0.12 + 边框亮起，0.3s
- 导航：玻璃 sticky 条 + blur(20px)
- 禁止：玻璃层叠超过 2 层（性能）、blur 值超过 30px

## 组件规范

- 主按钮：玻璃底 + 渐变描边（border-image 或双层实现）+ 白字
- 次按钮：纯玻璃底白字
- 代码块：深色半透明（rgba(0,0,0,0.4)）+ blur + 等宽字体，保证代码可读性优先
- 徽章：玻璃小胶囊 + 彩色圆点

## Do / Don't

- ✅ 玻璃卡片下面必须有内容或光斑，否则效果失效
- ✅ 提供 `@supports not (backdrop-filter: blur(1px))` 回退（加深卡片背景色）
- ❌ 不要在浅色背景上用白玻璃（看不见）
- ❌ 不要整页全是玻璃（视觉疲劳），正文区可用实底深色卡片
