---
name: feedback_changelog_before_verify
description: "Workflow: changelog a fix/enhancement in the same turn you implement it (don't wait for the dev to test); but only graduate the todo entry / mark memory FIXED after the dev confirms it works."
metadata:
  node_type: feedback
  type: feedback
  originSessionId: 841c7bbe-eeb5-4073-8c9a-f9730d0662d1
---

**Workflow for shipping a change (dev decision 2026-08-20):**

1. Implement the code change.
2. **Changelog it in the same turn** — write the `changelog.txt` entry (and bump `build/version.txt` if it opens a new version block) right away. Do NOT wait for the dev to test first. The dev tests as I go.
3. **Do NOT graduate the todo entry or mark memory FIXED yet.** Leave the todo item under `####Unfinished` and any `project_known_player_bugs` / design-feedback item unmarked.
4. **After the dev says "it works" / "it's fixed,"** then move the todo entry to `##Finished` (per [[feedback_todo_list_format]]) and flip the memory record to ✓ FIXED.

**Why:** the dev wants the changelog written as work happens (keeps it current, one less round-trip), but the "finished" status in the durable record (todo + memory) must reflect *verified* work only.

So: changelog = on implementation; **finished/graduated status = only after dev confirmation**. See also [[feedback_changelog_rules]].
