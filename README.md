# SDSC Marp theme

A [Marp](https://yhatt.github.io/marp/) theme that reproduces the official
**San Diego Supercomputer Center** slide template (the SDSC / UC San Diego
Halıcıoğlu School of Data Science and Computing PowerPoint template published
at <https://www.sdsc.edu/about/brand.html>, file
`SDSC-UCSanDiego-HSDSC.potx`).

Everything (colours, fonts, geometry, logos, photos) was extracted from that
`.potx` file, not eyeballed, so the Markdown deck and the PowerPoint deck look
the same.

## Quick start

```bash
cd sdsc-marp
./scripts/render.sh                 # renders demo/demo.md to out/*.png and out/demo.pdf
./scripts/render.sh slides/my.md    # renders any deck with the same theme
```

To use the theme in your own deck, put this in the front matter of the
Markdown file and keep the theme CSS one directory above the deck (the paths
below assume the deck lives in `slides/`, next to `themes/` and `assets/`):

```markdown
---
marp: true
theme: ../themes/sdsc.css
paginate: true
size: 16:9
---
```

Fonts: **Teko** (headlines) and **Source Sans 3** (body). Both are brand
approved and free from Google Fonts. They are already installed on this
machine (`/usr/local/share/fonts/Teko.ttf`, `/usr/local/share/fonts/SourceSans3.ttf`);
on another machine install them or the deck falls back to a sans-serif.

## Slide classes

Add the class with a Marp directive at the top of the slide:

```markdown
<!-- _class: reverse -->
```

| Class | Result |
| --- | --- |
| *(none)* | Standard content slide: blue title, navy body, gray footer bar |
| `title` | Title slide: official dusk photo of the SDSC building, white Teko title, co-branded logos bottom right, no footer bar |
| `reverse` | Navy background, white title, light gray body, gold emphasis and links |
| `section` | Navy divider slide, white 60 pt title with a gold subtitle |
| `statement` | Navy slide with one large centred sentence (the "Big Bold Statement" layout) |
| `lead` | Bigger title, no fixed title band |
| `columns` | Helper class for `<div class="columns">` two-column layouts |

Background images use the standard Marp keywords, for example
`![bg right:45%](../assets/photo-datacenter.jpg)`. The image runs edge to edge
and the footer bar is drawn on top of it, exactly like the "Image right + copy"
layout of the PowerPoint template.

## Design tokens

Taken from `ppt/theme/theme1.xml` and the slide master of the official
template:

| Token | Value | Use |
| --- | --- | --- |
| Navy | `#182B49` (PMS 2767) | Body text, reverse backgrounds |
| Blue | `#00629B` | Titles on light slides, emphasis, links |
| Gold | `#C69214` (PMS 1245) | Wordmark gold |
| Bright gold | `#FFCD00` | Emphasis and links on reverse slides |
| Footer gray | `#747678` | Footer bar |
| Light gray | `#E7E6E6` | Body text on reverse slides |

Geometry, converted from the 12192000 x 6858000 EMU PowerPoint master to the
1280 x 720 px Marp canvas (1 px = 9525 EMU):

| Element | Value |
| --- | --- |
| Left and right margin | 88 px |
| Title band | starts at 38 px, 154 px tall, title vertically centred |
| Body text | 29 px (22 pt), line height 0.95 |
| Title | Teko 72 px (54 pt), line height 0.8 |
| Footer bar | 52.5 px tall, `#747678` |
| SDSC wordmark (footer) | 192 x 35 px at 46 px from the left |
| UC San Diego / HSDSC logo (footer) | 132 x 35 px at 46 px from the right |
| Title slide logos | 186 px wide at x = 1031 px, y = 496 px and y = 618 px |

## Repository layout

```
sdsc-marp/
├── assets/                 logos (SVG, colour and white variants) and brand photos
├── demo/demo.md            11 slide deck exercising every layout
├── out/                    rendered PNG and PDF of the demo deck
├── reference/official/     the 10 slides of the official template, rendered for comparison
├── scripts/chrome-wrapper.sh   Chrome launcher that adds --no-sandbox
├── scripts/render.sh       render any deck with the theme
└── themes/sdsc.css         the theme
```

## Rendering on this machine

Chrome cannot start with its sandbox on this host (AppArmor blocks
unprivileged user namespaces on Ubuntu 23.10+), and Marp CLI has no flag to
pass `--no-sandbox` to Puppeteer. `scripts/chrome-wrapper.sh` wraps Chrome with
that flag and is used through `CHROME_PATH`; `scripts/render.sh` sets it
automatically. Override the browser with `MARP_CHROME_BIN=/path/to/chrome`.

`--allow-local-files` is required because the theme references local assets
(logos and photos) from the CSS.

## Notes and deviations from the PowerPoint template

* The PowerPoint master sets a 28 pt body size, but every slide in the
  template uses 22 pt, so the theme uses 22 pt (29 px).
* The "Big Bold Statement" layout is 180 pt in PowerPoint, which only fits a
  couple of words; the theme uses 130 px so a full sentence fits.
* The "Section Header" layout in PowerPoint places the subtitle near the
  bottom of the slide; the theme keeps it right under the title.
* Page numbers are optional (`paginate: true` in the front matter) and are
  placed on the footer bar, to the left of the UC San Diego logo.
* Code blocks and tables have no equivalent in the official template, so they
  use the brand colours (light gray background, blue or gold left border).

## Credits

Official template, logos and photographs: San Diego Supercomputer Center
brand guide, <https://www.sdsc.edu/about/brand.html>. Please follow the brand
rules when reusing the assets (do not stretch, recolour or alter the wordmark,
keep the clear space, and use the white wordmark on dark backgrounds).
