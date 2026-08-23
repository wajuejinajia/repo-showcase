# 风格：游戏街机风（gaming-arcade）

参考对象：itch.io、复古街机、像素游戏官网。像素风、游戏 UI、趣味动效，适合游戏、娱乐类项目。

## 设计 Token

```css
:root {
  --bg: #1a1a2e;
  --bg-alt: #16213e;
  --surface: #0f3460;
  --text: #eaeaea;
  --text-secondary: #a8b2d1;
  --p1: #e94560;   /* 主色：街机红 */
  --p2: #ffd23f;   /* 强调：金币黄 */
  --p3: #3ddc84;   /* 成功：血条绿 */
  --pixel-border: #000000;
  --font-pixel: "Press Start 2P", monospace;   /* 标题/按钮，Google Fonts */
  --font-body: "VT323", "Noto Sans SC", monospace; /* 正文，字号要大（20px+） */
}
```

- Google Fonts 必须引入 Press Start 2P + VT323
- 像素字体只用于标题、按钮、徽章；正文用 VT323 且字号不小于 20px（像素字体小了没法读）
- 中文回退到 Noto Sans SC（像素中文字体太大，不引入）

## 排版

- Hero 标题：Press Start 2P，`clamp(20px, 5vw, 48px)`，line-height 1.6，可双色描边
- 硬阴影文字：`text-shadow: 4px 4px 0 var(--pixel-border)`
- 正文 VT323：22px / 1.5
- 分数/统计用游戏 HUD 样式：`SCORE: 9999`、`LV.1`、`★×3`

## 布局

- 像素边框卡片：`border: 4px solid #000` + `box-shadow: 8px 8px 0 rgba(0,0,0,0.4)`，直角（radius 0）
- 特性区：2-3 列像素卡片，每张卡片顶部一条彩色"血条"装饰
- 截图放进"游戏机屏幕"容器：粗黑边框 + 圆角屏幕 + 底部装饰按钮
- 分区背景在 --bg / --bg-alt 间交替

## 动效（趣味）

- 8-bit 淡入：无缓动、阶梯式（`steps(4)`）出现
- 按钮 hover：整体位移 `translate(-2px,-2px)` + 阴影加深，按下时反向（模拟物理按压）
- 标题可做经典闪烁（`steps(2)` 透明度切换，1s 循环，只允许 hero 用）
- 彩蛋：Konami code（↑↑↓↓←→←→BA）触发彩带或换肤，用 ~15 行原生 JS
- 禁止：平滑缓动动画（破坏像素感）、模糊、渐变阴影

## 组件规范

- 主按钮：Press Start 2P 14px、--p1 红底白字、4px 黑边框、硬阴影、直角
- 次按钮：--p2 黄底黑字
- 导航：像素边框 sticky 条，链接是像素字体"菜单项"，当前项前加 `▶`
- 代码块：黑底 + 绿字（`#3ddc84`）+ 顶部 `>_ TERMINAL` 标签
- 徽章：像素字体 + 黄底，如 `v2.0`、`1P ONLY`

## Do / Don't

- ✅ 全部直角、全部硬阴影、全部高饱和
- ✅ 用游戏化语言包装内容（特性 = "技能树"，安装 = "START GAME"）
- ❌ 不要圆角、不要柔和阴影、不要细字体
- ❌ 像素字体不要用于长段落
