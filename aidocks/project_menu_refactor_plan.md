---
name: project_menu_refactor_plan
description: "Planned v3.4 menu refactor: replace recursion-as-navigation with a loop-and-return state machine. Records why ToyMania is only a partial reference, not a finished model to copy."
metadata:
  node_type: memory
  type: project
  originSessionId: 841c7bbe-eeb5-4073-8c9a-f9730d0662d1
---

**Planned for v3.4 (not started as of 2026-08-20).** ClassicStand's menus (`src/includes/main/menus/*.nvgt`) navigate by **unbounded mutual recursion**: `mainmenu()` calls `gamemenu()` calls the next screen, and "back"/escape calls the parent function again as a NEW stack frame that never unwinds. `game()` ending also calls `mainmenu()` instead of returning. Every menu→play→menu cycle permanently piles on stack frames. This is the "recursion-as-navigation" item in [[project_known_code_issues]], and it's what let the missing-`return` fall-through in [[project_known_player_bugs]] (load/new-game slot menu) hide.

**ToyMania is only a PARTIAL reference — do not treat it as a finished model.** The sibling game `C:\Users\tonys\...\games\ToyMania` was suggested as a "fixed" example, but its menu *navigation* uses the exact same recursion (verified: `menu.nvgt` `mainmenu()→gamemenu()→…`; `game.nvgt:~1268` does `mainmenu();` instead of returning). The confusion came from ToyMania's own memory files, which mention `while(true)` menus but for three UNRELATED things:
- `project_angelscript_while_true_return.md` — a compile-quirk note (a `while(true)` function needs a trailing unreachable `return`); its example is `choose_difficulty`.
- `project_game_unlock_plan.md` — `choose_difficulty()` "re-prompts on locked pick" = a loop INSIDE one screen, not navigation between screens.
- `project_player_facing_bugs.md` — marked FIXED v5.2, but that fix is a cross-mode **state-reset** bug (`reset_game_state()` helper), nothing to do with the call stack.

So neither game has a finished menu state machine. There is nothing to copy wholesale.

**The good primitives worth generalizing (present in ToyMania):**
- `choose_difficulty()` (`ToyMania/.../menu.nvgt:276-300`) — the one function that **loops and returns a typed result** (`return -1` on back/escape, `return chosen` on success, `continue` to re-prompt) instead of calling the next screen. The caller decides where to go.
- The in-game overlay menus (pause/inventory/etc.) that `return` back into `toygame()`'s `while(true)` loop — a stack-neutral handoff.
- Both games already share `custom_menu.run()`'s good contract: "one screen = one blocking loop that returns an int (1-based index, or -1 on escape)."

**Target design for ClassicStand 3.4:** hoist navigation into a single top-level `while` loop where each screen function returns a "next screen" value (or use an explicit screen stack); make `game()` **return** a result to that loop instead of calling `mainmenu()`. Generalize `choose_difficulty`'s loop-and-return discipline to every screen; keep reusing `custom_menu.run()`'s int contract. Remember the AngelScript `while(true)`+trailing-`return` compile quirk when writing the loop bodies. Do NOT copy ToyMania's function-calls-function navigation, its `toygame→mainmenu()` handoff, or its single shared global `m` that nested menus stomp.
