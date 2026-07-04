# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A personal wiki: plain-text `.org` files in `content/` are compiled to a static HTML site in `public/` by Emacs `org-publish`. Babel code blocks (Python, R, shell, Emacs Lisp) are executed at build time and their output is embedded in the HTML.

## Environment

The dev shell is managed by Nix (`flake.nix`) and activated automatically by direnv. All tools — `emacs`, `python3`, `R`, `just` — come from Nix. Run `direnv allow` once after cloning.

## Commands

```bash
just run                                              # force-rebuild everything, serve on :8080, open browser
emacs --batch -l publish.el -f org-publish-all        # incremental build (only changed files)
emacs --batch -l publish.el --eval "(org-publish-all t)"  # force full rebuild
python3 -m http.server 8080 --directory public/       # serve output (required: stylesheet uses root-relative /style.css)
```

Use the force rebuild after editing `publish.el` or `static/style.css` — those changes don't touch `.org` files and won't trigger an incremental rebuild.

## Architecture

**Pipeline:** `content/**/*.org` → Emacs (`publish.el`) → `public/` (HTML + CSS)

`publish.el` defines three `org-publish` components:
- `wiki-org` — converts all `.org` files to HTML, injecting the nav preamble and stylesheet link
- `wiki-assets` — copies images/PDFs from `content/` as-is
- `wiki-static` — copies `static/style.css` (and any JS) to `public/`

**Content structure:** Each subject gets a folder under `content/`. The folder's `index.org` is the page users see. Individual concept files (e.g., `fibonacci.org`) are pulled into `index.org` via `#+INCLUDE: "fibonacci.org" :minlevel 2` — they also publish as their own standalone pages.

**Nav bar:** The tab links in `wiki-preamble` inside `publish.el` are the only place the nav is defined. Adding a new tab requires adding an `<a>` there — `org-publish` discovers new folders automatically (`:recursive t`).

**Stylesheet:** `static/style.css` is the single stylesheet. It's copied to `public/style.css` at build time. The HTML references it as `/style.css` (root-relative), which is why a local HTTP server is required to view the site.

## Org File Conventions

Every snippet file should have:
```org
#+TITLE: Concept Name
#+OPTIONS: toc:nil num:nil
```

Section index files use `toc:2` to generate a table of contents.

To add a new language to Babel, add it to `org-babel-do-load-languages` in `publish.el` and add the runtime package to `flake.nix`.

**Gotcha:** `#+` keywords inside `#+begin_example` blocks must be prefixed with a comma (`,#+INCLUDE:`) or Org's preprocessor will execute them rather than display them literally.
