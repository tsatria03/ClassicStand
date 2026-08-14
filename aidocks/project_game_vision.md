---
name: project_game_vision
description: "ClassicStand is an audio business sim: run a childhood lemonade stand — serve customers, manage a recipe, reputation, and money across timed days."
metadata:
  node_type: memory
  type: project
  originSessionId: 9c2aa66a-3d36-4ec3-8742-42265704afb7
---

ClassicStand is an audio-only **business/economy simulation**: you run a childhood **lemonade stand** in a navigable neighborhood. Core loop — walk the map, buy ingredients at the market, mix/pour lemonade to a quality recipe, serve a live wave of customers, keep reputation up, and earn money across **days divided into 6 time-of-day levels**.

**Load-bearing systems (the game's identity — don't casually break these):**
- **Customers:** ~11 distinct types (Normal, Nice, Mean, Desperate, Charitable, Group, Returning, Critic, Elderly, Child, Thief), each with its own patience, movement speed, dialogue, and reactions. Customer/NPC/passerby share a common base class (`main/globals/`).
- **Recipe/quality:** per-cup ingredient variation with balance thresholds (sour/sweet/watery/salty/icy) driving two-tier reactions — a verbal complaint vs. a full tantrum with a spill.
- **Reputation:** 0–200, starts at 100; **hitting 0 is game over.** Drives tipping and price sensitivity.
- **Economy/marketing:** dynamic pricing, poster marketing (place up to 10 posters to grow waves), passerby pedestrians, weather-driven random events, ingredient spoilage overnight, napkin/spill cleanup.
- Multiple save slots; single-player, single-instance (no multiplayer/networking).

Most of these numbers/waves/thresholds are **data-driven** and tunable without code — see [[project_data_driven_config]]. The player-facing docks (`cst/docks/`) double as a modder reference. It's a solo hobbyist project; expect occasional spelling quirks in changelog/in-game text.
