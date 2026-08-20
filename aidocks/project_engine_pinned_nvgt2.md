---
name: project_engine_pinned_nvgt2
description: "ClassicStand runs on the pinned legacy NVGT fork at C:\\nvgt (BASS audio); upstream C:\\nvgt2 (miniaudio) is incompatible — don't target it or suggest upgrading."
metadata:
  node_type: memory
  type: project
  originSessionId: 9c2aa66a-3d36-4ec3-8742-42265704afb7
---

The game is pinned to the **legacy NVGT fork at `C:\nvgt\nvgt.exe`** (BASS audio). The launcher `cst/cst.py` and `build/tools.py` both use it. A newer stock NVGT at `C:\nvgt2` (miniaudio) exists only for testing other people's games — **do not target it or treat upstream NVGT as authoritative**, and don't suggest upgrading the engine.

**Why:** ClassicStand depends on behavior specific to the nvgt fork; upstream NVGT changed the audio backend and other internals and is incompatible.

**Consequences to watch:**
- Any hardcoded relaunch/restart path must point at `C:\nvgt` (e.g. `restart_game()` runs `c:\nvgt\nvgtw.exe`), never `c:\nvgt2`.
- The nvgt stdlib includes live under `C:\nvgt` and in the source mirror at `misc\Legacy-NVGT\release\include`; some helper scripts are vendored into `src/includes/main/deps/` (see [[project_include_tree]]).
