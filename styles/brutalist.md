# 风格：粗野主义风（brutalist）

参考对象：Gumroad、Figma 部分营销页、neo-brutalism 潮流。硬边框、高对比、反常规、个性张扬。

## 设计 Token

```css
:root {
  --bg: #fffdf5;
  --surface: #ffffff;
  --text: #000000;
  --accent: #ff6b35;    /* 高饱和主色，可换 */
  --accent-2: #004aad;
  --border: 3px solid #000;
  --shadow: 6px 6px 0 #000;
  --radius: 0;
  --font: "Archivo Black", "Space Grotesk", sans-serif;  /* 标题 */
  --font-body: "Space Grotesk", "PingFang SC", sans-serif;
}
```

- Google Fonts 允许引入（Archivo Black / Space Grotesk）
- 高饱和色块 + 纯黑粗边框 + 硬偏移阴影是本风格三要素
- 直角，禁止一切圆角和柔和阴影

## 排版

- Hero 标题：`clamp(40px, 8vw, 90px)`，font-weight 900，全大写，line-height 1.0
- 关键词可用色块高亮（黑字 + --accent 背景条）
- 正文：16-18px / 1.5，字重 500
- 允许文字轻微旋转（-2deg ~ 2deg）制造手工感，每屏最多 1 处

## 布局

- 卡片：白底 + `--border` 黑边框 + `--shadow` 硬阴影，hover 时卡片位移到阴影位置（translate(6px,6px) + 阴影消失）
- 特性区：不等宽网格（故意打破对称），卡片背景轮换 白/--accent/--accent-2
- 分区之间用粗黑横线或色块条分隔
- 允许元素重叠（贴纸感）：徽章旋转叠在卡片角上

## 动效（干脆）

- 所有过渡 0.1-0.15s，无缓动曲线（或 steps）
- hover 位移是主要动效：按钮和卡片都"按下去"
- marquee 跑马灯横幅（黑底白字循环滚动）可用在 Hero 下方，纯 CSS 动画
- 禁止：淡入淡出滚动动画（太温柔）、模糊、渐变

## 组件规范

- 主按钮：--accent 底 + 黑边框 + 硬阴影 + 全大写粗体字
- 次按钮：白底黑边框
- 导航：白底 + 底部 3px 黑边框，链接 hover 时背景变 --accent
- 代码块：黑底白字 + 4px 白色虚线内边框，或黄底黑字（便利贴感）
- 徽章：色块 + 黑边框 + 大写，可旋转 -5deg

## Do / Don't

- ✅ 大胆撞色（橙×蓝、粉×绿），但每屏主色块不超过 2 个
- ✅ 拥抱"未完成感"：下划线、高亮条、手写批注（可用 SVG）
- ❌ 不要渐变、不要圆角、不要轻柔阴影
- ❌ 不要把正文放在高饱和色块上（可读性）
