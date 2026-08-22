---
name: project_plan_mean_customer_consequences
description: "Agreed but UNIMPLEMENTED design (Direction B, social ripple, fully config-tunable) for giving mean customers consequences the player actually feels, with talk-calming as the counterplay. Decided 2026-08-21."
metadata:
  node_type: memory
  type: project
---

Plan for the todo item **"Make rude and mean customers have consequences the player actually feels."** Direction chosen by the dev on **2026-08-21: Direction B (social ripple), fully config-tunable.** **IMPLEMENTED & confirmed working 2026-08-22 (v3.6)** — includes the calm mechanic deferred from [[project_plan_rewarding_talk]]. From the [[project_design_feedback]] rude-customer bullet. The calm counterplay is shared with [[project_plan_rewarding_talk]] — designed once here. Config-driven per [[project_data_driven_config]].

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

## Decisions & sub-decisions
- **Calm mechanic — DECIDED 2026-08-22:** applies to **mean only** (critic and the rest excluded — not hostile). **Config-tunable calm chance** (~25% per chat default; 0 disables). A **calmed** mean becomes **fully normal** (forced-bad and zero-tip both drop; a good drink satisfies them, tip possible). Every calm spoken. Calm is triggered by the existing Talk option; ships here (the talk feature deferred it).
- **Un-calmed mean — DECIDED 2026-08-22: Option A (stays forced-bad).** Even a perfect drink gets a grumble; calming is the ONLY way to a good outcome.

## Teeth + ripple — DECIDED 2026-08-22 (all in a new `customers.table [mean]` section)
- **Teeth:** un-calmed mean **refuses to pay** (pay-anyway exemption removed — the extreme-spill refund now applies to everyone); **keeps the cup** on a normal refusal, only a genuinely extreme drink spills it; **rep hit ×2** (`rep_multiplier=2`).
- **Ripple:** fires on a bad mean interaction — **both** a refuse-to-pay serve AND a walk-off (patience/anger). Toggle `ripple_enabled` (default on). Each *other* waiting customer loses **5 sec** patience (`ripple_patience=5`); small immediate **−2** rep dip (`ripple_rep=2`); scope = **all waiting** (exclude thieves); spoken cue "The mean customer loudly badmouths your stand as they storm off; the other customers look impatient."
- Config keys: `calm_chance=25`, `rep_multiplier=2`, `ripple_enabled=1`, `ripple_patience=5`, `ripple_rep=2`. New per-customer field `bool calmed`.
