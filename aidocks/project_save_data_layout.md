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

**Shipped read-only data** stays in the bundle: `cst/data/` (config + maps) and `cst/sounds/`. The neighborhood map file under `cst/data/maps/` is **encrypted** going forward (`CSTENC` header, AES via `MAP_KEY` in `dec.nvgt`); sounds are not. Don't confuse the two: `data/`/`sounds`/`docks` are cwd-relative read-only assets; the AppData tree is the read/write user state.

**Map plaintext source / recovery (2026-08-20).** `load_map` self-heals: it reads `data/maps/<name>.map`, and if the file is plaintext (no `CSTENC`) it **re-encrypts it in place on load** (`map.nvgt:53–71`) — so a plaintext `.map` can't survive being loaded. The editable plaintext master is therefore kept as **`cst/data/maps/neighborhood.map.txt`** (the loader only opens `.map`, so the `.txt` is never touched or encrypted). It was restored from git after we thought it was lost: the pre-encryption source also lives in history as **blob `0640b06`** (the 50×50 map, from before the encryption commit `89c41ac`); older 100×100 versions exist as blobs `3096c3a`/`5843f1b`. To regenerate the shipped map, copy the `.txt` to `neighborhood.map` and let the game encrypt it on next load. Key layout landmarks (50×50): stand x0–15,y18–32; actions station `menu 2 6 19 31`; counter tile (14,25); market menus `buymenu 32 36 23 27` / `postermenu 38 42 23 27`; greeter `person 11 25`.
