#!/usr/bin/env python3
import json
import os
import socket
import sys
import time
import glob
import html

MAX_TITLE_LEN = 15

APP_ICONS = {
    "firefox": "",
    "alacritty": "",
    "fuzzel": "",
    "thunar": "󰉋",
    "spacefm": "󰉋",
    "vscodium": "󰨞",
    "zed": "󰨞",
    "octoxbps": "󰏖",
    "btop": "󰓅",
    "default": "󰖲"
}

def get_socket_path():
    runtime_dir = os.environ.get("XDG_RUNTIME_DIR", f"/run/user/{os.getuid()}")
    sockets = glob.glob(os.path.join(runtime_dir, "mango-*.sock"))
    return sockets[0] if sockets else None

def render_client_tabs(data):
    try:
        obj = json.loads(data)
    except Exception:
        return None

    clients = obj.get("clients", [])
    visible = [c for c in clients if c.get("is_visible")]

    if not visible:
        return {"text": "", "tooltip": "No windows on current workspace"}

    spans = []
    tooltip_lines = ["Current Workspace Windows:"]

    for c in visible:
        appid = (c.get("appid") or "").lower()
        icon = APP_ICONS.get(appid, APP_ICONS["default"])
        raw_title = c.get("title") or appid or "Window"

        if len(raw_title) > MAX_TITLE_LEN:
            display_title = raw_title[:MAX_TITLE_LEN - 1].rstrip() + "…"
        else:
            display_title = raw_title

        escaped_title = html.escape(display_title)
        is_focused = c.get("is_focused", False)

        if is_focused:
            spans.append(f"<span background='#4e3330' color='#ffffff'>  {icon}  <b>{escaped_title}</b>  </span>")
            tooltip_lines.append(f"• [Active] {icon} {raw_title}")
        else:
            spans.append(f"<span background='#2d2021' color='#b5a8a2'>  {icon}  {escaped_title}  </span>")
            tooltip_lines.append(f"• {icon} {raw_title}")

    tooltip_lines.append("\nLeft-click: Cycle focus\nMiddle-click: Close window")
    text = " ".join(spans)
    return {"text": text, "tooltip": "\n".join(tooltip_lines), "class": "tabs"}

def main():
    while True:
        sock_path = get_socket_path()
        if not sock_path or not os.path.exists(sock_path):
            time.sleep(1)
            continue

        try:
            s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
            s.connect(sock_path)
            s.sendall(b"watch all-clients\n")
            buffer = ""

            while True:
                chunk = s.recv(4096)
                if not chunk:
                    break
                buffer += chunk.decode("utf-8", errors="replace")
                while "\n" in buffer:
                    line, buffer = buffer.split("\n", 1)
                    line = line.strip()
                    if not line:
                        continue
                    res = render_client_tabs(line)
                    if res:
                        sys.stdout.write(json.dumps(res) + "\n")
                        sys.stdout.flush()
        except Exception:
            time.sleep(1)

if __name__ == "__main__":
    main()
