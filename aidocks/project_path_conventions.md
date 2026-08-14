---
name: project_path_conventions
description: "The src/ (code) + cst/ (assets+launcher) + build/ + releases/ split, the cwd=cst/ trick, and how in-code paths resolve."
metadata:
  node_type: memory
  type: project
  originSessionId: 9c2aa66a-3d36-4ec3-8742-42265704afb7
---

ClassicStand separates code from runtime assets into top-level folders (the SimpleFighter layout):

- **`src/`** — code only. Entry `src/cst.nvgt`, plus `src/includes/` (`includes.nvgt`, `version.nvgt`, and the `main/` subtree — see [[project_include_tree]]). No assets here.
- **`cst/`** — runtime assets + the launcher: `cst/cst.py`, `cst/data/` (`config/`, `maps/`), `cst/docks/`, `cst/sounds/`.
- **`build/`** — the build/release pipeline (`tools.py`, `tools.ini`, `version.txt`) — see [[project_build_pipeline]].
- **`releases/`** — compiled output + archives (gitignored).

**The cwd trick (the key mechanism):** `cst/cst.py` runs `../src/cst.nvgt` through `C:\nvgt2\nvgt.exe` but sets **cwd = `cst/`**. So two path classes coexist in the code:
- `#include"includes/..."` resolves relative to the **script** → `src/includes/`.
- bare `sounds/...`, `data/...`, `docks/...` strings resolve relative to **cwd** → `cst/`.

So a path naming a *file on disk* is under `src/` or `cst/`, while the bare `data/`/`sounds/`/`docks/` strings in the code are cwd-relative against `cst/`. **No in-code asset path needs to change** for the split — only the launcher's cwd (runtime) and `tools.py`'s asset-copy (build) know about it. There are deliberately **no `#pragma asset`/`#pragma document`** lines (nvgt2 resolves those against the output dir, which was brittle); `tools.py` copies `data/docks/sounds` into the compiled bundle instead.

**Writable user data** is absolute, unaffected by the split: `DIRECTORY_APPDATA + "tsatria03/ClassicStand/..."` (preffs/saves/stats) — see [[project_save_data_layout]].
