# .bash_profile

# Get the aliases and functions
[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"

export PATH="$HOME/.local/bin:$PATH"

# Auto-start mango Wayland compositor on tty1
if [ "$(tty)" = "/dev/tty1" ]; then
  exec dbus-run-session mango
fi
