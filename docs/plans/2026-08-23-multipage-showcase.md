# Multi-page Showcase Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Extend `repo-showcase` so it can generate an evidence-backed multi-page project site with optional Docs, Guide, and Demo sections while preserving the single-page default.

**Architecture:** Keep output as a static, build-free site. Add a mode-selection contract and page-information rules in a focused reference, and make the standard-library validator recurse through every generated HTML page so cross-page links and assets are checked consistently.

**Tech Stack:** Markdown instructions, HTML/CSS/vanilla JavaScript, Python 3 standard library, Bash smoke tests.

---

### Task 1: Define multi-page modes and content boundaries

**Files:**
- Modify: `SKILL.md`
- Modify: `README.md`
- Create: `references/multipage.md`

**Step 1: Write the mode contract**

Document `single-page`, `showcase-docs`, and `showcase-guide-demo` modes, their page routes, evidence sources, navigation rules, and when to omit a page. Keep multi-page generation opt-in so existing requests remain compatible.

**Step 2: Add implementation guidance**

Require shared navigation, a consistent visual system, relative links, local assets, one title and `h1` per page, and source-backed content. State that a missing runnable Demo becomes a code/example page or is omitted rather than invented.

**Step 3: Document usage and output**

Add prompts and a directory tree to `README.md`, linking the detailed reference from `SKILL.md`.

**Step 4: Review for scope safety**

Confirm that frameworks, CMSs, authentication, and production app behavior remain outside this static multi-page mode.

### Task 2: Make the static validator cover a complete site

**Files:**
- Modify: `scripts/validate-site.py`
- Modify: `tests/test_validate_site.sh`
- Create: `tests/fixtures/site-multipage/index.html`
- Create: `tests/fixtures/site-multipage/docs/index.html`
- Create: `tests/fixtures/site-multipage/guide/quick-start.html`
- Create: `tests/fixtures/site-multipage/demo/index.html`
- Create: `tests/fixtures/site-multipage/assets/site.css`

**Step 1: Add a failing multi-page test**

Run validation with `--all` against a fixture containing four pages, shared CSS, nested relative links, and an intentionally broken page check.

**Step 2: Implement recursive validation**

Add `--all` to validate every `*.html` file below a directory, aggregate errors with page paths, and resolve local resources/fragment links relative to each page. Keep existing single-file behavior unchanged.

**Step 3: Run the test to verify it passes**

Run: `tests/test_validate_site.sh`

Expected: the valid multi-page fixture passes and the invalid fixture fails.

### Task 3: Integrate and verify

**Files:**
- Modify: `references/verification.md`
- Modify: `docs/plans/2026-08-23-multipage-showcase.md`

**Step 1: Update verification guidance**

Document recursive validation, route checks, mobile navigation on every page, and deployment-safe relative paths.

**Step 2: Run all checks**

Run:

```bash
tests/test_analyze_repo.sh
tests/test_validate_site.sh
git diff --check
```

Expected: all commands exit successfully.

**Step 3: Review the final diff**

Confirm single-page instructions and existing style files remain intact, then report the new multi-page output contract.
