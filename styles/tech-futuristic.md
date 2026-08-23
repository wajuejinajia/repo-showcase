# 风格：科技未来风（tech-futuristic）

参考对象：Vercel、Stripe、SpaceX 官网。深色、精密、数据感，像一台高端仪器。

## 设计 Token

```css
:root {
  --bg: #0a0a0f;
  --bg-alt: #101018;
  --surface: rgba(255,255,255,0.03);
  --border: rgba(255,255,255,0.08);
  --text: #ededf2;
  --text-secondary: #9b9ba6;
  --accent: #5b8cff;
  --accent-glow: rgba(91,140,255,0.35);
  --radius: 12px;
  --font: "Inter", -apple-system, "PingFang SC", sans-serif;
  --font-mono: "JetBrains Mono", ui-monospace, monospace;
}
```

- 深色底 + 单一冷色强调（蓝/青/紫任选其一，可从项目 logo 取）
- 边框用半透明白，营造"精密面板"感
- 强调色可带轻微 glow（box-shadow 0 0 40px var(--accent-glow)），但只用于焦点元素

## 排版

- Hero 标题：`clamp(40px, 7vw, 80px)`，font-weight 600，letter-spacing `-0.02em`
- 可用渐变文字：`background: linear-gradient(180deg, #fff, #9b9ba6); -webkit-background-clip: text`
- 数字与指标用等宽字体（--font-mono），营造数据感
- 正文：16px / 1.6，color `--text-secondary`

## 布局

- 网格背景：body 上叠一层 CSS 渐变网格线（`rgba(255,255,255,0.04)` 1px 线，间距 64px），顶部可加径向光晕
- Hero 下方放"指标条"：3-4 个关键数字（性能、体积、star 数）横排，等宽字体
- 特性区：深色面板卡片（--surface + --border + backdrop-blur），2×3 网格
- 代码块：终端风格，顶部三个圆点，语法高亮用冷色系

## 动效（精密感）

- 滚动淡入 + 轻微上移，0.6s cubic-bezier(0.16, 1, 0.3, 1)
- 卡片 hover：边框亮起（border-color → accent 半透明）+ 轻微上移 2px
- Hero 标题可逐词淡入；背景光晕可极缓慢地呼吸（8s 循环）
- 可选：数字滚动计数动画（IntersectionObserver 触发一次）
- 禁止：弹跳、旋转、彩虹渐变

## 组件规范

- 主按钮：`--accent` 实底 + glow 阴影，radius 8px
- 次按钮：透明底 + --border 边框 + 白字
- 导航：sticky + backdrop-blur(12px) + 底部细边框
- 徽章：等宽字体 + 半透明底 + 细边框

## Do / Don't

- ✅ 用真实数据说话（benchmark、体积、速度）
- ✅ 大面积深色 + 局部高光，对比要拉开
- ❌ 不要纯黑 `#000` 大底（用 `#0a0a0f` 这类带蓝的深色）
- ❌ 不要超过一种强调色；glow 不要到处都是
