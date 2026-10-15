#!/usr/bin/env bash
# Copy the VS Code light dashboard theme and TUI skin into Hermes, then select them.
# Works from a git clone, or via: curl -fsSL <raw install.sh> | bash
set -euo pipefail

HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
REPO="${HERMES_THEMES_REPO:-r4ym0n/hermes-themes}"
REF="${HERMES_THEMES_REF:-main}"
RAW="https://raw.githubusercontent.com/${REPO}/${REF}"

if [[ -n "${BASH_SOURCE[0]:-}" && -f "${BASH_SOURCE[0]}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
else
  SCRIPT_DIR=""
fi

fetch() {
  local rel="$1"
  local dest="$2"
  if [[ -n "$SCRIPT_DIR" && -f "${SCRIPT_DIR}/${rel}" ]]; then
    cp "${SCRIPT_DIR}/${rel}" "$dest"
  else
    curl -fsSL "${RAW}/${rel}" -o "$dest"
  fi
}

mkdir -p "${HERMES_HOME}/dashboard-themes" "${HERMES_HOME}/skins"
fetch "dashboard/vscode-light.yaml" "${HERMES_HOME}/dashboard-themes/vscode-light.yaml"
fetch "skins/vscode-light.yaml" "${HERMES_HOME}/skins/vscode-light.yaml"

if command -v hermes >/dev/null 2>&1; then
  hermes config set dashboard.theme vscode-light
  hermes config set display.skin vscode-light
else
  echo "hermes was not found. Files were copied. Set dashboard.theme and display.skin to vscode-light yourself."
fi

python3 - "${HERMES_HOME}/hermes-agent/hermes_cli/web_server_dashboard.py" <<'PY'
import sys
from pathlib import Path
path = Path(sys.argv[1])
marker = 'for key in ("terminalBackground", "terminalForeground"):'
if not path.is_file():
    print(f"Did not find {path}. Skipped the terminal color patch.")
    raise SystemExit(0)
text = path.read_text()
if marker in text:
    print("Terminal color patch is already present.")
    raise SystemExit(0)
needle = '''    if component_styles:
        result["componentStyles"] = component_styles
    return result'''
insert = '''    if component_styles:
        result["componentStyles"] = component_styles
    for key in ("terminalBackground", "terminalForeground"):
        if _nonempty_str(data.get(key)):
            result[key] = data[key].strip()
    return result'''
if needle not in text:
    print("The Hermes theme loader did not match the expected code. Skipped the terminal color patch.")
    raise SystemExit(0)
path.write_text(text.replace(needle, insert, 1))
print("Hermes will now pass the theme terminal background and foreground through. Restart the dashboard to pick it up.")
PY

echo "Installed. Refresh the dashboard to use VS Code Light. Start a new chat before the terminal skin changes."
