#!/usr/bin/env python3
"""
new_mk_run.py — Launcher for new_mk.so
Runs the hidden Python source (renamed to .so) as __main__.
"""

import os
import sys
import runpy
import traceback

# ── Resolve script directory (so tested.txt / found.txt stay together) ──
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
TARGET = os.path.join(SCRIPT_DIR, "new_mk.so")

# ── Change to script directory ──
os.chdir(SCRIPT_DIR)


def _die(msg: str, code: int = 1):
    print(f"\033[1;31m❌ {msg}\033[0m")
    sys.exit(code)


def main():
    # ── Check target file ──
    if not os.path.exists(TARGET):
        _die(f"File not found: {TARGET}")
    if not os.path.isfile(TARGET):
        _die(f"Not a file: {TARGET}")

    # ── Ensure Python can be found on some Termux setups ──
    # (no-op here, just for safety)

    # ── Run new_mk.so as __main__ ──
    try:
        runpy.run_path(TARGET, run_name="__main__")
    except SystemExit:
        # Allow clean exit from sys.exit() inside new_mk.so
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