#!/usr/bin/env python3
import socket
import os
import glob
import sys

def main():
    runtime_dir = os.environ.get("XDG_RUNTIME_DIR", f"/run/user/{os.getuid()}")
    sockets = glob.glob(os.path.join(runtime_dir, "mango-*.sock"))
    if not sockets:
        return

    action = sys.argv[1] if len(sys.argv) > 1 else "next"
    if action == "close":
        cmd = b"dispatch killclient\n"
    elif action == "prev":
        cmd = b"dispatch focuslast\n"
    else:
        cmd = b"dispatch focusstack\n"

    try:
        s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        s.connect(sockets[0])
        s.sendall(cmd)
        s.close()
    except Exception:
        pass

if __name__ == "__main__":
    main()
