#!/usr/bin/env python3
"""
Fix CommonMark ATX headings: require a space after # (e.g. #Title -> # Title).
Run from repo root: python3 scripts/fix_wiki_markdown.py
"""
import re
from pathlib import Path


def split_front_matter(text: str) -> tuple[str, str]:
    if not text.lstrip().startswith("+++"):
        return "", text
    m = re.match(r"^(\+\+\+[\s\S]*?\+\+\+\s*\n)([\s\S]*)$", text)
    if m:
        return m.group(1), m.group(2)
    return "", text


def fix_atx_headings(text: str) -> tuple[str, bool]:
    changed = False
    out = []
    for line in text.splitlines(keepends=True):
        if line.endswith("\n"):
            body, nl = line[:-1], "\n"
        elif line.endswith("\r\n"):
            body, nl = line[:-2], "\r\n"
        else:
            body, nl = line, ""
        new_body = re.sub(r"^(#{1,6})([^\s#])", r"\1 \2", body)
        if new_body != body:
            changed = True
        out.append(new_body + nl)
    return "".join(out), changed


def main() -> None:
    root = Path(__file__).resolve().parent.parent / "content" / "wiki"
    for md in sorted(root.rglob("*.md")):
        text = md.read_text(encoding="utf-8", errors="replace")
        fm, body = split_front_matter(text)
        new_body, changed = fix_atx_headings(body)
        if not changed:
            continue
        md.write_text(fm + new_body, encoding="utf-8")
        print("fixed headings:", md.relative_to(root.parent.parent))


if __name__ == "__main__":
    main()
