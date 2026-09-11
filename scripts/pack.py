#!/usr/bin/env python3
"""Builds the archive a reader downloads.

One definition, used twice. The release was assembled by hand — somebody
choosing which paths to include, following what the previous release had
looked like — and the editor's CI packed the whole tree instead, so the
archive four tests ran against was not the archive anybody installed. Those
tests exist for a defect that has happened twice, a plugin "installed" with
only its entrypoint; a hand-assembled release is exactly that failure, and
testing a differently-built archive cannot see it.

What goes in is listed here rather than excluded: a list of exclusions grows
a hole every time somebody adds a directory, and this is the file that says
what a plugin *is*.
"""

import argparse
import json
import pathlib
import sys
import zipfile

ROOT = pathlib.Path(__file__).resolve().parent.parent

# Everything the editor reads, and the three files a reader is entitled to.
# `docs/` stays out: the translations are for someone reading the repository,
# and the editor never opens them.
CONTENTS = [
    "manifest.json",
    "plugin.lua",
    "lib",
    "README.md",
    "CHANGELOG.md",
    "LICENSE",
]


def files():
    for name in CONTENTS:
        path = ROOT / name
        if not path.exists():
            sys.exit(f"{name} is missing; a plugin without it is half a plugin")
        if path.is_dir():
            for child in sorted(path.rglob("*")):
                if child.is_file():
                    yield child
        else:
            yield path


def main() -> int:
    manifest = json.loads((ROOT / "manifest.json").read_text(encoding="utf-8"))
    default = ROOT / f"marktext-plus-ai-assistant-v{manifest['version']}.zip"
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("output", nargs="?", default=str(default),
                        help="where to write the archive")
    arguments = parser.parse_args()

    written = []
    with zipfile.ZipFile(arguments.output, "w", zipfile.ZIP_DEFLATED) as archive:
        for path in files():
            name = str(path.relative_to(ROOT))
            archive.write(path, name)
            written.append(name)

    print(f"{arguments.output}: {len(written)} files")
    for name in written:
        print(f"  {name}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
