# Crowl

A lightweight Bash tool that scans the local network (the same LAN your device is connected to) and lists discovered devices with:

- Hostname (when resolvable)
- IP address
- MAC address

The repository contains only two files: `crowl.sh` (main script) and `install.sh` (installer that adds the `crowl` alias).

---

## Files

- **crowl.sh** — Main script that detects the local network range, runs `nmap -sn`, parses the output and prints a formatted table.
- **install.sh** — Installer that adds an alias so the command `crowl` can be used system-wide for the current user.

---

## Requirements

- Unix-like system with Bash (Linux recommended)
- `nmap` installed
- `ip` (from `iproute2`)
- Standard utilities: `awk`, `grep`, `sed`
- `sudo` recommended for reliable MAC address discovery

---

## Installation

Clone the repository, make the installer executable and run it:

```bash
git clone https://github.com/your-username/your-repo.git
cd your-repo
chmod +x install.sh
./install.sh
````

`install.sh` will add an alias (for example `alias crowl="/path/to/crowl.sh"`) to your shell configuration (e.g. `~/.bashrc` or `~/.config/fish/config.fish`). Review the installer before running if you prefer to add the alias manually.

After installation, start a new shell session or source your shell config to apply the alias:

```bash
# bash
source ~/.bashrc

# fish
source ~/.config/fish/config.fish
```

---

## Usage

After running the installer once, the user only needs to run:

```bash
sudo crowl
```

(`sudo` is recommended so `nmap` can perform ARP/ping scans that return MAC addresses; behavior may vary without root privileges.)

You can also run the script directly without installing:

```bash
sudo ./crowl.sh
```

---

## Example output

```
Devices found: 3

Hostname             IP Address      MAC Address
---------------------------------------------------------------
router               192.168.1.1     00:11:22:33:44:55
laptop               192.168.1.12    AA:BB:CC:DD:EE:FF
(unknown)            192.168.1.25    (none)
```

* `(unknown)` indicates no hostname was resolved.
* `(none)` indicates no MAC address was available from the scan output.

---

## How it works (brief)

1. The script uses `ip a` to find the active interface and derive the local network range (for example, `192.168.1.0/24`).
2. It runs `nmap -sn <network-range>` to discover hosts via ping/ARP.
3. The `nmap` output is parsed with `awk` to extract hostnames, IPs and MAC addresses.
4. Results are printed in an aligned table with a summary line showing the number of devices found.

---

## Notes & troubleshooting

* Run only on networks you own or have explicit permission to scan.
* If MAC addresses are missing, try running with `sudo` or ensure hosts are on the same L2 segment (MACs are not visible across routers).
* If your network uses non-`192.168.*` addressing, the auto-detection logic in `crowl.sh` may need minor adjustments.
* Review `install.sh` before running — it modifies user shell config to create the `crowl` alias.
