---
name: project_plan_rewarding_talk
description: "Agreed but UNIMPLEMENTED design (Direction B, type-specific payoffs) for making talking to customers sometimes rewarding instead of only neutral-or-negative. Decided 2026-08-21."
metadata:
  node_type: memory
  type: project
---

Plan for the todo item **"Make talking to a customer sometimes calm them down or improve their patience."** Direction chosen by the dev on **2026-08-21: Direction B (type-specific payoffs).** **IMPLEMENTED & confirmed working 2026-08-22 (v3.6)** — rapport→tip and chatter patience extension shipped. The **calm-a-prickly-type** sliver was deliberately deferred and ships WITH [[project_plan_mean_customer_consequences]] (next). From the [[project_design_feedback]] talking bullet. Stays config-driven per [[project_data_driven_config]]. **Coordinate the "calm a mean/critic" piece with [[project_plan_mean_customer_consequences]] — design that mechanic once across both items.**

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

## Decisions & sub-decisions
- **Reward type — DECIDED 2026-08-22: Option 2 (tip/rep + patience extension for chatters).** Chatting builds rapport → tip-chance bonus at serve, AND chatting a chatter type EXTENDS their patience (they wait longer while you go make their drink).
- **Prerequisite fix SHIPPED 2026-08-22 (v3.6):** patience now PAUSES while the serve menu / talk dialogs are open (mirrors the NPC-sound pause in `open_serve_menu`; helpers `pause_waiting_patience`/`resume_waiting_patience`), and only runs while you're away (actions station, market). This means talking no longer secretly drains patience, so the Option-2 extension is a pure bonus. (Was a standalone fairness bug — its own changelog entry.)
- **Calm mechanic — DEFERRED to [[project_plan_mean_customer_consequences]].** For the talk feature itself, prickly types (mean/critic) simply get no rapport; the calm chance (trigger + calmed-behavior effect) ships WITH the mean feature, since the effect needs the mean redesign. Talk + mean still land in the same version.
- **Numbers & groupings — DECIDED 2026-08-22** (all magnitudes in a new `[talk]` config section, in seconds for the patience values; groupings in code, documented). Chatters = **elderly, nice, returning**: tip **+5/chat, cap +15**; patience **+5s/chat, cap +20s**. Mild = **normal, desperate, charitable, child, group**: tip **+5/chat, cap +10**; no patience. (Caps revised down 2026-08-22.) Prickly = **mean, critic**: nothing (calm arrives with mean). **Thief** excluded. Rapport tip bonus applies only in the good-drink branch (both serve and serve-all); patience extension raises the customer's `patience` threshold. Tip-chance only (no separate rep gain). Every rapport/patience gain must be spoken.
