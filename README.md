# Hermes 主题

给 [Hermes Agent](https://github.com/NousResearch/hermes-agent) 用的外观。目前有一套经典 VS Code 浅色。

| 文件 | 作用 |
| --- | --- |
| `dashboard/vscode-light.yaml` | Web 控制台。灰侧栏、白内容区、`#007ACC` 蓝按钮，终端窗口白底黑字。 |
| `skins/vscode-light.yaml` | 终端里 Hermes 自己画的界面：蓝状态栏、蓝强调、红绿警告。 |

## 安装

```bash
curl -fsSL https://raw.githubusercontent.com/r4ym0n/hermes-themes/main/install.sh | bash
```

已经克隆到本地时：

```bash
./install.sh
```

脚本会把两个 YAML 复制到 `~/.hermes/dashboard-themes/` 和 `~/.hermes/skins/`，并把当前主题设为 `vscode-light`。

然后刷新 Dashboard。已经开着的 Chat 还是旧皮肤，新开一轮才会换成浅色终端。

## 手动安装

```bash
mkdir -p ~/.hermes/dashboard-themes ~/.hermes/skins
cp dashboard/vscode-light.yaml ~/.hermes/dashboard-themes/
cp skins/vscode-light.yaml ~/.hermes/skins/
hermes config set dashboard.theme vscode-light
hermes config set display.skin vscode-light
```

也可以不改配置，登录 Dashboard 后在顶栏调色板里选「VS Code 浅色」，终端里用 `/skin vscode-light`。

## 终端底色

Dashboard 的终端窗口只在主题定义里带有 `terminalBackground` 和 `terminalForeground` 时才会变浅色。Hermes 0.21.5 默认会丢掉这两个字段。`install.sh` 会在本机的 `~/.hermes/hermes-agent/hermes_cli/web_server_dashboard.py` 里补上传递，然后需要重启 dashboard：

```bash
hermes dashboard --host 127.0.0.1 --port 9119 --no-open
```
