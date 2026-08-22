---
name: project_plan_per_group_pricing
description: "Agreed but UNIMPLEMENTED design for a runtime Pricing station: a new map menu station where the player sets per-customer-type prices (% of base, Direction A) and the base sale price, replacing the forced daily price popup. Decided 2026-08-21."
metadata:
  node_type: memory
  type: project
---

Plan for the todo item **"Add a way for the player to set different selling prices for different customer groups during play."** Chosen 2026-08-21: **Direction A (relative % of base), delivered via a new "Pricing station" map menu.** **Not yet coded.** Fulfils the "player-facing feature" half of the per-group-pricing bullet in [[project_design_feedback]] (the config half — `customers.table [prices]` — shipped in 3.5). Config-driven per [[project_data_driven_config]].

## Baseline (current pricing)
- Once per day (level 1) a forced input box sets a single global `selling_price` (`extrafuncts.nvgt:596`), bounded `[suggested_price, price_cap]`, `suggested = 25 + day*5 + level*2`, cap = suggested×4.
- `price_multiplier = chosen_price / suggested_price` — one global value driving overpricing **refuse/hesitate** (`customer.nvgt:294,746`) and **patience** (`:959,:75`).
- Serve: `earned = selling_price × cups_needed × get_customer_price_multiplier(ctype)`; the per-type multiplier is config-only today (`customers.table [prices]`, 3.5: desperate 1.5, child 0.6). Tips scale off `selling_price`.

## Chosen design

**New map station "Pricing station"** — a walk-to menu, not a daily popup. Add to the map (`neighborhood.map.src`, single tile on the y25 row between actions station and greeter):
- `menu 8 8 25 25 pricemenu`
- `zone 8 8 25 25 Pricing station. Press enter to set prices for different customer groups.`
Handler name **`pricemenu`**; zone name **"Pricing station"** (dev-approved 2026-08-21).

**Parent menu (`pricemenu`)** — two options:
1. **Customer prices** → per-type submenu.
2. **Sale price** → set the base price per cup (the former daily popup, moved here).
3. Back.

**Customer prices submenu** — lists each **purchasable** customer type (exclude **thief**), each showing its % of base and the resulting price, e.g. "Children: 60% of base, currently $0.60." Selecting a type opens an input box (same style as the old daily prompt) to enter that group's **percentage of base**; confirm spoken ("Children will now pay 60 percent of the base price, currently $0.60."). Plus **Reset all to defaults** (restore config `[prices]`) and **Back**. Display uses **"% of base"** (dev pick), not "X% off".

**Sale price submenu** — sets the base `selling_price` within the current day's `[suggested, cap]`, same validation as the old prompt.

**Day-start change:** the forced daily price input box is **removed**. The base price **carries over from the previous day, clamped into the new day's `[suggested, cap]`** (dev pick 2026-08-21 — set-and-forget; clamp prevents undercharging as the economy scales). New game seeds base = suggested. The morning **weather briefing still plays**; only the forced price box goes away.

**Under the hood:**
- `get_customer_price_multiplier(type)` reads a **runtime, saved dictionary** seeded from config `[prices]` instead of reading config directly; the Pricing station edits it; Reset pulls back to current config values. Persist in the save (and settings? — save file, since it's per-game).
- **Refuse/hesitate/patience become per-group**: computed from each group's *effective* price (base × that group's %) vs suggested, replacing the single global `price_multiplier`. A discounted group isn't seen as overpriced; a marked-up group faces more refusals + less patience — the strategic payoff.
- Applies in **both** serve and serve-all paths (the serve-all group bug was already fixed in 3.4).

**Config vs menu (relationship to document in readme):** config `[prices]` + the suggested/min/cap formula = **defaults and guardrails** (modder, global, design-time, untouched in play); the Pricing station = the **player's live prices within those limits** (per-game, saved). Config values are the starting point; Reset restores them; changing config later doesn't overwrite a save's player-set values.

**Accessibility (load-bearing):** the menu must read each group's current % and resulting price aloud; every change is confirmed by speech.

## Sub-decisions — DECIDED 2026-08-22
1. **% range: 25%–200%**, config-tunable min/max, out-of-range entries clamped with a spoken note. NOT capped to the day's price cap (refuse/patience self-limits steep markups). Must fit the config defaults (desperate 150%, child 60%).
2. **Tips stay on the base price** — a group's discount/markup affects the price they pay, not the tip (keeps tips a rep-reward, avoids markups being doubly profitable).
3. **List all 10 non-thief buying types** (normal, nice, mean, desperate, charitable, group, returning, critic, elderly, child); thief excluded. Mean stays (a calmed mean pays the set price).
4. Prompt wording = implementation detail.

## Per-group refuse/patience mechanic (implementation note)
Effective overpricing ratio for a type = `price_multiplier * get_customer_price_multiplier(type)` (since `price_multiplier = base/suggested` and the group multiplier scales it). Apply in refuse (serve) and patience (spawn, after the type is known). A discount (mult<1) makes them more patient / less likely to refuse; a markup (mult>1) the reverse.
