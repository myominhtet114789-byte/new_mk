#!/usr/bin/env python3
"""
new_mk_run.py — Launcher for new_mk.so (Auto-Detect)
Finds new_mk.so, or falls back to new_mk_32bit.so / new_mk_64bit.so,
then runs it as __main__ via runpy.
"""

import os
import sys
import runpy
import shutil
import traceback

# ── Resolve script directory ──
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
os.chdir(SCRIPT_DIR)

# ── Candidate filenames (priority order) ──
CANDIDATES = [
    "new_mk.so",
    "new_mk_32bit.so",
    "new_mk_64bit.so",
    "mkmk.so",
    "mkmk_32bit.so",
    "mkmk_64bit.so",
]

PRIMARY = os.path.join(SCRIPT_DIR, "new_mk.so")


def _die(msg: str, code: int = 1):
    print(f"\033[1;31m❌ {msg}\033[0m")
    sys.exit(code)


def find_target() -> str:
    """Return path to new_mk.so, auto-renaming alternatives if needed."""
    # 1) Already correct
    if os.path.isfile(PRIMARY):
        return PRIMARY

    # 2) Look for alternatives and rename
    for name in CANDIDATES[1:]:
        path = os.path.join(SCRIPT_DIR, name)
        if os.path.isfile(path):
            print(f"\033[1;33m⚠️  Found: {name}\033[0m")
            print(f"\033[1;33m⚠️  Renaming → new_mk.so\033[0m")
            try:
                shutil.move(path, PRIMARY)
                return PRIMARY
            except Exception as e:
                _die(f"Rename failed: {e}")

    _die(
        f"new_mk.so not found in:\n   {SCRIPT_DIR}\n"
        f"   Candidates tried: {', '.join(CANDIDATES)}"
    )


def main():
    target = find_target()
    print(f"\033[1;32m✅ Running: {os.path.basename(target)}\033[0m\n")

    try:
        runpy.run_path(target, run_name="__main__")
    except SystemExit:
        # clean exit from sys.exit() inside new_mk.so
        raise
    except KeyboardInterrupt:
        print("\n\033[1;33m⚠️ Interrupted\033[0m")
        sys.exit(130)
    except Exception as e:
        print(f"\033[1;31mError: {e}\033[0m")
        traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    main()
