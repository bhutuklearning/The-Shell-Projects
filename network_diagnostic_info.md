# Advanced Network Diagnostic Tool (Bash)

An interactive Bash script to analyze and troubleshoot network issues. It brings together speed testing, ping, traceroute, bandwidth usage, port scanning, live packet capture, Wi‑Fi scanning, and configuration reporting in a single terminal interface.

---

## Features

- Check Internet speed using the Ookla Speedtest CLI (`speedtest`)
- Trace the route to a destination host using `traceroute`
- Advanced ping utility with configurable packet count and size
- Display local network configuration (IP, gateway, DNS)
- Fast TCP port scanning over a specified range
- Log selected diagnostic output to a file
- Live packet capture using `tcpdump` (limited sample)
- Bandwidth usage per interface (`vnstat` if available, otherwise `/proc/net/dev`)
- Nearby Wi‑Fi network scanner using `nmcli`

---

## Dependencies

The script relies on the following tools. Many are preinstalled on common Linux distributions.

- `bash`, `awk`, `coreutils`
- `iproute2` (for `ip`), `hostname`
- `ping`, `traceroute`
- `tcpdump` (for live capture; requires root privileges)
- `vnstat` (optional; for bandwidth summaries)
- `nmcli` from NetworkManager (for Wi‑Fi scanning)
- Ookla Speedtest CLI as `speedtest` (alternatively adapt the script to `speedtest-cli`)

### Install on Debian/Ubuntu

```bash
sudo apt update
sudo apt install -y traceroute iproute2 net-tools tcpdump vnstat network-manager
```

For the Ookla Speedtest CLI (provides the `speedtest` command used by this script):

```bash
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
sudo apt install -y speedtest
```

If you prefer `speedtest-cli` from the repositories, install it and update the script to invoke `speedtest-cli` instead of `speedtest`.

---

## How to run (Linux)

Grant execute permission and run the script:

```bash
chmod +x network_diagnostic_info.sh
./network_diagnostic_info.sh
```

You will be presented with a numbered menu. Enter the option number to perform the corresponding diagnostic. Some features, such as live packet capture, will prompt for an interface and may require `sudo`.

### Menu options

1. Check Internet speed
2. Trace route to a server
3. Ping a server (advanced)
4. Show network configuration details
5. Perform port scanning
6. Log diagnostic results to `network_advance_diagnostic.log`
7. Live packet capture (tcpdump)
8. Show bandwidth usage per interface
9. Scan nearby Wi‑Fi networks
10. Exit

---

## Logging

When you choose the logging option, a file named `network_advance_diagnostic.log` is appended with a timestamped section capturing several diagnostics. You can review this file or share it for support purposes.

---

## Notes, security, and permissions

- `tcpdump` typically requires root privileges. Run the script or that function with `sudo` when capturing packets.
- Port scanning uses bash TCP redirection with `timeout` and runs multiple probes in parallel. Use responsibly and with authorization.
- Bandwidth reporting will use `vnstat` if present; otherwise it falls back to parsing `/proc/net/dev`.
- DNS server information is read from `systemd-resolve` when available.
- Actual command availability may vary by distribution; install missing tools as needed.

---

## Windows support

Use Windows Subsystem for Linux (WSL2) with a Linux distribution such as Ubuntu. Most features require Linux utilities that are not available in Git Bash or default Windows shells. Within WSL2, follow the Linux instructions above.

---
