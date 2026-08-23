---
name: project-showcase
description: Build a beautiful introduction/showcase website for the current project repository in the user's chosen visual style (Apple minimal, tech futuristic, cyberpunk, gaming, glassmorphism, terminal hacker, etc). Use when the user wants to create a project intro site, landing page, showcase website, or GitHub Pages site for a repo — trigger words include "项目介绍网站", "showcase site", "landing page", "项目主页", "介绍页", "GitHub Pages".
---

# Project Showcase — 项目介绍网站生成器

为当前项目仓库快速生成一个风格化的介绍网站。默认产出**零依赖的单文件 HTML**，可直接部署到 GitHub Pages。

## 工作流程

严格按以下 5 个阶段执行，不要跳步。

### 阶段 1：分析仓库

运行分析脚本收集项目信息：

```bash
bash scripts/analyze-repo.sh
```

脚本会输出：项目名、描述、语言构成、README 摘要、包管理器信息、截图/资源目录等。

然后补充阅读（脚本结果不够时才做）：
- `README.md` 的完整内容（提取：一句话简介、核心特性列表、安装方式、使用示例）
- 仓库中的截图、logo、demo GIF（记录相对路径，网站可直接引用）
- `CHANGELOG.md` / `LICENSE`（如存在，用于 footer 和版本展示）

**产出**：一份项目信息摘要（名称、tagline、3-6 个核心特性、安装命令、截图清单、仓库链接、license）。

### 阶段 2：选择风格

向用户展示风格菜单（用 question 工具或多选列表），每个风格附一句话气质描述：

| 风格 | 文件 | 一句话气质 |
|------|------|-----------|
| Apple 官网风 | `styles/apple-minimal.md` | 大留白、超大标题、滚动叙事、产品特写 |
| 极简清爽风 | `styles/minimal-clean.md` | 干净、克制、内容优先、无干扰 |
| 科技未来风 | `styles/tech-futuristic.md` | 深色、网格光效、数据感、精密仪器感 |
| 赛博霓虹风 | `styles/cyberpunk-neon.md` | 炫酷、霓虹发光、故障艺术、强视觉冲击 |
| 游戏街机风 | `styles/gaming-arcade.md` | 像素风、游戏 UI、趣味动效、活力四射 |
| 玻璃拟态风 | `styles/glassmorphism.md` | 毛玻璃、渐变光斑、轻盈通透、现代感 |
| 粗野主义风 | `styles/brutalist.md` | 硬边框、高对比、反常规、个性张扬 |
| 终端黑客风 | `styles/terminal-hacker.md` | 等宽字体、命令行界面、绿字黑底、极客范 |

选择规则：
1. 用户明确指定风格 → 直接使用对应风格文件
2. 用户说"帮我推荐" → 根据项目类型推荐 2-3 个（如：CLI 工具推荐 terminal-hacker；UI 库推荐 glassmorphism 或 minimal-clean；游戏项目推荐 gaming-arcade）
3. 用户犹豫 → 展示完整菜单让用户选

**选定后，必须完整阅读对应的 `styles/<name>.md` 风格文件再进入下一阶段。**

### 阶段 3：生成网站

在仓库中创建 `site/` 目录（若用户指定了其他目录则遵从），生成 `site/index.html`。

**默认形态：单文件 HTML**
- 所有 CSS 内联在 `<style>`，所有 JS 内联在 `<script>`，零外部依赖
- 图片直接引用仓库内相对路径（如 `../assets/screenshot.png`）或占位图
- 响应式设计：桌面 / 平板 / 手机三档必须都正常
- 无障碍：语义化标签、alt 属性、对比度达标

**页面结构**（按项目实际情况取舍，没有的内容跳过，不要编造）：
1. **Hero**：项目名 + 一句话 tagline + 主 CTA（GitHub 链接 / 快速开始）
2. **特性展示**：3-6 个核心特性，图标 + 标题 + 描述
3. **视觉展示**：截图 / demo / 代码示例（有截图才放，无截图用代码块）
4. **快速开始**：安装命令（带复制按钮）、最小使用示例
5. **FAQ / 高级用法**（可选）
6. **Footer**：License、作者、仓库链接、版权年份

**内容铁律**：
- 所有文案必须来自仓库真实信息（README、代码、配置），**禁止编造**功能、数据、star 数
- 安装命令从 package.json / pyproject / Makefile 等真实配置中提取
- 项目没有的功能不要写"coming soon"占位

**技术铁律**：
- 不引入任何构建步骤、npm 依赖、外部 CDN（除非用户明确要求）
- 动效用纯 CSS（transition/animation/scroll-driven）+ 少量原生 JS
- 单文件控制在 150KB 以内
- 字体优先系统字体栈；风格文件指定了 Google Fonts 时可用 `<link>` 引入

若用户要求更重的方案（多页面、框架、博客等），可升级为 Astro 静态站，但必须先和用户确认。

### 阶段 4：本地预览与验证

生成后必须验证：

```bash
# 启动本地预览（任选其一）
python3 -m http.server 8000 --directory site
```

然后逐项检查：
- [ ] 桌面端（1280px+）布局正常，无溢出、无错位
- [ ] 移动端（375px）布局正常，导航可用
- [ ] 所有链接可点击且指向正确（仓库链接、锚点）
- [ ] 图片正常加载（引用仓库图片时确认相对路径）
- [ ] 动效流畅，无布局抖动（CLS）
- [ ] 深色/浅色模式表现符合所选风格设定

发现问题时修复后重新检查，**不要把未验证的网站交给用户**。

### 阶段 5：部署（用户要求时才执行）

三种方式，按用户环境选择：

**A. GitHub Pages（最常用）**
```bash
# 方式 1：site 目录直接作为 Pages 源
git subtree push --prefix site origin gh-pages

# 方式 2：GitHub Actions（推荐，写入 .github/workflows/pages.yml）
```
提示用户到仓库 Settings → Pages → 选择分支启用。

**B. `/docs` 目录**：把 `site/` 内容复制到 `docs/`，GitHub Pages 直接支持，无需额外分支。

**C. 本地打开**：直接双击 `site/index.html` 或发给用户文件路径。

部署前提醒用户：如果网站引用了 `../assets/` 等仓库外部路径，部署时需把资源复制进 `site/` 目录。

## 目录结构

```
project-showcase/
├── SKILL.md              # 本文件：主流程
├── styles/               # 风格库（按需加载，每次只用一个）
│   ├── apple-minimal.md
│   ├── minimal-clean.md
│   ├── tech-futuristic.md
│   ├── cyberpunk-neon.md
│   ├── gaming-arcade.md
│   ├── glassmorphism.md
│   ├── brutalist.md
│   └── terminal-hacker.md
├── scripts/
│   └── analyze-repo.sh   # 仓库信息收集脚本
└── templates/
    └── base.html         # 单文件 HTML 骨架（含复制按钮等通用 JS）
```

## 扩展风格

用户想要列表中没有的风格时：
1. 询问用户参考对象（如"像 Stripe 官网那样"）
2. 新建 `styles/<name>.md`，按现有风格文件的格式编写（设计 token、排版、布局、动效、Do/Don't）
3. 在本文件的风格菜单表中登记新风格
