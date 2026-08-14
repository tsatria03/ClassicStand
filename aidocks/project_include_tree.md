---
name: project_include_tree
description: "src/includes/ layout: version.nvgt + the main/{deps,functions,globals,menus,parsers} subtree, glob includes, and the vendored stdlib helpers (incl. rotation)."
metadata:
  node_type: memory
  type: project
  originSessionId: 9c2aa66a-3d36-4ec3-8742-42265704afb7
---

Entry `src/cst.nvgt` does `#include"includes/includes.nvgt"`. `src/includes/` holds `includes.nvgt` (the aggregator) and `version.nvgt` at the top level; everything else lives under **`main/`**:

- **`main/deps/`** — vendored stdlib/helper scripts + shared UI: `bgt_compat`, `instance`, `keyhook`, `sound_pool`, `rotation`, `form`, `speech`, `custom_menu`, `dlg`, `savedata`, `virtual_dialogs`.
- **`main/functions/`** — `extrafuncts`, `savefuncks`.
- **`main/globals/`** — the entity/world classes and global state: `dec` (globals), `game`, `map`, `inventory`, `customer`, `npc`, `person`, `platform`, `wall`, `zone`, `soundsource`, `decpool`.
- **`main/menus/`** — `menu`, `menu_trigger`, `setupmenu`.
- **`main/parsers/`** — the data-driven loaders: `*_table`, `*_store`, `main_event`, `passerby` (see [[project_data_driven_config]]).

**Aggregation is by wildcard glob.** `includes.nvgt` is `#include"version.nvgt"` followed by `#include"main/deps/*"`, `#include"main/functions/*"`, `#include"main/globals/*"`, `#include"main/menus/*"`, `#include"main/parsers/*"`. So a new file dropped into a `main/<subdir>/` is auto-included — no wiring needed. There are **no bare stdlib includes and no `#pragma asset/document`** lines (the asset pragmas were dropped; `bgt_compat`/`instance`/`keyhook`/`sound_pool` are vendored into `main/deps/` and picked up by the deps glob).

**Vendoring gotcha:** a vendored helper's own `#include` resolves against its folder (`main/deps/`), NOT the engine include path. `sound_pool.nvgt` does `#include "rotation.nvgt"` and needs `rotation.nvgt` (which defines `pi` and `calculate_theta`) present in `main/deps/` — it's vendored there. If you vendor another engine helper, bring its transitive includes too. Engine: [[project_engine_pinned_nvgt2]].
