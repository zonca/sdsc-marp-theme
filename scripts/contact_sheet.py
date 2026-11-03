#!/usr/bin/env python3
"""Build a contact sheet (grid of slides) from rendered slide images.

Used for the README banner and for the blog post illustration.

Usage: python3 scripts/contact_sheet.py out/demo.*.png preview/screenshot.png
"""

import sys
from pathlib import Path

from PIL import Image

COLUMNS = 3
GAP = 18
MARGIN = 24
THUMB_WIDTH = 520
BACKGROUND = (233, 235, 238)


def main() -> None:
    if len(sys.argv) < 3:
        raise SystemExit(__doc__)

    sources = [Path(p) for p in sys.argv[1:-1]]
    target = Path(sys.argv[-1])

    thumbs = []
    for source in sources:
        image = Image.open(source).convert("RGB")
        height = round(image.height * THUMB_WIDTH / image.width)
        thumbs.append(image.resize((THUMB_WIDTH, height), Image.LANCZOS))

    rows = (len(thumbs) + COLUMNS - 1) // COLUMNS
    cell_height = max(image.height for image in thumbs)
    sheet_width = MARGIN * 2 + COLUMNS * THUMB_WIDTH + (COLUMNS - 1) * GAP
    sheet_height = MARGIN * 2 + rows * cell_height + (rows - 1) * GAP

    sheet = Image.new("RGB", (sheet_width, sheet_height), BACKGROUND)
    for index, image in enumerate(thumbs):
        x = MARGIN + (index % COLUMNS) * (THUMB_WIDTH + GAP)
        y = MARGIN + (index // COLUMNS) * (cell_height + GAP)
        sheet.paste(image, (x, y))

    target.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(target, optimize=True)
    print(f"{target}: {sheet_width}x{sheet_height}, {len(thumbs)} slides")


if __name__ == "__main__":
    main()
