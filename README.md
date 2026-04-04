# Barrel Organ Discovery (Zola)

Static site generated with [Zola](https://www.getzola.org/). No Grunt or Node build step: content lives in `content/`, templates in `templates/`, and assets in `static/`.

## Commands

```bash
zola build              # output: public/
zola serve              # local preview (default http://127.0.0.1:1111)
make prod               # production build for barrel-organ-discovery.org/site/ (see Makefile)
./scripts/build-site-deploy.sh   # same as make prod (wiki sync + zola --base-url)
```

Requires Zola ≥ 0.22. `compile_sass = true` in `config.toml` builds `sass/site.scss` → `public/site.css`.

## Theme (colors & layout)

Maintain branding in **`sass/_tokens.scss`**:

- **Palette** (aligned with barrel-organ-discovery.org): gradient `#2672d7` → `#012665`, hero / nav text `#f8f8f8`, body `#333`, muted `#777`, borders `#e5e5e5`.
- **CSS variables** on `:root` (`--bod-*`) are the single source of truth for colors, radii, and header spacing.
- **Typography**: [Rubik](https://fonts.google.com/specimen/Rubik) is loaded in `templates/base.html`; `body` uses class `bod-site`.
- **Layout**: `templates/nav.html` — one light bar (`site-header__menu-bar`) with **flexbox** `.site-nav` (horizontal links; no Bootstrap navbar / no `collapse`). Styles in `sass/_layout.scss`.
- **Components** (panels, jumbotron, footer, alerts, primary buttons): `sass/_components.scss`.

Entry file: `sass/site.scss` (`@use` of partials). Edit partials only; avoid duplicating hex values outside `_tokens.scss`.

## Layout

| Path | Role |
|------|------|
| `content/_index.md` | Home (template `home.html`) |
| `content/about.md`, `gallery.md`, `download.md`, `krunch.md`, `laser.md` | Main site pages |
| `content/wiki/` | Wiki: `articles/**` Markdown + `presentation-aprint-2014.md` |
| `sass/` | Theme: tokens, typography, layout, components → `site.css` |
| `static/` | `resources/`, `newsmedia/`, `krunch/`, `laser/`, etc. (no legacy `style.css`; use Sass) |
| `templates/base.html` | Rubik, Bootstrap 3 (grid/panels/glyphicons), `site.css`, gtag |

`config.toml` sets `base_url` for production; adjust for staging or local preview if needed.

## Wiki assets

Article folders under `content/wiki/articles/` include images and binaries next to the `.md` files. `scripts/sync-wiki-static-assets.sh` copies them into `static/wiki/` for Zola. Optional legacy PNGs for the 2014 presentation can be placed under `dist/wiki/` at the repo root if needed (see the script).

## Front matter helper

`scripts/add_front_matter.py` was used once to prepend titles to imported wiki pages; re-run only for new raw Markdown imports.
