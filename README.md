# project-showcase

一个 AI agent skill：为任意代码仓库快速生成风格化的项目介绍网站。

在项目仓库里引入这个 skill，说一句"给这个项目建个介绍网站"，agent 就会分析仓库、让你挑选视觉风格、生成零依赖的单文件 HTML，并可直接部署到 GitHub Pages。

## 内置 8 种风格

| 风格 | 气质 | 适合项目 |
|------|------|---------|
| Apple 官网风 | 大留白、超大标题、滚动叙事 | 硬件/产品类、设计工具 |
| 极简清爽风 | 干净克制、内容优先 | 库、框架、效率工具 |
| 科技未来风 | 深色精密、数据感 | 基础设施、性能工具、AI |
| 赛博霓虹风 | 霓虹发光、故障艺术、炫酷 | 想要强视觉冲击的项目 |
| 游戏街机风 | 像素风、游戏 UI、趣味 | 游戏项目、娱乐应用 |
| 玻璃拟态风 | 毛玻璃、渐变光斑、轻盈 | 设计系统、桌面/移动应用 |
| 粗野主义风 | 硬边框、高对比、反常规 | 创意工具、个性品牌 |
| 终端黑客风 | 等宽字体、命令行隐喻 | CLI 工具、开发库 |

风格库可扩展：新增一个 `styles/<name>.md` 并在 SKILL.md 菜单登记即可。

## 安装

### Claude Code

```bash
# 克隆到项目（随仓库分发）
git clone https://github.com/wajuejinajia/project-showcase .claude/skills/project-showcase

# 或全局安装
git clone https://github.com/wajuejinajia/project-showcase ~/.claude/skills/project-showcase
```

### opencode

```bash
git clone https://github.com/wajuejinajia/project-showcase .opencode/skills/project-showcase
```

### 其他兼容 SKILL.md 的 agent

把整个目录放进 agent 的 skills 搜索路径即可（标准 Agent Skills 格式）。

## 使用

在项目仓库中启动 agent，然后：

```
> 给这个项目搭一个介绍网站，用科技未来风
> 帮我推荐一个风格，做个项目主页
> 建个介绍网站，风格像 Apple 官网那样，部署到 GitHub Pages
```

## 工作流程

1. **分析仓库** — `scripts/analyze-repo.sh` 收集项目名、描述、语言、README、截图
2. **选择风格** — 展示风格菜单，或根据项目类型推荐
3. **生成网站** — 零依赖单文件 `site/index.html`，内容全部来自仓库真实信息
4. **本地验证** — 启动预览，检查桌面/移动端布局与交互
5. **部署**（可选）— GitHub Pages / `/docs` 目录 / 直接本地打开

## 设计原则

- **零依赖**：默认单文件 HTML，无构建步骤、无 npm、无 CDN
- **不编造**：所有文案来自仓库真实信息，禁止虚构功能和数据
- **可验证**：生成后必须本地预览检查，不交付未验证的网站
- **可扩展**：风格即文件，照格式新增即可

## License

MIT
