---
name: repo-showcase
description: Build a source-backed, dependency-free showcase website for the current project repository in a chosen visual style, optionally with Docs, Guide, and Demo pages. Use for project homepages, landing pages, repository showcases, or GitHub Pages sites; do not use for product apps, dashboards, or full documentation platforms.
---

# Repo Showcase

Turn a code repository into a small, distinctive project website without inventing product claims. The default deliverable is a deployable `site/index.html` with local assets and no build step; an explicitly selected multi-page mode adds static Docs, Guide, and/or Demo routes.

## Operating model

There are two locations:

- **Skill root**: the folder containing this `SKILL.md`, its `scripts/`, `styles/`, and `templates/`.
- **Target repository**: the project the user wants to present. Unless the user says otherwise, write generated files only here.

When the skill is installed outside the target repository, always call bundled resources by their path beneath the skill root. Never assume `scripts/` or `styles/` exists in the target repository.

## Choose a site mode

Keep the default small and fast. If the user asks for documentation, guides, examples, or a demo page, ask them to choose a mode when the scope is ambiguous, then read [references/multipage.md](references/multipage.md) before generating:

| Mode | Output | Use when |
|---|---|---|
| `single-page` | `site/index.html` | A concise project introduction is enough |
| `showcase-docs` | Home + `docs/` pages | The repository has reference material or API docs |
| `showcase-guide-demo` | Home + `guide/` + `demo/` pages | Users need onboarding and an example flow |

Multi-page mode is still static HTML/CSS/JS. It does not create a CMS, authentication, a framework app, or a replacement for a large documentation system.

## 1. Establish facts before writing copy

Run the analyzer against the target repository:

```bash
bash <skill-root>/scripts/analyze-repo.sh <target-repository>
```

It writes `<target-repository>/.repo-showcase/facts.json`. Read it, then inspect the README, relevant configuration, and existing assets as needed. The manifest is an index, not marketing proof.

Build a compact internal evidence map before generating content. Every public claim, command, metric, and link must have a source file and line (or be omitted). Do not infer capabilities from a dependency name, write fake social proof, invent metrics, or fill missing sections with placeholders.

The analyzer is offline by default. Use `PROJECT_SHOWCASE_FETCH_REMOTE=1` only when the user wants GitHub metadata fetched and the repository is safe to query.

## 2. Choose a visual direction

If the user named a style, use it. If not, recommend at most three directions based on the project and let the user decide when the choice is material. Read the selected style file in full before implementation.

| Style | File | Best fit |
|---|---|---|
| Apple minimal | `styles/apple-minimal.md` | Product and design tools |
| Minimal clean | `styles/minimal-clean.md` | Libraries, frameworks, utilities |
| Tech futuristic | `styles/tech-futuristic.md` | Infrastructure, AI, performance tools |
| Cyberpunk neon | `styles/cyberpunk-neon.md` | High-impact creative projects |
| Gaming arcade | `styles/gaming-arcade.md` | Games and playful experiences |
| Glassmorphism | `styles/glassmorphism.md` | App and design-system showcases |
| Brutalist | `styles/brutalist.md` | Creative tools and expressive brands |
| Terminal hacker | `styles/terminal-hacker.md` | CLI tools and developer libraries |

Use a style as a design system, not merely a palette. Preserve readability, keyboard focus, reduced-motion support, and mobile behavior even where the style is visually expressive.

## 3. Generate a portable static site

Start from `<skill-root>/templates/base.html`; replace every placeholder, including `{{LANG}}`. Create `site/index.html` in the target repository unless the user selected another path. In a multi-page mode, reuse the same visual system and navigation on every page, and follow the route/content contract in `references/multipage.md`.

- Default to inline CSS and JavaScript, system fonts, and local assets. External fonts, analytics, remote images, generated imagery, and CDN dependencies require user approval.
- Copy assets used by the page into `site/assets/` so the result works after deployment. Keep their original license/attribution information when applicable.
- Use semantic landmarks, one `h1`, a useful title and meta description, visible keyboard focus, descriptive image `alt` text, and sufficient contrast.
- Include only sections supported by evidence: hero, features, code/example, screenshots, quick start, and footer are all optional when their source material is absent.
- Keep `index.html` below 150 KB by default. If an exception is justified, tell the user before shipping.

For a request that materially changes the product—framework migration, a CMS, authentication, a dynamic app, or publishing—confirm the scope before expanding beyond this static-site workflow.

## 4. Verify before handoff

Run the deterministic checks:

```bash
python3 <skill-root>/scripts/validate-site.py <target-repository>/site
# Multi-page mode: validate every HTML route
python3 <skill-root>/scripts/validate-site.py <target-repository>/site --all
```

If the user approved external links or fonts, add `--allow-external`. Then preview with a local server and inspect desktop and mobile layouts when browser tooling is available:

```bash
python3 -m http.server 8000 --directory <target-repository>/site
```

Read [references/verification.md](references/verification.md) for the visual and deployment checklist. Do not describe a site as verified if the validator or the applicable preview checks failed.

## 5. Deploy only on request

Before publishing, make the output self-contained and re-run validation. GitHub Pages may be deployed from a `gh-pages` branch, `/docs` on a supported source branch, or an explicitly requested workflow. Do not force-push, enable services, change repository settings, or publish to a remote without the user's approval.

## Extending the style library

To add a style, create `styles/<name>.md` with design tokens, typography, layout, motion, components, accessibility constraints, and explicit do/don't rules. Register it in the table above. A style should describe decisions that meaningfully differ from existing styles, not only substitute colors.
