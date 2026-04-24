# wahaplus-docker-autoupdate

Minimal auto-update script for [WAHA Plus](https://waha.devlike.pro/) (`devlikeapro/waha-plus`) running via Docker Compose.

Checks for a new image on Docker Hub and — only if one is found — gracefully restarts the stack with the updated version. Designed to run as a cron job.

---

## Requirements

- Docker & Docker Compose installed
- A valid **devlikeapro** Docker Hub license (paid)
- The `docker-compose.yml` for your WAHA stack already working

---

## Setup

### 1. Download the script

```bash
curl -o /root/update-waha.sh https://raw.githubusercontent.com/Komorebihost/wahaplus-docker-autoupdate/main/update-waha.sh
chmod +x /root/update-waha.sh
```

### 2. Edit the two required values

```bash
nano /root/update-waha.sh
```

| Variable | Description |
|---|---|
| `COMPOSE_DIR` | Path to the folder containing your `docker-compose.yml`. **Leave `/root` if that's where it is — works in 99% of cases.** |
| `DOCKER_PASS` | Your devlikeapro Docker Hub password |

### 3. Test it manually

```bash
bash /root/update-waha.sh
```

Expected output when no update is available:
```
Login Succeeded
Removing login credentials for https://index.docker.io/v1/
```

### 4. Schedule with cron

Run every night at 3:00 AM:
```bash
(crontab -l 2>/dev/null; echo "0 3 * * * /root/update-waha.sh >> /var/log/update-waha.log 2>&1") | crontab -
```

Verify:
```bash
crontab -l
```

Check logs:
```bash
tail -f /var/log/update-waha.log
```

---

## How it works

1. Logs in to Docker Hub with your credentials
2. Pulls the image — if **already up to date**, exits immediately without touching the running stack
3. If a **new version is found**: stops the stack, removes the old image, pulls the new one, restarts
4. Logs out

---

## Security notes

> ⚠️ **Your Docker Hub password is stored in plain text inside the script.**
> Restrict access to root only:
> ```bash
> chmod 700 /root/update-waha.sh
> ```

> ⚠️ **This script will briefly restart your WAHA stack** when a new image is available. Schedule the cron job during off-peak hours.

---

## Disclaimer

This is a community-developed tool by [Komorebihost](https://github.com/Komorebihost) and is **not affiliated with, endorsed by, or officially supported by [devlikeapro](https://waha.devlike.pro/)**.

Use at your own risk. Always test in a non-production environment first. The author is not responsible for any downtime, data loss, or service interruptions caused by the use of this script.

WAHA Plus requires a valid paid license from devlikeapro. This script does not bypass or circumvent any licensing mechanism.

Issues and pull requests are welcome.  
Repository: [github.com/Komorebihost/wahaplus-docker-autoupdate](https://github.com/Komorebihost/wahaplus-docker-autoupdate)  
Website: [komorebihost.com](https://komorebihost.com)

---

## License

MIT © 2025 Komorebihost
