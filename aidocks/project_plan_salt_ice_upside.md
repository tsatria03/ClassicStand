---
name: project_plan_salt_ice_upside
description: "Agreed but UNIMPLEMENTED design (Direction 2, weather-driven) for giving salt and ice a real upside as well as their existing penalty. Decided 2026-08-21."
metadata:
  node_type: memory
  type: project
---

Plan for the todo item **"Give salt and ice a real upside as well as a downside."** Direction chosen by the dev on **2026-08-21: Direction 2 (weather-driven roles).** **Not yet coded** — this is the design to implement when we return to it. From the [[project_design_feedback]] salt/ice bullet; stays config-driven per [[project_data_driven_config]].

## Baseline (how salt & ice work today)
- The recipe splits: **lemon/sugar/water** judged by *ratio*; **salt and ice** judged by *absolute amount per cup* against flat thresholds in `main.table [thresholds]` (`salty=0.3`, `extreme_salty=1.0`, `icy=0.3`, `extreme_icy=1.0`).
- Their whole current effect is a **penalty ladder** (`get_customer_feedback`, `customer.nvgt:488–518`): below 0.3 = inert (nothing), above 0.3 = "too salty/too icy" → `bad=true` (pays, no tip, no rep gain), above 1.0 = EXTREME → refuse to pay + spill + big rep loss.
- A perfect drink today therefore has **zero** salt and **zero** ice → they're inert, which is the complaint.
- **Only** the exact "Mmm... Perfectly balanced" string is a good outcome (`bad = feedback != that string`, `:366`). The good-drink branch (after `if(bad)` at `:401`, the `else` past `:429`) computes **tip chance and rep gain** — that is where an upside bonus plugs in.
- Existing weather constants: `hot_temp=85`, `cold_temp=45` in `customers.table [waves]` (temperature drives waves/events already).

## Chosen design — Direction 2 (weather-driven)

**ICE = refreshment (weather-linked).**
- **Hot day** (`temperature > hot_temp`): a good band of ice per cup `[ice_good_min..ice_good_max]` on an otherwise-good drink → **refreshment bonus** (tip-chance boost + small rep bump) and a positive spoken line ("ice cold and so refreshing on a hot day"). The "too icy" penalty threshold is **raised** on hot days so more ice is welcome.
- **Cold day** (`temperature < cold_temp`): ice unwanted — the "too icy" threshold **drops** so even a little ice draws a complaint.
- **Neutral**: today's behavior (small ice neutral, over threshold = "too icy"); no bonus.
- Over the (weather-adjusted) too-icy threshold still = "too icy"; over `extreme_icy` still = EXTREME.

**SALT = flavor enhancer (universal + hot electrolyte).**
- A pinch in good band `[salt_good_min..salt_good_max]` on a good drink → **universal flavor bonus** (tip-chance boost) + positive spoken line ("that touch of salt makes the flavor pop").
- **Hot day**: small extra "electrolyte" bump.
- Over `salt_good_max` still = "too salty"; over `extreme_salty` still = EXTREME.

**Where the bonus plugs in:** the good-drink branch only (`bad==false`). Boost `tip_chance` by a config amount, optional small rep gain, and **append the positive note to the delicious feedback line.** Do NOT touch patience — patience is set at spawn and only matters for customers still waiting, not the one being served.

**Config (all new keys in `main.table [thresholds]`, defaults TBD at impl):** `salt_good_min/max`, `ice_good_min/max`, hot/cold ice-tolerance shift, and the tip/rep bonus magnitudes. Reuse `hot_temp`/`cold_temp`.

**Accessibility (load-bearing):** every bonus MUST be conveyed in the spoken feedback line — a blind player can't see numbers. If a bonus isn't spoken, it doesn't exist to the player.

## Open sub-decisions to confirm before coding
1. Include a **salt "rescue"** mechanic (a pinch softens a *mild*, non-extreme too_sour/too_sweet by one tier — borrowed from Direction 3), or keep salt as a pure additive bonus?
2. Exact good-band numbers and bonus magnitudes (tune during implementation).
3. Should the ice refreshment apply only to otherwise-good drinks (recommended, simpler), or partially even when the flavor base is slightly off?
