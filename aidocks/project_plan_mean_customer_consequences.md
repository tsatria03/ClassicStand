---
name: project_plan_mean_customer_consequences
description: "Agreed but UNIMPLEMENTED design (Direction B, social ripple, fully config-tunable) for giving mean customers consequences the player actually feels, with talk-calming as the counterplay. Decided 2026-08-21."
metadata:
  node_type: memory
  type: project
---

Plan for the todo item **"Make rude and mean customers have consequences the player actually feels."** Direction chosen by the dev on **2026-08-21: Direction B (social ripple), fully config-tunable.** **Not yet coded.** From the [[project_design_feedback]] rude-customer bullet. The calm counterplay is shared with [[project_plan_rewarding_talk]] — designed once here. Config-driven per [[project_data_driven_config]].

## Baseline (how mean customers work today — the problem)
- `bad = true` is **forced** for mean regardless of drink quality (`customer.nvgt:368`).
- Yet the bad outcome is toothless: they **pay `earned` anyway** ("they pay you and storm off", `:426`), and mean is **explicitly exempt from the cash/sold-cup loss** even on an extreme spill (`:413`, `if(ctype != "mean")`). Only cost is the small non-extreme rep hit `0.5 + daynumber/20` (`:430`); `tip_chance = 0` (`:451`, moot). Only real bite is overpricing (1.5× refuse).
- Net: a mean customer is *less* punishing than a normal customer served a genuinely bad drink (who refuses to pay AND costs more rep). Hostility is pure flavor. Dev confirmed 2026-08-21 the pay-anyway feels unrealistic and wants it gone.

## Chosen design — Direction B (social ripple), all knobs config-tunable, start conservative

**Individual teeth:**
1. **Remove the pay-anyway exemption** (`:413`): an un-calmed mean customer served a (forced-bad) drink **refuses to pay** like anyone else — lose the cash and the sold cup.
2. **Bigger rep hit** on a bad mean interaction (tunable multiplier).
3. **Un-calmed mean stays forced-bad** even on a perfect drink (thematic: a hostile customer is determined to complain). Calming via talk is the only way to please them. (Recommended — confirm at impl.)

**Social ripple (the B part):** when a mean customer has a **bad interaction** — refuses-to-pay serve, or walks off angry (patience timeout / talk-anger) — they **badmouth the stand**: nearby **waiting** customers (not leaving, not thief) take a **patience knock** (advance their `patiencetimer` / cut `patience` by a config amount) and/or a **brief minor reputation dip**. Kept modest and tunable so a mean customer you couldn't reach doesn't nuke the wave. Spoken cue required: "The mean customer loudly badmouths your stand; the others look impatient."

**Calm counterplay (shared with [[project_plan_rewarding_talk]]):** Talk carries a per-talk **calm chance** (config) for mean; on success set `calmed=true` on the customer. A **calmed** mean: no longer forced-bad (drink decides), `tip_chance` no longer zeroed, no ripple — behaves like a normal customer (modest tip possible), making the calm worth the risk. Risk side: mean's short talk limit (2) means you can anger them first → walk-off + ripple. Spoken: "The mean customer's scowl softens; they'll give you a fair shot."

**Config:** new `[mean]` (or `[consequences]`) section in `customers.table` — `pay_on_bad` (default false), `rep_hit_multiplier`, `ripple_enabled`, `ripple_patience_ms`, `ripple_rep_dip`. Calm chance lives with the talk config. All tunable; ship conservative defaults.

**New state:** `bool calmed` on the customer class (shared with the talk plan). Ripple iterates the existing `customers` array.

**Accessibility (load-bearing):** every consequence and calm event MUST be spoken — the ripple, the refusal, the calming. Unspoken = invisible.

## Open sub-decisions to confirm before coding
1. Exact ripple magnitudes (patience-knock ms, rep dip) and rep-hit multiplier — tune conservative.
2. Ripple triggers on both refuse-to-pay-serve AND walk-off, or walk-off only? (Recommend both, single toggle.)
3. Ripple scope: all waiting customers vs proximity-limited (recommend all waiting — simpler).
4. Keep un-calmed mean forced-bad even on a perfect drink (recommend yes).
5. Calmed mean = fully normal (tip possible) vs merely servable (recommend fully normal, to reward the calm).
