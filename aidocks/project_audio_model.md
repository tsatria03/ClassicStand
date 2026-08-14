---
name: project_audio_model
description: "sound_pool + HRTF spatial audio model and the cst/sounds/ folder layout; sounds are cwd-relative to cst/."
metadata:
  node_type: memory
  type: project
  originSessionId: 9c2aa66a-3d36-4ec3-8742-42265704afb7
---

ClassicStand has no visual output — everything is screen-reader speech plus **HRTF-spatialized audio through NVGT's `sound_pool`**. `main()` sets `sound_global_hrtf=hrtf` and calls `initialize_sound_pools()` at startup. `sound_pool` is vendored in `main/deps/` (it depends on `rotation.nvgt` for `pi`/`calculate_theta` — see [[project_include_tree]]).

**Sound assets live in `cst/sounds/`**, referenced by bare cwd-relative paths like `"sounds/misc/..."` (cwd = `cst/`, see [[project_path_conventions]]). Top-level categories:
- `ambience/` — zone/background ambience
- `dlg/` — dialog/story cues
- `keyboard/` — typing/keystroke sounds (played by the form/input backend)
- `menu/` — menu navigation
- `misc/` — general one-shots
- `platforms/` — per-surface footsteps
- `walls/` — wall/boundary cues

**Gotchas:** the preload cache replays stale audio if you reuse a filename for changed bytes — [[project_nvgt_sound_preload_cache]]. There is no swappable sound-pack system in ClassicStand (unlike ToyMania). When a new sound is needed, wire the playback code to the intended filename now; the dev adds the `.ogg` later (don't create dummy files).
