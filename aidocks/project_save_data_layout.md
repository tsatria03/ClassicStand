---
name: project_save_data_layout
description: "Writable user data lives in AppData under tsatria03/ClassicStand/ (preffs/saves/stats); the map file is encrypted, sounds are not."
metadata:
  node_type: memory
  type: project
  originSessionId: 9c2aa66a-3d36-4ec3-8742-42265704afb7
---

All writable player data is stored **absolutely** under `DIRECTORY_APPDATA + "tsatria03/ClassicStand/"`, so it's independent of the src/asset layout ([[project_path_conventions]]). `main()` creates the dirs at startup; the paths are declared in `main/globals/dec.nvgt` and used by `main/functions/savefuncks.nvgt`:

- `preffs/` — settings + saved profile (business title, options).
- `saves/` — save-slot game state (multiple independent slots).
- `stats/` — lifetime stats.

**Shipped read-only data** stays in the bundle: `cst/data/` (config + maps) and `cst/sounds/`. The neighborhood map file under `cst/data/maps/` is **encrypted** going forward; sounds are not. Don't confuse the two: `data/`/`sounds`/`docks` are cwd-relative read-only assets; the AppData tree is the read/write user state.
