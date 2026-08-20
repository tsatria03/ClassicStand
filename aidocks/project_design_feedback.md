---
name: project_design_feedback
description: "Design/balance suggestions (NOT bugs) from a blind player's 2026-08-20 feedback on v3.3: recipe-feedback clarity, ingredient roles, spoilage pacing, talking, pricing, posters, and UX polish."
metadata:
  node_type: memory
  type: project
  originSessionId: 841c7bbe-eeb5-4073-8c9a-f9730d0662d1
---

Design and balance ideas from real **player feedback (2026-08-20, v3.3)** by a blind player who praised the game's depth and accessibility. These are **suggestions, not bugs** — nothing here is scheduled or decided yet. Confirmed bugs from the same feedback (cups, spoiled-item wipe, serve-all groups) are in [[project_known_player_bugs]]; the menu refactor is [[project_menu_refactor_plan]].

**Recipe / ingredients:**
- **Quality feedback is confusing because it's ratio-based.** `get_customer_feedback` judges on ratios, so lowering one ingredient raises the others' ratios and triggers "too sweet/too sour" even though you *reduced* something — the player can't tell whether sugar or lemons specifically need adjusting. Consider naming the offending ingredient, or moving away from a pure-ratio model.
- **Salt and ice feel inert.** They only ever produce "too salty/too icy" complaints — no upside. Player's principle: every ingredient should give both a benefit and a drawback.
- **Spoilage is too fast.** Water evaporation, salt clumping, and ice melting happen so quickly they're hard to manage. Suggested fix: purchasable storage / preservation upgrades to slow the effects.

**Customers:**
- **Talking is almost always negative.** `talk_count` escalates to bored/angry and a walk-off with a rep penalty; there's no calming/patience-improving outcome. Player wants talking to sometimes calm a customer or raise patience.
- **Rude-customer consequences feel absent.** Mean customers do have effects (always complain, never tip) but they're subtle/unsignposted; the game implies bigger consequences than the player perceives.
- **Napkin / greeter rework.** Rather than a greeter permanently standing at the stand delivering help text, move that help into a tutorial / help system / README backstory, and make **napkins a purchasable supply** like other inventory. (Overlaps the napkin-persistence bug and the greeter's permanent-text coupling noted elsewhere.)

**Economy / balance:**
- **Posters feel pointless next to the viral bonus.** The `lucky_bonus` event pays `100–500 × level × day` cash, dwarfing poster value and letting players handle huge waves without marketing. Rebalance one against the other.
- **Per-cup and per-group pricing.** Groups should pay per cup (ties to the confirmed serve-all bug). Player also wants the option to set different prices for different customer groups — e.g. discounts for children or the elderly. **NOT config-possible today** (checked 2026-08-20): selling is a single global `selling_price` applied uniformly (`customer.nvgt:349`); the only per-type price difference is HARDCODED (desperate ×1.5, child ×0.6, `customer.nvgt:350–351`); `customers.table` has no price field and the `.store` files are buy-costs only. Split into two todo entries: (1) **config path (small lift)** — add a per-type `price_multiplier` column to `customers.table` mirroring the existing `[movements]` multipliers, and drive the hardcoded desperate/child numbers from it so modders can set group discounts without code; (2) **player-facing feature (real code)** — a runtime UI to set per-group prices, applied in both serve and serve-all (depends on the serve-all group bug being fixed first).
- **Day segments feel too short.**

**UX / audio polish:**
- **Movement friction.** Tile-based movement forces constant coordinate re-checking to reposition; the action station and customer counter feel farther apart than necessary, slowing the loop. **DESIGN NOTE ONLY — deliberately NOT added to the todo (dev decision 2026-08-20).** Reason: the player gave no concrete target for how close the two stations should be. The layout IS measurable now: the pre-encryption plaintext map was recovered from git (blob `0640b06`, 50×50, matches current dims — see [[project_save_data_layout]]). Actual geometry — actions station `menu 2 6 19 31 actsmenu` (far west of the stand), customer counter tile (14,25) (east edge); the stand spans x0–15,y18–32, so the two are ~8 tiles apart at opposite ends of the same building. If revisited: (a) station spacing is a small map edit (e.g. shift the `actsmenu` rectangle east toward x8–12, or nudge the counter west); (b) the "constant coordinate re-checking" half is broader navigation UX and would be code (e.g. an objective audio beacon), not a tile move.
- **The next-cycle clock sound is too loud and repetitive.** The **loudness** is an asset-only fix the dev owns — lower the gain and re-export the .ogg, no code change (mind the filename-based preload cache when overwriting: [[project_nvgt_sound_preload_cache]]). The **"repetitive"** part is NOT a code loop: `timestart.ogg` and `timestop.ogg` are one-shot `p.play_stationary(..., false)` cues fired once at each wave start/end (`customer.nvgt:885` / `:967`); there is no looping tick anywhere. What the player perceived is just frequency — you hear the start/stop pair up to ~6 times per day (once per period), which is why they bundled it with "segments feel quite short." **Dev decision (2026-08-20): keep it — the cue is intentional as a shift start/end marker, so the repetition is by design (effectively wontfix). Only the volume asset tweak remains.**

Overall the player called it a rare, impressively deep, genuinely accessible audio business sim — the items above are refinements, not complaints about the core.
