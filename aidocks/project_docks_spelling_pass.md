---
name: project_docks_spelling_pass
description: "Deferred task: a spelling/grammar cleanup pass across ALL player docks in cst/docks/ (changelog, readme, todo, credits), to be done after current bug/feature work."
metadata:
  node_type: memory
  type: project
  originSessionId: 841c7bbe-eeb5-4073-8c9a-f9730d0662d1
---

**Deferred to "much later" (dev decision 2026-08-20): do a full spelling + grammar pass across every player-facing dock in `cst/docks/`, not just the changelog.** Scope: `changelog.txt`, `readme.txt`, `todo_list.txt`, `credits.txt` (and any new docks). Do this **after** the current bug/feature work is done, so it's a single clean sweep rather than piecemeal.

**Rules for the pass:**
- Fix spelling/grammar ONLY — do not reword or re-scope shipped changelog entries; they are a historical record ([[feedback_changelog_rules]]). Preserve each entry's meaning.
- Keep every line within the dock line limit and don't reflow ([[feedback_dock_line_length_1024]]); preserve line endings ([[feedback_no_crlf_normalization]]).
- Two consistent coined terms are **style decisions, not errors** — confirm with the dev before changing: **`passerbys`** (used ~a dozen times; standard "passersby") and **`recycleable`** (standard "recyclable", also in `main.table`). Leave them unless the dev opts to standardize.

**Head start — changelog.txt findings as of 2026-08-20 (v3.3), ~30 clear misspellings:** propperly→properly (L10,47,167,253); summery/summeries→summary/summaries (L233,237,250,270,272); thurst→thirst (L259,262,264); encripted→encrypted (L11,192); temprature→temperature (L257,259); spisific→specific (L203,251); suddle→subtle (L211,214); lojic→logic (L259); grater→greater (L219); quicly→quickly (L184); piture→pitcher (L195); chanse→chance (L198); intrest→interest (L203); automaticly→automatically (L206); changeing→changing (L206); sails→sales (L196). Plus wrong-word slips: weather→whether (L229,276); their→there (L210,250); it's→its (L226). (Line L259 has three in one entry.) **Re-scan all docks fresh at pass time** — line numbers drift as the dev edits, and readme/todo/credits were not fully audited.
