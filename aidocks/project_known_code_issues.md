---
name: project_known_code_issues
description: "Internal code-quality issues from the 2026-08-20 (v3.3) evaluation: global-state sprawl, silent parser failures, heavy duplication, recursion-as-navigation, and assorted latent bugs."
metadata:
  node_type: memory
  type: project
  originSessionId: 841c7bbe-eeb5-4073-8c9a-f9730d0662d1
---

Internal-quality problems that don't (yet) show up to the player but raise the cost/risk of every change. Found during the full-repo evaluation on **2026-08-20, game v3.3**. Verify before acting ([[feedback_verify_code_while_fixing]]). Player-visible bugs live in [[project_known_player_bugs]].

**Systemic (root causes):**
- **Global-state sprawl.** `dec.nvgt` is one flat namespace of 60+ mutable globals (economy counters, positions, timers, sound pools, per-cup recipe arrays). Save/load, inventory, NPCs, and map all mutate it directly; there is no world/scene object. Root cause behind most latent bugs. Longer-term: group into a few state structs.
- **Recursion-as-navigation.** The whole menu tree (`menus/*.nvgt`) navigates by direct mutual recursion that never unwinds (main→docks→back→main→…). Every transition pushes a live stack frame for the session → unbounded growth + stale locals. Should be a menu loop / state machine.
- **Silent parser failure is the dominant pattern.** Missing config file → empty data (no log/alert); malformed line → skipped; unknown expr token → 0; unknown store id → priced at 0. `load_config()` (extrafuncts) runs every loader with no success check. Modder typos produce a subtly broken game with zero diagnostics. See [[project_data_driven_config]].

**Duplication (biggest maintainability drag):**
- The four store parsers (`single_ingredient`, `bundle_ingredient`, `single_poster`, `bundle_poster`) share a near-identical copy-pasted group-header-vs-data-row block; the same eq/colon detection is repeated a 5th time in customer speeches.
- The four store menus (`buybmenu`/`buysmenu`/`postersmenu`/`posterbmenu`, ~370 lines) are near-identical copies — this is what let the missing-`return` bug diverge between copies.
- The `set_disallowed_chars` whitelist string is pasted ~7 times and the variants disagree (`menu.nvgt:298` has stray backticks / missing `#` vs `:434`/`:629`). Hoist to one constant.

**Latent bugs (not yet player-visible):**
- `eval_amount` (extrafuncts ~:107) has **no operator precedence** — left-to-right only. `5*level*day` works by luck; `100+level*day` computes wrong. Combined with `random(min,max)` in `main_event.nvgt` (~:56) having no `min<=max` guard, a bad expression can invert the range.
- `stn` (extrafuncts ~:210) parses `random(a,b)` and indexes `[1]` with no length check → `random(5)` (no comma) crashes.
- `getitem()` (inventory ~:218) indexes `get_keys()[invpos]` guarded only against empty size, not `invpos` range (starts at `-1`); `useitem`/`cycle_inv` guard it, `getitem` doesn't.
- `update_passers` (passerby ~:134) uses `uint i` with `i--` after `remove_at(0)` → underflow to UINT_MAX, correct only because the `for` `i++` wraps it back.
- `format_template` (extrafuncts ~:51) re-searches from the start after each replace → infinite-loop if a replacement value contains a placeholder; safe only because values are numeric today.
- `keyhook.uninstall()` (`keyhook.nvgt:14`) is guarded on `!already_installed`, so it can never uninstall a hook it installed (inverted logic).
- `load_map` (`map.nvgt` ~:65) rewrites a plaintext map encrypted **in place on load** — a surprising side effect in a data-load path.
- Uninitialized sound slots default to `0`, not `-1` (`dec.nvgt:25` alertslot/tileslot/wallslot, `npc.nvgt:17` soundslot). `sound_source` correctly uses `-1`; if `0` is ever a valid handle, a pause/destroy on an uninitialized slot hits an unrelated sound.

**Performance smells:**
- `gmt(x,y)` and `get_zone_at()` do full linear scans of all platforms+walls (last-match wins) and run every step of every NPC/passer.
- Config files re-read from disk multiple times per load (`main.table` 3×, `customers.table` 4×) — each section loader opens the file independently.

**Style/consistency:**
- Three overlapping dialog idioms used side by side — `custom_menu m`, `virtual_dialogs vd`, and raw `audio_form form` (in `infomenu`, which also pauses only NPC pools and has no Escape exit).
- Menu sound cleanup is lazy: `update_sound_pools()` isn't called inside `m.run()`'s loop, so finished one-shot menu SFX linger until the next `play_stationary` (not a leak, just latency).

Do NOT touch the vendored deps when fixing these — `form.nvgt`, `sound_pool.nvgt`, `speech.nvgt`, `bgt_compat.nvgt`, `instance.nvgt`, `rotation.nvgt` are NVGT stdlib and `virtual_dialogs.nvgt` is Hamza Ahmad's; `custom_menu.nvgt`, `dlg.nvgt`, `keyhook.nvgt`, `savedata.nvgt`, and `menus/*.nvgt` are project code. See [[project_include_tree]].
