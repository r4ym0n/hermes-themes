# Hermes Themes

English · [中文](README.zh-CN.md)

Themes for [Hermes Agent](https://github.com/NousResearch/hermes-agent).

The themes that ship with Hermes are dark. Too dark. If you want it brighter, this is the one.

Right now there is one pack: classic VS Code Light.

| File | What it does |
| --- | --- |
| `dashboard/vscode-light.yaml` | Web dashboard. Gray sidebar, white content, `#007ACC` blue buttons, light terminal. Shown as **VS Code Light**. |
| `skins/vscode-light.yaml` | The interface Hermes paints inside the terminal: blue status bar, blue accents, red and green status colors. |

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/r4ym0n/hermes-themes/main/install.sh | bash
```

From a local clone:

```bash
./install.sh
```

The script copies both YAML files into `~/.hermes/dashboard-themes/` and `~/.hermes/skins/`, then selects `vscode-light`.

Refresh the dashboard after that. A chat that is already open keeps the old skin. Start a new one and the terminal turns light.

## Manual install

```bash
mkdir -p ~/.hermes/dashboard-themes ~/.hermes/skins
cp dashboard/vscode-light.yaml ~/.hermes/dashboard-themes/
cp skins/vscode-light.yaml ~/.hermes/skins/
hermes config set dashboard.theme vscode-light
hermes config set display.skin vscode-light
```

You can also leave the config alone. After signing in, pick **VS Code Light** from the palette in the top bar, and run `/skin vscode-light` in the terminal.

## Terminal background

The dashboard terminal turns light only when the theme includes `terminalBackground` and `terminalForeground`. Hermes 0.21.5 drops those two fields. `install.sh` patches `~/.hermes/hermes-agent/hermes_cli/web_server_dashboard.py` so they are passed through. Restart the dashboard afterward:

```bash
hermes dashboard --host 127.0.0.1 --port 9119 --no-open
```
