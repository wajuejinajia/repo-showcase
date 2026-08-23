# 风格：赛博霓虹风（cyberpunk-neon）

参考对象：赛博朋克 2077 官网、synthwave 美学。炫酷、霓虹发光、强视觉冲击，适合想"炸场"的项目。

## 设计 Token

```css
:root {
  --bg: #0d0221;
  --bg-alt: #1a0533;
  --text: #f0e6ff;
  --text-secondary: #a08fc0;
  --neon-pink: #ff2a6d;
  --neon-cyan: #05d9e8;
  --neon-purple: #b537f2;
  --neon-yellow: #f9f002;
  --radius: 4px;
  --font: "Orbitron", "Rajdhani", sans-serif;      /* 标题 */
  --font-body: "Rajdhani", "PingFang SC", sans-serif;
  --font-mono: "Share Tech Mono", ui-monospace, monospace;
}
```

- Google Fonts 允许引入（本风格必须）
- 霓虹色 2-3 个：粉 + 青为主，紫/黄点缀，禁止超过 3 个
- 文字发光：`text-shadow: 0 0 10px currentColor, 0 0 40px currentColor`

## 排版

- Hero 标题：`clamp(48px, 9vw, 110px)`，全大写，font-weight 800，letter-spacing `0.05em`
- 标题用霓虹青发光，可加 glitch 效果（见动效）
- 正文：18px / 1.6，浅紫白色
- 斜切角是本风格签名：按钮和卡片用 `clip-path: polygon(...)` 做切角，不用圆角

## 布局

- 背景：深紫底 + 网格地平线（CSS 渐变透视网格，底部 1/4 处）+ 扫描线覆盖层（`repeating-linear-gradient` 2px 透明度 0.03）
- Hero 可放渐变太阳（粉→紫圆形渐变）剪影
- 特性区：切角边框卡片，边框 1px 霓虹青 + 内发光，hover 时边框变粉
- 分区之间用霓虹色斜线分隔

## 动效（炫，但有节制）

- Hero 标题 glitch：每 5-8 秒触发一次 0.3s 的 RGB 错位抖动（clip-path + 双色 text-shadow），不要常驻
- 扫描线缓慢下移（8s 循环）
- 卡片 hover：边框霓虹切换 + 发光增强
- 按钮 hover：填充色扫过（transform scaleX 0.3s）
- 禁止：全屏常驻闪烁（无障碍风险）、超过 3 个元素同时动

## 组件规范

- 主按钮：切角、透明底、1px 霓虹青边框、青色发光文字，hover 填充霓虹青黑字
- 导航：透明 sticky，等宽字体链接，hover 变霓虹粉 + 下划线扫入
- 代码块：黑底 `#05010d` + 霓虹绿字 `#0aff9d` + 顶部标签 `// install`
- 徽章：切角小标签，霓虹黄底黑字（用于 "NEW" / 版本号）

## Do / Don't

- ✅ 深底亮字对比拉满，霓虹只给关键元素
- ✅ 用等宽字体做装饰性文字（坐标、版本号、`SYS.READY` 之类）
- ❌ 不要把发光用在正文（可读性差）
- ❌ 不要红绿搭配（色盲不友好），不要超过 3 种霓虹色
