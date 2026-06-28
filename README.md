# unity-scaled-linux

![license](https://img.shields.io/badge/license-MIT-blue)

Make the **Unity editor usable on a HiDPI / 4K screen under Linux** — with a
right-click *"Open in Unity (scaled)"* action in the Nemo file manager
(Cinnamon / Linux Mint).

Unity exposes no UI-scaling option on Linux. This is a tiny launcher that
applies the GTK scaling env vars Unity *does* respect, auto-detects the
correct editor version from the project, and opens it straight into the
editor (skipping the Hub).

## The problem

The *Use custom scaling value* preference exists **only on Windows**. On Linux
the editor reads the system GTK scale factor via `gtk_widget_get_scale_factor`,
which only ever returns an **integer** — so out of the box you get 1× (tiny on
4K) or 2× (often too big), with no slider and no font-size control. This has
been an open, much-bumped complaint on the Unity forums for years.

The workaround: launch the editor with `GDK_SCALE` (the integer Unity obeys)
plus `GDK_DPI_SCALE` to soften the result. That's what this does — wrapped so
you don't have to remember the incantation or hardcode your editor version.

## Install

```bash
git clone https://github.com/<you>/unity-scaled-linux.git
cd unity-scaled-linux
./install.sh
```

This installs:

- `~/.local/bin/unity-scaled` — the launcher
- `~/.local/share/nemo/actions/unity-scaled.nemo_action` — the Nemo action

Make sure `~/.local/bin` is on your `PATH` (the installer warns if it isn't).
Nemo picks up the new action immediately — no restart needed.

To remove everything: `./install.sh --uninstall`

### Manual install

If you'd rather not run the script:

```bash
install -Dm755 unity-scaled            ~/.local/bin/unity-scaled
install -Dm644 unity-scaled.nemo_action ~/.local/share/nemo/actions/unity-scaled.nemo_action
```

## Usage

**From Nemo:** navigate to a Unity project folder, right-click it, and choose
**Open in Unity (scaled)**.

**From a terminal:**

```bash
unity-scaled                    # use the current directory
unity-scaled ~/path/to/Project  # explicit project path
```

Running from a terminal is also how you see errors (wrong folder, editor
version not installed) — those go to stderr.

## Configuration

Everything is an environment variable, overridable inline without editing the
script:

| Variable | Default | What it does |
|---|---|---|
| `GDK_SCALE` | `2` | Integer widget scale Unity obeys. |
| `GDK_DPI_SCALE` | `0.5` | Softens 2× by pulling font DPI back. Try `0.5`–`0.8`. |
| `UNITY_EDITOR_ROOT` | `~/Unity/Hub/Editor` | Where Unity Hub installs editors. |
| `UNITY_ALLOW_FALLBACK` | `0` | `1` = use newest installed editor if the project's exact version isn't present. |

Example — nudge the scale down a touch:

```bash
GDK_DPI_SCALE=0.7 unity-scaled ~/path/to/Project
```

## How it works

The launcher reads `ProjectSettings/ProjectVersion.txt` to find the editor
version the project expects, locates that editor under `UNITY_EDITOR_ROOT`,
and runs it with the scaling env vars and `-projectPath`. Because the version
is read from the project, **the setup survives Unity upgrades** — there's
nothing hardcoded to maintain.

## Tested on

- Linux Mint <VERSION> (Cinnamon)
- Unity <VERSION>

*(Update these to what you've actually run. HiDPI behavior shifts between
releases, so a dated "works on X" line helps the next person.)*

## Known limitations

Integer-only scaling is an upstream **Unity** limitation, not something this
script can fix — the editor cannot do true fractional scaling on Linux
regardless of desktop settings, because it floors the GTK scale factor to an
integer. See the long-running forum thread:
<https://discussions.unity.com/t/no-ui-scaling-for-linux-you-gotta-be-joking/1638248>

If Unity ever ships the *Use custom scaling value* option on Linux, this
becomes unnecessary.

## Credits

The integer-scaling diagnosis and the `GDK_SCALE` / `GDK_DPI_SCALE` workaround
come from the Unity community forums (see the thread above). This repo just
packages it into something you can right-click.

## License

MIT — see [LICENSE](LICENSE).
