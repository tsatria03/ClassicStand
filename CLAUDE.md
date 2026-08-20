# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository. **It is a lean dispatcher:** it orients you to what the project is and its shape, then points to focused memory files (`[[name]]`) for the deep detail. When you start work in an area, read its linked memory first.

**Memory location:** all memory files (`[[name]]` links and the `MEMORY.md` index) live in the repo's **`aidocks/`** directory (`aidocks/<name>.md`). Read memory from there, and write any new or updated memory there — not the `~/.claude` memory store. `aidocks/MEMORY.md` is the index; add a one-line pointer there for every new memory. Keep this file under 40,000 chars — move detail into memory ([[feedback_claudemd_length]]).

## What this is

ClassicStand is an audio-only (blind-accessible) **business/economy simulation** written in **NVGT** (Non-Visual Game Toolkit, an AngelScript-based engine). All code is `.nvgt`. There is no visual rendering — output is screen-reader speech plus HRTF spatial audio through NVGT's `sound_pool`.

You run a childhood **lemonade stand**: walk the neighborhood, buy ingredients, mix/pour lemonade to a quality recipe, serve a live wave of customers, keep reputation up (0–200; **0 is game over**), and earn money across days split into 6 time-of-day levels. Single-player, single-instance — no multiplayer. Full picture and the load-bearing systems: **[[project_game_vision]]**. Much of the balance is data-driven and modder-tunable: **[[project_data_driven_config]]**.

## Layout — code and assets are split

- **`src/`** — code only. Entry `src/cst.nvgt`, plus `src/includes/` (`includes.nvgt`, `version.nvgt`, and the `main/` subtree).
- **`cst/`** — runtime assets + launcher: `cst/cst.py`, `cst/data/` (`config/`, `maps/`), `cst/docks/`, `cst/sounds/`.
- **`build/`** — build/release pipeline (`tools.py` via `tools.bat`; `tools.ini`; `version.txt`). **`releases/`** — compiled output (gitignored).
- **`aidocks/`** — this project's memory folder (committed). "Memory" always means this folder.

**The cwd trick:** `cst/cst.py` runs `../src/cst.nvgt` through NVGT but sets **cwd = `cst/`**, so bare `data/…`, `sounds/…`, `docks/…` strings resolve under `cst/`, while `#include"includes/…"` resolves relative to the script → `src/includes/`. There are no `#pragma asset` lines; `build/tools.py` copies assets into the bundle. Full path map: **[[project_path_conventions]]**. Include architecture (the `main/{deps,functions,globals,menus,parsers}` glob tree + vendored deps): **[[project_include_tree]]**.

**Engine is pinned to the legacy fork at `C:\nvgt`** (BASS audio); upstream `C:\nvgt2` (miniaudio) is incompatible — don't target it or suggest upgrading. **[[project_engine_pinned_nvgt2]]**.

## Running & building

No test suite or linter. The game launches via `cst/cst.py` (runs `src/cst.nvgt` under `C:\nvgt\nvgt.exe`, cwd `cst/`, compile errors → `cst/errors.txt`) and is compiled/packaged/released via `build/tools.py` — but **the dev runs and builds, not Claude** ([[feedback_dont_run_or_build_the_game]]). The version source of truth is `build/version.txt`, mirrored into `src/includes/version.nvgt` on launch and compile — never hand-edit `version.nvgt` ([[feedback_update_build_version_txt]]). Full pipeline: **[[project_build_pipeline]]**.

## Where the detail lives (read before working in an area)

- **Audio / sounds** (sound_pool + HRTF, the `cst/sounds/` layout) → **[[project_audio_model]]**.
- **Save data** (AppData `tsatria03/ClassicStand/` preffs/saves/stats; encrypted map) → **[[project_save_data_layout]]**.
- **Config / modding** (the `cst/data/config/` tables/stores/events + `main/parsers/`) → **[[project_data_driven_config]]**.
- **Repo hygiene** (`.gitattributes` CRLF enforcement, gitignore) → **[[project_repo_hygiene]]**.
- **Player-facing docs** — `cst/docks/` (`changelog.txt` is the source of truth for what shipped; `readme.txt` doubles as the modding reference). Rules: **[[feedback_changelog_rules]]**, **[[feedback_dock_line_length_1024]]**.

## Compile-breakers — read before writing .nvgt (the game runs from source, so a compile error = won't launch)

- **[[project_angelscript_braceless_if]]** — a braceless branch holds only one statement; a second orphans the `else`.
- **[[project_angelscript_reserved_words]]** — don't name a variable `out` (or in/inout/shared/final/from…).
- **[[project_nvgt_key_pressed_oneshot]]** — read a multi-purpose key once and branch inside, never two sibling ifs on the same key.
- **[[project_nvgt_sound_preload_cache]]** — a reused filename replays the old cached clip; use a fresh name or `allow_preloads=false`.

## Working style (follow these)

- **[[feedback_confirm_before_implementing]]** — a design discussion or a `?` is a request for a plan, not a green light. Wait for explicit go-ahead.
- **[[feedback_ask_one_question_at_a_time]]** — one question per turn, then wait.
- **[[feedback_list_modified_files]]** — end every editing turn with a bare-filename "Files changed:" list, then a relaunch note.
- **[[feedback_verify_code_while_fixing]]** — re-locate by symbol, confirm the finding is true, flag adjacent bugs.
- **[[feedback_check_git_log_for_commits]]** / **[[feedback_stage_commits_before_big_changes]]** — the dev commits their own work; check state, don't commit unless asked, flag break points before risky stages.
- **[[feedback_one_sentence_game_messages]]**, **[[feedback_menus_say_canceled]]**, **[[feedback_yes_no_menu_labels]]** — in-game/UI conventions.
- **[[feedback_multiline_comment_style]]**, **[[feedback_dont_flag_indentation]]**, **[[feedback_no_crlf_normalization]]** — smaller standing rules.

Repo-root `README.md` is a one-line stub; the real readme is `cst/docks/readme.txt`. `CLAUDE.md` and `aidocks/` are committed (not gitignored).
