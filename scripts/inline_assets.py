#!/usr/bin/env python3
"""Inline the local assets referenced by a Marp HTML export as data URIs.

Marp CLI keeps the theme background images (logos, photos) as relative paths,
which only resolve if the HTML file sits next to the ``assets/`` folder. The
published preview has to be a single self-contained file, so every
``assets/<name>`` reference is replaced by a base64 data URI.

Usage: python3 scripts/inline_assets.py preview/index.html
"""

import base64
import mimetypes
import re
import sys
from pathlib import Path

ASSET_RE = re.compile(r"(?P<path>(?:\.\./)*assets/[A-Za-z0-9._/-]+)")


def data_uri(path: Path) -> str:
    mime = mimetypes.guess_type(path.name)[0] or "application/octet-stream"
    encoded = base64.b64encode(path.read_bytes()).decode("ascii")
    return f"data:{mime};base64,{encoded}"


def resolve(root: Path, html_dir: Path, relative: str) -> Path | None:
    for candidate in (html_dir / relative, root / relative.lstrip("./")):
        if candidate.is_file():
            return candidate
    return None


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit(__doc__)

    html_path = Path(sys.argv[1]).resolve()
    root = html_path.parent.parent
    html = html_path.read_text(encoding="utf-8")

    def replace(match: re.Match) -> str:
        relative = match.group("path")
        asset = resolve(root, html_path.parent, relative)
        if asset is None:
            print(f"warning: missing asset {relative}", file=sys.stderr)
            return relative
        return data_uri(asset)

    inlined, count = ASSET_RE.subn(replace, html)
    html_path.write_text(inlined, encoding="utf-8")
    print(f"{html_path}: inlined {count} asset references")


if __name__ == "__main__":
    main()
