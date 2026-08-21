---
name: feedback_changelog_rules
description: "cst/docks/changelog.txt is a player-facing record of what changed: prose, reverse-chronological, bump version.txt with each block; entry cap per version (10 minor / 20 major)."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 9c2aa66a-3d36-4ec3-8742-42265704afb7
---

`cst/docks/changelog.txt` is the source of truth for what shipped, and it is a **record of what changed, not a manual**. Player-facing prose, one idea per entry, reverse-chronological (newest block on top). Each new version block pairs with a bump of `build/version.txt` to the same number (see [[feedback_update_build_version_txt]]).

**Entries per version (dev rule):** a **minor** version (the middle number bumps, e.g. 3.4, 3.5) ships **at most 10** changelog entries; a **major** version (the leading number bumps, e.g. 4.0) ships **at most 20**. Scope each release's changelog block to that cap. This cap is on the changelog/version block only — the `todo_list.txt` open list has **no** entry limit ([[feedback_todo_list_format]]).

**Why:** Players read the changelog; engine internals, file names, and how-to instructions don't belong there. The changelog + `todo_list.txt` are the durable human record of the project's evolution.

**How to apply:** Describe the observable change in a sentence or two. Trust the changelog over the readme/todo when they disagree. Keep lines within the dock line limit ([[feedback_dock_line_length_1024]]).
