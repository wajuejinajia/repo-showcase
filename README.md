# repo-showcase

`repo-showcase` is an Agent Skill that turns a code repository into a source-backed, style-led project website. It creates a dependency-free static page by default, suitable for a repository homepage or GitHub Pages.

It is designed for projects that have code and a README but no public introduction site: the agent extracts verifiable project facts, helps choose an appropriate visual system, creates a portable static site, and checks it before handoff.

It can also produce an optional static multi-page site for project documentation, onboarding guides, and runnable or illustrative demos.

## Live demo

Interactive style previewer for all 8 visual systems (switch themes without reload), served via GitHub Pages:

**https://wajuejinajia.github.io/repo-showcase/**

Deep-link a style with a hash or query, for example `#cyberpunk-neon` or `?style=apple-minimal`. Source for the page: [`docs/index.html`](docs/index.html) (also published from the `gh-pages` branch).

## Why this exists

README files serve developers well, but they are rarely a clear project introduction for users, collaborators, or evaluators. Existing AI landing-page generators can turn briefs or README content into pages; this skill is differentiated by working inside the target repository, keeping claims traceable to source, offering distinct visual systems, and producing a self-contained static result.

## Included styles

| Style | Suitable projects |
|---|---|
| Apple minimal | Products and design tools |
| Minimal clean | Libraries and frameworks |
| Tech futuristic | AI, infra, performance tools |
| Cyberpunk neon | High-impact creative work |
| Gaming arcade | Games and playful projects |
| Glassmorphism | Apps and design systems |
| Brutalist | Creative tools and expressive brands |
| Terminal hacker | CLIs and developer tools |

## Install

Clone the folder into the skills directory supported by your agent. Common project-local paths include:

```bash
git clone https://github.com/wajuejinajia/repo-showcase .agents/skills/repo-showcase
git clone https://github.com/wajuejinajia/repo-showcase .claude/skills/repo-showcase
git clone https://github.com/wajuejinajia/repo-showcase .opencode/skills/repo-showcase
```

Other agents can use the same folder whenever they support `SKILL.md`-style skills. The core runtime only needs Bash and Python 3; no Node modules or browser package is required for its deterministic checks.

## Use

In a target repository, ask your agent for example:

```text
Build a project showcase site for this repository. Recommend a style first.
```

```text
Create a project homepage in tech-futuristic style and verify it locally. Do not deploy it.
```

```text
Use repo-showcase to build an Apple-minimal introduction site, then prepare it for GitHub Pages.
```

For a larger project site:

```text
Use repo-showcase in showcase-guide-demo mode. Create the homepage, a guide quick-start page, and a demo page from the repository's real examples. Omit anything unsupported by the source.
```

The workflow writes a fact index to `.repo-showcase/facts.json`, produces `site/index.html` by default, and validates the output with:

```bash
python3 <skill-root>/scripts/validate-site.py site
```

For a multi-page site, use `--all` to check every HTML route:

```bash
python3 <skill-root>/scripts/validate-site.py site --all
```

Typical multi-page output:

```text
site/
├── index.html
├── docs/
│   └── index.html
├── guide/
│   └── quick-start.html
├── demo/
│   └── index.html
└── assets/
```

## Design principles

- Source-backed copy: every claim is traceable to repository material or omitted.
- Portable output: local assets and system fonts by default, no build step or CDN.
- Choice without genericness: styles define typography, composition, motion, and constraints—not just colors.
- Honest verification: static checks always run; visual review is reported separately when a browser is available.
- Explicit publishing: deployment and remote changes happen only on request.

## Development

Run the built-in smoke tests:

```bash
bash tests/test_analyze_repo.sh
bash tests/test_validate_site.sh
```

## License

MIT
