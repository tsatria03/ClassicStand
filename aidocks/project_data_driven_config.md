---
name: project_data_driven_config
description: "cst/data/config/ (events/, stores/, tables/) is plain-text, modder-tunable; parsers in main/parsers/ load it. readme.txt is the format reference."
metadata:
  node_type: memory
  type: project
  originSessionId: 9c2aa66a-3d36-4ec3-8742-42265704afb7
---

Much of ClassicStand's balance is **data-driven** via plain-text files under `cst/data/config/`, so prices, waves, events, and thresholds can be tuned without touching code. The loaders live in `src/includes/main/parsers/`.

Config layout:
- **`config/tables/`** — `main.table` (core economy/thresholds/items), `customers.table` (customer-type definitions/waves), `passers.table` (passerby definitions). Loaded by `main_table.nvgt` / `customer_table.nvgt` / `passer_table.nvgt`.
- **`config/stores/`** — `single_ingredients.store`, `bundle_ingredients.store`, `single_posters.store`, `bundle_posters.store` (shop inventories + pricing; bundle stores price off the singles). Loaded by the matching `*_store.nvgt` parsers.
- **`config/events/`** — `main.event` (random/weather events). Loaded by `main_event.nvgt`.

`main/parsers/passerby.nvgt` is the passerby entity (grouped with the parsers). The player-facing **`cst/docks/readme.txt` is the authoritative modding/format reference** — keep it in sync when you change a parser's accepted fields, and mind the dock line limit ([[feedback_dock_line_length_1024]]). Repo-root `README.md` is just a one-line stub; the real readme is the dock.
