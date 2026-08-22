---
name: project_plan_rewarding_talk
description: "Agreed but UNIMPLEMENTED design (Direction B, type-specific payoffs) for making talking to customers sometimes rewarding instead of only neutral-or-negative. Decided 2026-08-21."
metadata:
  node_type: memory
  type: project
---

Plan for the todo item **"Make talking to a customer sometimes calm them down or improve their patience."** Direction chosen by the dev on **2026-08-21: Direction B (type-specific payoffs).** **Not yet coded.** From the [[project_design_feedback]] talking bullet. Stays config-driven per [[project_data_driven_config]]. **Coordinate the "calm a mean/critic" piece with [[project_plan_mean_customer_consequences]] — design that mechanic once across both items.**

## Baseline (how talk works today)
- Talk handler `customer.nvgt:631–661`: **Talk** speaks the next scripted line (escalates by mood: happy→fine→restless→angry), does `talk_count++`, returns to menu. At the per-type limit (`get_talk_limit`, 2–5 lines, from `customers.table`) the customer **walks off angry** + rep loss `1.0 + daynumber/10` (`:645`).
- Talking touches **nothing else** — not patience, tip, mood, or reaction. Purely neutral or negative, so a rational player never talks.
- Plug-in points: **tip chance** is computed at serve (`~:448–458`, already type-modified, e.g. nice +30); **patience** is a spawn-time `patiencetimer` vs `patience`; mood = the current speech line's mood tag.

## Chosen design — Direction B (type-specific payoffs)

**Core — rapport → tip/rep bonus.** Polite exchanges *below* the anger limit build rapport; rapport converts to a tip-chance bonus (+ small rep gain) when you serve that customer. Overtalking still triggers the existing walk-off + rep loss. Simplest impl reuses `talk_count` (bonus = `talk_count × per-type rate`, capped) rather than adding a new field.

**Per-type behavior (the "type-specific" part):**
- **Chatters — elderly, nice, returning:** each talk adds a *larger* rapport bonus and they tolerate more chatting (higher talk limit); a warm spoken line ("the elderly customer beams at the conversation"). Serving after a chat → notable tip boost + small rep.
- **Prickly — mean, critic:** no rapport, reach anger faster (lower limit), BUT a small per-talk **calm chance** (config) — for **mean**, a calmed customer stops being auto-bad/no-tip and behaves like a normal customer (drink decides outcome, tip possible); for **critic**, calming lowers refuse chance / softens the review threat. This is the risky-but-rewarding path. (Calm mechanic ⇄ mean-consequences item.)
- **Everyone else — normal, desperate, charitable, child, group:** mild rapport (small tip bonus).
- **Thief:** no special talk effect (recommended).

**Where it plugs in:** rapport accrues in the talk handler (`:656–658`); tip bonus applied at serve (`~:448–458`); per-type talk limits already live in `customers.table`. Calming needs a new per-customer flag (e.g. `bool calmed`) on the customer class.

**Config:** a new `[talk]` section (or extend an existing customers.table section) — per-type rapport/tip rate, calm chance, and the walk-off behavior; reuse existing talk limits.

**Accessibility (load-bearing):** every rapport gain and every calm event MUST be spoken (e.g. "The mean customer's scowl softens a little."). Unspoken = invisible to the player.

## Open sub-decisions to confirm before coding
1. Exact numbers: rapport-per-talk, tip-chance scaling, calm chances, per-type talk limits.
2. Whether chatter types also get a small **patience extension** (a Direction-C borrow) or stay tip/rep only — recommend tip/rep only, keep it clean.
3. Precisely how "calm mean" meshes with the mean-customer redesign — resolve when planning [[project_plan_mean_customer_consequences]].
