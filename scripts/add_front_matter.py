#!/usr/bin/env python3
"""Prepend minimal Zola front matter to wiki markdown files if missing."""
from pathlib import Path


def title_from_text(text: str, fallback: str) -> str:
    for line in text.splitlines():
        line = line.strip()
        if line.startswith("# "):
            return line[2:].strip()
    return fallback.replace("_", " ")


def main() -> None:
    root = Path(__file__).resolve().parent.parent / "content" / "wiki"
    for md in sorted(root.rglob("*.md")):
        text = md.read_text(encoding="utf-8", errors="replace")
        if text.lstrip().startswith("+++"):
            continue
        title = title_from_text(text, md.stem)
        # TOML basic string escaping for double quotes
        safe = title.replace("\\", "\\\\").replace('"', '\\"')
        fm = f'+++\ntitle = "{safe}"\n+++\n\n'
        md.write_text(fm + text, encoding="utf-8")
        print("updated:", md.relative_to(root))


if __name__ == "__main__":
    main()
