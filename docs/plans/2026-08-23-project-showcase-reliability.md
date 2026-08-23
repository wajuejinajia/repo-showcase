# Project Showcase Reliability Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Make `project-showcase` portable across repositories and Agent runtimes, evidence-led in its content, and testable before delivery.

**Architecture:** Keep the skill dependency-free and static. Make repository discovery deterministic in `scripts/analyze-repo.sh`, emitting a machine-readable facts manifest in addition to a readable summary. Keep the primary workflow concise in `SKILL.md` and move only operational detail into linked references; validate generated output with a standard-library Python checker.

**Tech Stack:** Bash, Python 3 standard library, HTML/CSS/vanilla JavaScript, Markdown.

---

### Task 1: Make the repository analyzer portable and evidence-producing

**Files:**
- Modify: `scripts/analyze-repo.sh`
- Create: `tests/fixtures/node-project/package.json`
- Create: `tests/fixtures/node-project/README.md`
- Create: `tests/fixtures/node-project/public/logo.svg`
- Create: `tests/test_analyze_repo.sh`

**Step 1: Write the failing shell test**

Assert that invoking the analyzer by absolute skill path against the fixture exits successfully and writes a JSON facts manifest containing project name, package metadata, feature sources, asset paths, and repository URL when available.

**Step 2: Run the test to verify it fails**

Run: `bash tests/test_analyze_repo.sh`

Expected: FAIL because the current analyzer only prints a human-readable report.

**Step 3: Implement the smallest robust analyzer upgrade**

Support a target-repository argument, avoid network access by default, detect common project manifests and lockfiles, enumerate common image types consistently, and write `.project-showcase/facts.json`. Make remote metadata opt-in through `PROJECT_SHOWCASE_FETCH_REMOTE=1` with bounded `curl` timeouts.

**Step 4: Run the test to verify it passes**

Run: `bash tests/test_analyze_repo.sh`

Expected: PASS and an inspectable fixture facts manifest.

**Step 5: Commit**

```bash
git add scripts/analyze-repo.sh tests
git commit -m "feat: add portable repository facts analysis"
```

### Task 2: Add deterministic generated-site checks

**Files:**
- Create: `scripts/validate-site.py`
- Create: `tests/fixtures/site-valid/index.html`
- Create: `tests/fixtures/site-invalid/index.html`
- Create: `tests/test_validate_site.sh`

**Step 1: Write failing tests**

Test that valid HTML with a title, description, viewport, language, local asset, no unresolved template markers, and a working fragment link passes. Test that an unresolved marker and a missing asset fail.

**Step 2: Run the test to verify it fails**

Run: `bash tests/test_validate_site.sh`

Expected: FAIL because the validator does not exist.

**Step 3: Implement the standard-library validator**

Use `html.parser` and filesystem checks to validate the required metadata, unresolved placeholders, duplicate IDs, fragment links, same-origin local resources, image `alt` attributes, and the 150 KB default size budget. Provide an explicit `--allow-external` escape hatch.

**Step 4: Run the tests to verify they pass**

Run: `bash tests/test_validate_site.sh`

Expected: PASS, including expected failure handling for the invalid fixture.

**Step 5: Commit**

```bash
git add scripts/validate-site.py tests
git commit -m "feat: validate generated showcase sites"
```

### Task 3: Turn the workflow into a portable, evidence-led contract

**Files:**
- Modify: `SKILL.md`
- Modify: `templates/base.html`
- Create: `references/verification.md`
- Modify: `README.md`

**Step 1: Update the workflow instructions**

Define skill-root versus target-repository paths; require agents to invoke the analyzer from the skill directory with an explicit target path. Require review of `.project-showcase/facts.json`, an internal claim-to-source ledger, and user approval only where a visual direction is materially unspecified.

**Step 2: Clarify output and deployment boundaries**

Set the default to offline-capable system fonts and local assets. Treat external fonts, generated visual assets, third-party analytics, publishing, and history rewriting as opt-in. Specify safe asset copying for deployable output and avoid writing to a tracked repository until the user requests generation.

**Step 3: Improve the base template**

Use a `{{LANG}}` placeholder, declare the template as the required starting point, add an accessible copy-button fallback for non-secure contexts, honor reduced motion, and remove style-agnostic visual behavior when the chosen style rules forbid it.

**Step 4: Document verification and adoption**

Link the verification reference from the skill and add README quick-start examples for local and globally installed skills. Include the generated-site validation command and explain the data provenance guarantee.

**Step 5: Verify the integrated behavior**

Run: `bash tests/test_analyze_repo.sh && bash tests/test_validate_site.sh && python3 scripts/validate-site.py tests/fixtures/site-valid`

Expected: all commands exit 0.

**Step 6: Commit**

```bash
git add SKILL.md README.md templates/base.html references docs/plans
git commit -m "docs: harden project showcase workflow"
```
