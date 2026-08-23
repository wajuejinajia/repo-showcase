# Verification and delivery checks

Run the static validator first:

```bash
python3 <skill-root>/scripts/validate-site.py <target-repository>/site
```

It checks unresolved template placeholders, page metadata, HTML language, duplicate IDs, fragment links, local resources, image alt text, external dependencies, and the default 150 KB `index.html` budget. Use `--allow-external` only for user-approved HTTP(S) links or fonts.

Then use a local server for visual checks:

```bash
python3 -m http.server 8000 --directory <target-repository>/site
```

When browser tooling is available, check:

- Desktop (at least 1280px): headings, cards, code blocks, and images do not overflow or overlap.
- Mobile (375px): navigation, CTAs, code copy controls, and text remain usable without horizontal scrolling.
- Keyboard: links and buttons have visible focus; the copy control works or clearly reports that manual copying is needed.
- Motion: `prefers-reduced-motion` disables nonessential movement; no flash or constant animation harms legibility.
- Content: each visible claim belongs in the evidence map, assets load from `site/`, and no sample text remains.

If browser tooling is unavailable, report that visual review could not be performed and do not imply that viewport behavior was inspected. The static validator remains useful, but it does not prove visual layout.

For deployment, re-check that assets do not use `../` paths outside the output directory. Record the deployment method and public URL only after the user has authorized the publishing action.
