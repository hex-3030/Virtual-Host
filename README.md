<p align="center">
  <img src="https://img.shields.io/badge/Version-3.0-green?style=for-the-badge">
  <img src="https://img.shields.io/badge/Tool-Virtual%20Host%20Manager-blue?style=for-the-badge">
  <img src="https://img.shields.io/badge/Made%20With-Bash-1f425f?style=for-the-badge">
</p>

<h1 align="center">🐧 HEX-VHOST-MANAGER</h1>

<p align="center">
  <b>"Manage Apache Virtual Hosts like a Pro!"</b> — The ultimate interactive tool to create, manage, secure, backup, and optimize your Apache Virtual Hosts, complete with WordPress auto-installation and SSL support.
</p>

---

## 🚀 Features

- 🏗️ **Create Vhosts** — Fully automated setup with custom ServerName, DocumentRoot, and index.html.
- 📋 **List All Vhosts** — View active and disabled sites instantly.
- 🔒 **Enable SSL** — Install Let's Encrypt or manual SSL certificates.
- 🗑️ **Delete Vhosts** — Secure removal of configurations, directories, and DNS records.
- 💾 **Backup** — Create full backups of configuration and site files.
- 📜 **View Logs** — Diagnose issues by viewing error logs.
- 🩺 **Check Status** — Ping and HTTP status check of your site.
- 🌐 **WordPress Install** — Auto-install WordPress with WP-CLI.
- 🖥️ **Interactive Menu** — Easy to use, color-coded terminal UI.

## 📥 Installation

```bash
# Make the script executable
chmod +x hex-vhost-manager.sh
```
---
## ⚠️ Requirements: Apache2, root privileges (sudo), and Bash. For SSL, install certbot. For WordPress, install wp-cli.

## 🎯 Usage

`sudo bash auto-vhost.sh`
---


## 🛠️ How It Works
**Create: Reads Vhost name & ServerName, copies default config, sets paths, creates directory, enables site, updates /etc/hosts, and generates HTML.**

List: Shows active and disabled sites.

SSL: Option to use certbot for free HTTPS certificates.

Delete: Safely removes everything related to the site.

Backup: Stores copies in `/root/backups/.`

Logs: Shows the last 20 lines of the error log.

Status: Pings the domain and checks if it returns HTTP 200.

WordPress: Uses WP-CLI to download, configure, and install WordPress automatically..
---

## 🧑‍💻 Author

- **GitHub:** [hex-3030](https://github.com/hex-3030)
- **TryHackMe:** [HEXD](https://tryhackme.com/p/HEXD)
---
## ⚠️ Disclaimer
***This tool is intended for local development, authorized security testing, and system administration purposes only. Run it only on systems you own or have permission to manage.***


---

<p align="center">
  ⭐ If you find this project useful, please consider giving it a Star! ⭐
</p>
