# System Information Summary (Bash)

A lightweight Bash script that prints a concise snapshot of your system and network state, followed by geolocation details based on your public IP. Useful for quick diagnostics and support snapshots.

---

## What it shows

- Current date, time, and day of week
- CPU usage (from `top`)
- RAM usage in MB (total, used, free)
- Disk usage for the root filesystem `/` (human-readable, including percentage)
- Network reachability status via a ping to 8.8.8.8
- Local network configuration: IP address, default gateway, subnet (CIDR)
- Public IP address
- Geolocation from `ipapi.co`: city, region, country, postal code, latitude, longitude, organization/ISP

---

## Requirements

- Bash-compatible Linux environment
- Standard utilities: `date`, `top`, `free`, `df`, `ping`, `hostname`, `ip`, `awk`, `curl`
- `jq` for parsing JSON from `ipapi.co`

### Install prerequisites (Debian/Ubuntu)

```bash
sudo apt update
sudo apt install -y curl jq procps iproute2 coreutils
```

`top` is provided by `procps`. Most other tools are available by default on common Linux distributions.

---

## Usage

```bash
chmod +x get_system_info.sh
./get_system_info.sh
```

No elevated privileges are required. The script makes outbound HTTPS requests to `https://api.ipify.org` and `https://ipapi.co` to retrieve public IP and geolocation information.

---

## Output details

- CPU Usage: Derived as `100 - idle%` from `top -bn1`.
- RAM Usage: Computed from `free -m` using total minus available.
- Disk Usage: Reported for `/` using `df -h`.
- Connection Status: "Connected" if a single ICMP echo to 8.8.8.8 succeeds; otherwise "Not Connected".
- IP Address: First address from `hostname -I`.
- Default Gateway: Parsed from `ip route`.
- Subnet Mask: First global IPv4 address and CIDR from `ip -o -f inet addr`.
- Public IP and Location: Pulled from `api.ipify.org` and `ipapi.co`, parsed with `jq`.

---

## Notes and limitations

- Internet connectivity is required to resolve public IP and geolocation.
- Geolocation accuracy depends on the IP intelligence provider and may vary.
- If `jq` is not installed, the geolocation section will not parse correctly.
- On systems without `ip` or `hostname -I`, network fields may be blank.
- The script focuses on Linux. For Windows, use WSL2 with a Linux distribution.

---

## Example

Example invocation and abbreviated output structure:

```text
-------------------------
   Current Date & Time
-------------------------
Monday,  28-10-2025  14:32:10

====================================
        System Information
====================================
CPU Usage:              7%
RAM Usage:              2048 MB / 8192 MB (Free: 5600 MB)
Disk Usage:             20G / 100G (Available: 80G)
Disk Usage Percentage:  20%
------------------------------------
Network Configuration:
Connection Status:      Connected
IP Address:             192.168.1.10
Default Gateway:        192.168.1.1
Subnet Mask:            192.168.1.10/24
====================================

------------------------------------
        System Location Info
------------------------------------
Public IP: 203.0.113.42
City: Example City
Region: Example Region
Country: Exampleland
Postal Code: 12345
Latitude: 12.3456
Longitude: 65.4321
ISP/Organization: Example ISP
------------------------------------
```


