---
name: project_plan_storage_upgrades
description: "Agreed but UNIMPLEMENTED design (Direction A, per-ingredient preservation upgrades) plus a softening of the base overnight spoilage rates, to make spoilage manageable. Decided 2026-08-21."
metadata:
  node_type: memory
  type: project
---

Plan for the todo item **"Add storage or preservation upgrades the player can buy to slow water evaporation, salt clumping, and ice melting."** Chosen 2026-08-21: **Direction A (per-ingredient upgrades)** PLUS **softening the base spoilage rates** (both agreed). **Not yet coded.** From the [[project_design_feedback]] spoilage bullet ("spoilage is too fast"). Config-driven per [[project_data_driven_config]].

## Baseline (current overnight spoilage)
In `calculate_new_day_conditions` (`extrafuncts.nvgt:506–555`), on each new day where `daynumber > 1`, every perishable loses a random fraction of its **current stock** (floored), converted into a spoiled item added to inventory (recyclable). Rates are **hardcoded**:
- **Ice**: `random_float(0.5, 1.0)` — **50–100%, brutal** (stockpiling ice is impossible).
- **Lemons**: 0.1–0.3.
- **Salt**: 0.1–0.3.
- **Water**: 0.05–0.15.
Spoilage is already announced via `dlgmessage` (accessible). Melted/rotted/etc. items go to inventory to discard/recycle (existing behavior, keep).

## Chosen design

**Part 1 — soften the base rates (config rebalance).** Move the four rates out of hardcode into config (new `[spoilage]` section, min/max fraction per ingredient) and ship **softened defaults**, ice especially (e.g. down to roughly 0.2–0.4 range). Exact numbers TBD at impl. Moving them to config also enables the upgrade math and modder tuning.

**Part 2 — per-ingredient preservation upgrades (Direction A).** One permanent, saved upgrade per perishable, each **tiered I/II/III** with growing reduction:
- **Icebox** → ice
- **Pantry** → lemons
- **Sealed jars** → salt
- **Covered jugs** → water

Each owned tier multiplies down that ingredient's overnight loss fraction: in the spoilage code, `fraction *= (1 - reduction_for(ingredient))`, where the reduction comes from the owned tier (config-tunable per tier). You invest where your pain is (ice first).

**Buying them:** a shop with **one-time tier purchases** (own tier N to unlock tier N+1) — distinct from the existing ingredient/napkin/poster stores, which are quantity buys. Config-driven costs/reductions via a `.store`-style file + parser, but the parser needs an **"owned tier" concept** the current store parsers don't have.

**New state:** a per-ingredient storage tier (`ice_storage_level`, `lemon_storage_level`, `salt_storage_level`, `water_storage_level` or similar), saved in the save file, applied in the overnight spoilage loop.

**Accessibility:** overnight spoilage is already spoken; upgrade purchases confirmed by speech; the shop menu reads each upgrade's current tier and its effect.

## Open sub-decisions to confirm before coding
1. Exact softened base spoilage rates per ingredient (esp. ice).
2. Number of tiers (default I/II/III?) and each tier's reduction % and cost.
3. **Shop placement** — a new market station (like the Pricing station got x8/y25) vs a submenu in an existing market store. Decide the coordinates/name the way we did for pricing.
4. Store/parser format for **one-time owned-tier purchases** (own tier N unlocks N+1; hide/disable already-owned lower tiers).
5. Confirm all base rates move fully to config (recommended — enables both modding and the upgrade multiplier).
