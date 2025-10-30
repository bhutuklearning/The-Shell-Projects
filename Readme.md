# The-Shell-Project
## System and Network Utilities (Bash)

This repository contains two practical Bash utilities for quickly assessing a machine's health and diagnosing network issues. Both scripts are self-contained, easy to run, and produce readable terminal output suitable for troubleshooting and support.

- `get_system_info.sh`: Prints a concise snapshot of system status (CPU, RAM, disk), local network details, and public IP geolocation.
- `network_diagnostic_info.sh`: Interactive menu-driven tool combining speed tests, traceroute, ping, port scanning, packet capture, bandwidth usage, Wi‑Fi scanning, and more.

---

## Contents

```
Shell Projects/
├─ get_system_info.sh
├─ get_system_info.md
├─ network_diagnostic_info.sh
├─ network_diagnostic_info.md
└─ Readme.md
```

---

## Requirements

Both scripts are designed for Linux or Linux-like environments. Windows users should use WSL2.

Common tools used across the scripts:
- Shell and core utilities: `bash`, `awk`, `coreutils`
- System and network: `procps` (for `top`), `iproute2` (for `ip`), `hostname`, `ping`, `traceroute`
- HTTP and JSON: `curl`, `jq`
- Optional for network diagnostics: `tcpdump`, `vnstat`, `network-manager` (`nmcli`), Ookla Speedtest CLI as `speedtest`

### Install prerequisites (Debian/Ubuntu)

```bash
sudo apt update
sudo apt install -y curl jq procps iproute2 net-tools traceroute tcpdump vnstat network-manager
```

Ookla Speedtest CLI (provides the `speedtest` command used by the network tool):

```bash
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
sudo apt install -y speedtest
```

If you prefer `speedtest-cli` from the repositories, install it and update the script to call `speedtest-cli` instead of `speedtest`.

---

## Quick start

Clone your fork or copy the scripts onto a Linux machine, then:

```bash
chmod +x get_system_info.sh network_diagnostic_info.sh
```

Run the system snapshot:

```bash
./get_system_info.sh
```

Run the interactive network diagnostics:

```bash
./network_diagnostic_info.sh
```

For features that require elevated privileges (for example, live packet capture), prefix the command with `sudo`.

---

## Script details

### get_system_info.sh

Produces a one-shot report including:
- Current date and time
- CPU usage from `top`
- RAM usage from `free` (total, used, free)
- Disk usage for `/` from `df -h`
- Network reachability via ping to 8.8.8.8
- Local IP, default gateway, and subnet from `ip`
- Public IP and geolocation from `api.ipify.org` and `ipapi.co` parsed with `jq`

See `get_system_info.md` for a complete description and sample output.

### network_diagnostic_info.sh

Menu-driven diagnostics:
1. Check Internet speed (Ookla Speedtest CLI)
2. Trace route to a server
3. Ping a server with configurable packet size and count
4. Show network configuration details (IP, gateway, DNS)
5. Perform fast TCP port scanning over a range
6. Log selected diagnostics to `network_advance_diagnostic.log`
7. Live packet capture with `tcpdump` (limited sample)
8. Bandwidth usage per interface (`vnstat` if available, otherwise `/proc/net/dev`)
9. Scan nearby Wi‑Fi networks with `nmcli`

See `network_diagnostic_info.readme.md` for detailed instructions, dependencies, and notes.

---

## Windows support

Use Windows Subsystem for Linux (WSL2) and install a Linux distribution such as Ubuntu. Run all commands from the WSL2 Linux shell. Git Bash or PowerShell are not sufficient for most features.

---

## Privacy and responsible use

- Geolocation is based on public IP and provided by external services. Do not share output you consider sensitive.
- Port scanning and packet capture should only be used on networks and systems you own or have explicit permission to test.

---

## Contributing

Contributions are welcome. Please open an issue to propose changes, or submit a pull request with a clear description and tested updates. Keep the scripts POSIX-friendly where practical and avoid introducing unnecessary dependencies.

---

## License

Choose an open-source license that fits your needs (for example, MIT). Add a `LICENSE` file at the repository root.

---

## Acknowledgments

- Ookla Speedtest CLI
- The Linux networking toolchain (`iproute2`, `traceroute`, `tcpdump`, `vnstat`, `NetworkManager`)
- `ipapi.co` and `api.ipify.org` for IP and geolocation lookup
