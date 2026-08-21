---
name: feedback_todo_list_format
description: "cst/docks/todo_list.txt conventions: two sections, ****Unfinished./**Finished. markers, newest-first ordering, Fix-vs-Make phrasing, and the graduation flow."
metadata:
  node_type: feedback
  type: feedback
  originSessionId: 841c7bbe-eeb5-4073-8c9a-f9730d0662d1
---

`cst/docks/todo_list.txt` is a player-facing dock and one of the project's durable human records (with the changelog — see [[feedback_changelog_rules]]). It has a specific structure; follow it exactly.

**Two sections, each with its own header + marker:**
- Open work under `####These are the things that need to be finished for future versions of the game.` — each entry is `****Unfinished. <one sentence>.` (four asterisks + "Unfinished.").
- Shipped work under `##These are the things that are already finished from earlier versions of the game.` — each entry is `**Finished. <one sentence>.` (two asterisks + "Finished.").

The marker asterisk counts mirror the header counts (4 up top, 2 below).

**Graduation flow:** an item is born in the top list as `****Unfinished. …`; when it is **done, verified by the dev, and changelogged** (dev rule 2026-08-20 — graduate on completion, NOT waiting for the version to release) it **moves** to the finished section and flips to `**Finished. …` (asterisks 4→2, word Unfinished→Finished; the sentence text is kept as-is). Add the newly-finished item at the **top** of the finished section (newest-first, same as the open list).

**Ordering: newest-first (dev decision 2026-08-20).** Add NEW `****Unfinished.` entries at the **top** of the open section, right under the `####` header — same reverse-chronological spirit as the changelog. (Older entries had been top-to-bottom oldest-first; the open list was reversed on 2026-08-20 to newest-first.)

**Phrasing convention (matches the file's own style):** one player-facing sentence describing the observable change, no "a bug where" (that phrasing is reserved for the changelog). Verb picks the category:
- **Bugs** → "Fix …"
- **Features / enhancements** → "Make …" / "Add …" / "Make it so …"

**No entry cap.** The open list can hold any number of entries; the per-version entry cap (10 minor / 20 major) applies to the **changelog/version block**, not here ([[feedback_changelog_rules]]).

**Why:** keeps the todo a consistent, readable record instead of something re-derived from the file each session. Keep every line within the dock line limit ([[feedback_dock_line_length_1024]]).
