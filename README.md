<p align="center">
  <img src="https://img.shields.io/badge/Version-2.0-green?style=for-the-badge">
  <img src="https://img.shields.io/badge/Tool-Apache%20Virtual%20Host-orange?style=for-the-badge">
  <img src="https://img.shields.io/badge/Made%20With-Bash-1f425f?style=for-the-badge">
</p>

<h1 align="center">🐧 AUTO-VHOST</h1>

<p align="center">
  <b>"Just run it, and your site is live!"</b> — A clean, automated, and bug-free Bash script to create Apache Virtual Hosts, generate custom HTML pages, update /etc/hosts, and reload Apache — all with a single command.
</p>

---

## 🚀 Features

- 🏗️ **Automatically creates** the Virtual Host configuration file from `000-default.conf`.
- 🌐 **Replaces** `ServerName` and `DocumentRoot` with your custom domain.
- 📁 **Creates** the target directory and a brand new `index.html`.
- ⚡ **Enables** the site and reloads Apache.
- 🖥️ **Updates** `/etc/hosts` so you can access the site locally.
- 🔒 **Error checking** in every step to ensure smooth execution.

## 📥 Installation

```bash
# Make the script executable
chmod +x auto-vhost.sh
```
---
## ⚠️ Requirements: Apache2, root privileges (sudo), and Bash.

## 🎯 Usage

`sudo bash auto-vhost.sh`
---


## 🛠️ How It Works
**Reads the desired Virtual Host name**.

Enters the ServerName (domain name).

Creates the config file in` /etc/apache2/sites-available/.`

Creates the directory in `/var/www/html/`.

Enables the site and reloads Apache.

Adds the domain to `/etc/hosts` for local testing.

Generates a custom HTML file.
---

## 🧑‍💻 Author

- **GitHub:** [hex-3030](https://github.com/hex-3030)
- **TryHackMe:** [HEXD](https://tryhackme.com/p/HEXD)
---
## ⚠️ Disclaimer

This tool is intended for **authorized security testing and educational purposes only**. Use it only on systems you own or have explicit permission to test. Unauthorized use is strictly prohibited.

---

<p align="center">
  ⭐ If you find this project useful, please consider giving it a Star! ⭐
</p>
