# Multi-page site modes

Use this reference only when the user selects `showcase-docs` or `showcase-guide-demo`, or explicitly asks for Docs, Guide, Demo, examples, or multiple routes.

## Page contracts

Every page shares the selected visual system, a working navigation link back to the homepage, a unique `<title>`, one primary `<h1>`, a useful meta description, keyboard-visible focus, and relative links that work when the `site/` folder is copied to a static host.

### `showcase-docs`

```text
site/
├── index.html
├── docs/
│   ├── index.html
│   ├── installation.html       # only if installation evidence exists
│   ├── configuration.html      # only if configuration evidence exists
│   └── api.html                # only if API/reference material exists
└── assets/
```

Use `README`, `docs/`, typed public interfaces, configuration examples, and release notes as sources. Keep code examples exact or label them as adapted snippets. Do not turn an internal implementation detail into public API documentation without evidence.

### `showcase-guide-demo`

```text
site/
├── index.html
├── guide/
│   ├── index.html
│   └── quick-start.html       # only when a real setup path exists
├── demo/
│   └── index.html             # runnable, hosted, screenshot, or code demo
└── assets/
```

Use `examples/`, `demo/`, `sample/`, CLI scripts, screenshots, and README usage sections. A Demo page may link to a real hosted demo, show a repository example, or explain how to run the example locally. If no demo evidence exists, omit the page or make the absence explicit; never invent an interactive demo or pretend a screenshot is live.

## Navigation and links

Use a stable primary navigation on all pages:

```text
Home → Docs → Guide → Demo → Repository
```

Omit links to routes that were not generated. From nested pages, use `../index.html` or the appropriate relative path rather than root-absolute URLs. Keep anchor IDs unique within each page and run the recursive validator before handoff.

## Shared assets

For multiple pages, shared CSS and JavaScript may live under `site/assets/` to avoid duplication. The result must still work without a build step. Copy every referenced repository asset into `site/assets/` and avoid links such as `../../src/image.png` that escape the deployable site.

## Content and scope boundary

The page count follows the evidence, not a fixed marketing template. A project with only a README may get a homepage and a short quick-start section; a project with rich `docs/` and `examples/` can get the full route set. If the user asks for search, versioned docs, authentication, editing, or dynamic API calls, stop and confirm a separate application or documentation-site scope.
