#!/bin/bash

# ============================================================
# HEX-VHOST-MANAGER v3.0 - The Ultimate Apache Vhost Manager
# ============================================================
# Written by: HEX (hex-3030)
# Purpose: Manage Apache Virtual Hosts like a Pro
# ============================================================

# ============================================================
# COLOR DEFINITIONS
# ============================================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# ============================================================
# GLOBAL VARIABLES
# ============================================================
APACHE_SITES="/etc/apache2/sites-available"
APACHE_ENABLED="/etc/apache2/sites-enabled"
WWW_ROOT="/var/www/html"

# ============================================================
# HELP / VERSION
# ============================================================
version() {
    echo -e "${CYAN}====================================================${NC}"
    echo -e "${CYAN}   🚀 HEX-VHOST-MANAGER v3.0${NC}"
    echo -e "${CYAN}   📅 Version: 3.0 (Stable)${NC}"
    echo -e "${CYAN}   👤 Author: HEX (hex-3030)${NC}"
    echo -e "${CYAN}====================================================${NC}"
}

# ============================================================
# CHECK PRIVILEGES
# ============================================================
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}[!] You must run this script as root (sudo)!${NC}"
        echo -e "${YELLOW}[i] Usage: sudo bash hex-vhost-manager.sh${NC}"
        exit 1
    fi
}

# ============================================================
# CHECK APACHE IS INSTALLED
# ============================================================
check_apache() {
    if ! command -v apache2 &> /dev/null && ! command -v httpd &> /dev/null; then
        echo -e "${RED}[!] Apache is not installed on this system!${NC}"
        echo -e "${YELLOW}[i] Install Apache with: sudo apt install apache2 -y${NC}"
        exit 1
    fi
}

# ============================================================
# CREATE NEW VIRTUAL HOST
# ============================================================
create_vhost() {
    echo -e "${CYAN}────────────────────────────────────────────────────${NC}"
    echo -e "${CYAN}   🏗️  CREATE A NEW VIRTUAL HOST${NC}"
    echo -e "${CYAN}────────────────────────────────────────────────────${NC}"
    
    read -p "Enter the Vhost name (e.g., mysite): " name
    if [[ -z "$name" ]]; then
        echo -e "${RED}[!] Name cannot be empty!${NC}"
        return
    fi

    read -p "Enter the ServerName (e.g., mysite.local): " servername
    if [[ -z "$servername" ]]; then
        echo -e "${RED}[!] ServerName cannot be empty!${NC}"
        return
    fi

    # Copy default config
    echo -e "${GREEN}[+] Copying default config...${NC}"
    cp "$APACHE_SITES/000-default.conf" "$APACHE_SITES/$name.conf"
    
    # Set ServerName
    echo -e "${GREEN}[+] Setting ServerName to: $servername${NC}"
    sed -i.bk "s/^\s*#\s*ServerName/ServerName/" "$APACHE_SITES/$name.conf"
    sed -i.bk "s/www.example.com/$servername/g" "$APACHE_SITES/$name.conf"
    rm -f "$APACHE_SITES/$name.conf.bk"

    # Set DocumentRoot
    echo -e "${GREEN}[+] Setting DocumentRoot to: $WWW_ROOT/$servername${NC}"
    sed -i.bk "s|/var/www/html/|$WWW_ROOT/$servername/|g" "$APACHE_SITES/$name.conf"
    rm -f "$APACHE_SITES/$name.conf.bk"

    # Create directory
    echo -e "${GREEN}[+] Creating directory: $WWW_ROOT/$servername${NC}"
    mkdir -p "$WWW_ROOT/$servername"

    # Enable site
    echo -e "${GREEN}[+] Enabling site: $name.conf${NC}"
    a2ensite "$name.conf" > /dev/null 2>&1
    systemctl reload apache2
    sleep 2

    # Update hosts file
    echo -e "${GREEN}[+] Updating /etc/hosts with: 127.0.0.1 $servername${NC}"
    echo "127.0.0.1 $servername" >> /etc/hosts

    # Create index.html
    echo -e "${GREEN}[+] Creating index.html file...${NC}"
    cat << 'EOF' > "$WWW_ROOT/$servername/index.html"
<!DOCTYPE html>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Awesome Website</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #0f0c29, #302b63, #24243e);
            color: #ffffff;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            overflow: hidden;
        }

        /* هاله‌های نوری متحرک */
        .glow {
            position: absolute;
            border-radius: 50%;
            filter: blur(80px);
            z-index: -1;
            animation: float 8s infinite ease-in-out;
        }

        .glow-1 {
            width: 400px;
            height: 400px;
            background: rgba(255, 0, 128, 0.3);
            top: -100px;
            left: -100px;
        }

        .glow-2 {
            width: 350px;
            height: 350px;
            background: rgba(0, 255, 255, 0.3);
            bottom: -100px;
            right: -100px;
            animation-delay: 2s;
        }

        .glow-3 {
            width: 200px;
            height: 200px;
            background: rgba(255, 255, 0, 0.2);
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            animation-delay: 4s;
        }

        @keyframes float {
            0%, 100% { transform: translate(0, 0) scale(1); }
            50% { transform: translate(30px, -30px) scale(1.2); }
        }

        /* متن تایپ شونده */
        .typing {
            overflow: hidden;
            white-space: nowrap;
            border-right: 3px solid #00ffff;
            width: 0;
            animation: typing 2.5s steps(30, end) forwards, blink 0.75s step-end infinite;
            font-size: 1.5em;
            color: #00ffff;
        }

        @keyframes typing {
            from { width: 0; }
            to { width: 100%; }
        }

        @keyframes blink {
            50% { border-color: transparent; }
        }

        /* تیتر اصلی */
        .hero-title {
            font-size: 4em;
            font-weight: 800;
            letter-spacing: 2px;
            text-transform: uppercase;
            margin-bottom: 20px;
            text-shadow: 0 0 20px rgba(0, 255, 255, 0.5);
            animation: fadeInUp 1s ease-out;
        }

        .hero-subtitle {
            font-size: 1.2em;
            color: #a0a0a0;
            margin-bottom: 30px;
            animation: fadeInUp 1.2s ease-out;
        }

        /* دکمه‌ها */
        .btn-group {
            display: flex;
            gap: 20px;
            justify-content: center;
            animation: fadeInUp 1.5s ease-out;
        }

        .btn {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 15px 30px;
            font-size: 1em;
            font-weight: bold;
            color: #ffffff;
            text-decoration: none;
            border-radius: 12px;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: linear-gradient(45deg, #ff006e, #ff8c00);
            box-shadow: 0 5px 15px rgba(255, 0, 110, 0.4);
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(255, 0, 110, 0.6);
        }

        .btn-secondary {
            background: #24243e;
            border: 1px solid #00ffff;
            box-shadow: 0 5px 15px rgba(0, 255, 255, 0.2);
        }

        .btn-secondary:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0, 255, 255, 0.4);
        }

        /* پایین صفحه */
        .footer {
            position: absolute;
            bottom: 20px;
            font-size: 0.8em;
            color: #666;
            letter-spacing: 1px;
            animation: fadeInUp 2s ease-out;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* ترمینال هکر */
        .terminal {
            position: relative;
            z-index: 1;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background: rgba(0, 0, 0, 0.5);
            border: 1px solid rgba(0, 255, 255, 0.3);
            border-radius: 10px;
            box-shadow: 0 0 30px rgba(0, 255, 255, 0.2);
            font-family: 'Courier New', monospace;
            text-align: left;
            animation: fadeInUp 1.8s ease-out;
        }

        .terminal-header {
            display: flex;
            align-items: center;
            gap: 8px;
            padding-bottom: 10px;
            border-bottom: 1px solid rgba(0, 255, 255, 0.2);
        }

        .terminal-header .dot {
            width: 12px;
            height: 12px;
            border-radius: 50%;
        }

        .red { background: #ff5f56; }
        .yellow { background: #ffbd2e; }
        .green { background: #27c93f; }

        .terminal-body {
            padding-top: 10px;
            font-size: 0.9em;
            color: #00ffff;
        }

        .terminal-body p {
            margin-bottom: 5px;
        }

        .terminal-body .cmd {
            color: #ffffff;
        }

        .terminal-body .out {
            color: #a0a0a0;
        }

        .terminal-body .ok {
            color: #27c93f;
        }
    </style>
</head>
<body>
    <!-- هاله‌های نوری -->
    <div class="glow glow-1"></div>
    <div class="glow glow-2"></div>
    <div class="glow glow-3"></div>

    <div class="terminal">
        <div class="terminal-header">
            <div class="dot red"></div>
            <div class="dot yellow"></div>
            <div class="dot green"></div>
        </div>
        <div class="terminal-body">
            <p class="cmd">$ ssh root@mysite.local</p>
            <p class="out">Connecting to server...</p>
            <p class="ok">[OK] Connection established.</p>
            <p class="cmd">$ whoami</p>
            <p class="ok">root</p>
            <p class="cmd">$ cat welcome.txt</p>
            <p class="out">Welcome to my awesome website!</p>
        </div>
    </div>

    <h1 class="hero-title">Welcome To My Website</h1>
    <h2 class="typing">Building the future, one line at a time...</h2>
    <p class="hero-subtitle">A modern, professional, and fully responsive website created by HEX-VHOST-MANAGER.</p>

    <div class="btn-group">
        <a href="#" class="btn btn-primary">🚀 Get Started</a>
        <a href="#" class="btn btn-secondary">📞 Contact Us</a>
    </div>

    <div class="footer">
        &copy; 2026 My Website. All Rights Reserved. | Created with 💖 by HEX-VHOST-MANAGER
    </div>
</body>
</html>
EOF

    echo ""
    echo -e "${GREEN}══════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}   ✅ SUCCESS! Virtual Host Created!${NC}"
    echo -e "${GREEN}   🔗 URL: http://$servername${NC}"
    echo -e "${GREEN}   📁 Directory: $WWW_ROOT/$servername${NC}"
    echo -e "${GREEN}══════════════════════════════════════════════════${NC}"
}

# ============================================================
# LIST ALL VHOSTS
# ============================================================
list_vhosts() {
    echo -e "${CYAN}────────────────────────────────────────────────────${NC}"
    echo -e "${CYAN}   📋 LIST OF ALL VIRTUAL HOSTS${NC}"
    echo -e "${CYAN}────────────────────────────────────────────────────${NC}"
    
    echo -e "${WHITE}[+] Active Vhosts:${NC}"
    for site in "$APACHE_ENABLED"/*.conf; do
        [ -e "$site" ] || continue
        basename "$site" .conf
    done

    echo ""
    echo -e "${YELLOW}[+] Available (Disabled) Vhosts:${NC}"
    for site in "$APACHE_SITES"/*.conf; do
        [ -e "$site" ] || continue
        site_name=$(basename "$site" .conf)
        if [ ! -e "$APACHE_ENABLED/$site_name.conf" ]; then
            echo "$site_name"
        fi
    done
}

# ============================================================
# ENABLE SSL
# ============================================================
enable_ssl() {
    echo -e "${CYAN}────────────────────────────────────────────────────${NC}"
    echo -e "${CYAN}   🔒 ENABLE SSL (HTTPS)${NC}"
    echo -e "${CYAN}────────────────────────────────────────────────────${NC}"
    
    read -p "Enter the Vhost name to enable SSL: " name
    if [[ -z "$name" ]]; then
        echo -e "${RED}[!] Name cannot be empty!${NC}"
        return
    fi

    if [ ! -f "$APACHE_SITES/$name.conf" ]; then
        echo -e "${RED}[!] Vhost '$name' not found!${NC}"
        return
    fi

    read -p "Do you want to use Let's Encrypt (certbot)? (y/n): " use_certbot
    if [[ "$use_certbot" == "y" || "$use_certbot" == "Y" ]]; then
        if command -v certbot &> /dev/null; then
            echo -e "${GREEN}[+] Running certbot for: $name.local${NC}"
            certbot --apache -d "$name.local" --non-interactive --agree-tos --register-unsafely-without-email
        else
            echo -e "${YELLOW}[!] certbot is not installed. Install with: sudo apt install certbot python3-certbot-apache -y${NC}"
        fi
    else
        echo -e "${GREEN}[+] Adding SSL configuration manually...${NC}"
        echo -e "${YELLOW}[i] Please add your SSL cert paths manually in the config.${NC}"
    fi
}

# ============================================================
# DELETE VHOST
# ============================================================
delete_vhost() {
    echo -e "${CYAN}────────────────────────────────────────────────────${NC}"
    echo -e "${CYAN}   🗑️  DELETE A VIRTUAL HOST${NC}"
    echo -e "${CYAN}────────────────────────────────────────────────────${NC}"
    
    read -p "Enter the Vhost name to delete: " name
    if [[ -z "$name" ]]; then
        echo -e "${RED}[!] Name cannot be empty!${NC}"
        return
    fi

    if [ ! -f "$APACHE_SITES/$name.conf" ]; then
        echo -e "${RED}[!] Vhost '$name' not found!${NC}"
        return
    fi

    echo -e "${RED}[!] WARNING: This will delete configuration, directory, and DNS record!${NC}"
    read -p "Are you sure? (y/n): " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        echo -e "${GREEN}[+] Deleting configuration file...${NC}"
        a2dissite "$name.conf" > /dev/null 2>&1
        rm -f "$APACHE_SITES/$name.conf"
        
        read -p "Enter the ServerName (domain) to delete directory and hosts entry: " servername
        if [[ -n "$servername" ]]; then
            echo -e "${GREEN}[+] Deleting directory: $WWW_ROOT/$servername${NC}"
            rm -rf "$WWW_ROOT/$servername"
            
            echo -e "${GREEN}[+] Removing from /etc/hosts...${NC}"
            sed -i "/$servername/d" /etc/hosts
        fi
        
        systemctl reload apache2
        echo -e "${GREEN}✅ Vhost deleted successfully!${NC}"
    else
        echo -e "${YELLOW}[i] Operation cancelled.${NC}"
    fi
}

# ============================================================
# BACKUP VHOST
# ============================================================
backup_vhost() {
    echo -e "${CYAN}────────────────────────────────────────────────────${NC}"
    echo -e "${CYAN}   💾 BACKUP A VIRTUAL HOST${NC}"
    echo -e "${CYAN}────────────────────────────────────────────────────${NC}"
    
    read -p "Enter the Vhost name to backup: " name
    if [[ -z "$name" ]]; then
        echo -e "${RED}[!] Name cannot be empty!${NC}"
        return
    fi

    if [ ! -f "$APACHE_SITES/$name.conf" ]; then
        echo -e "${RED}[!] Vhost '$name' not found!${NC}"
        return
    fi

    echo -e "${GREEN}[+] Creating backup...${NC}"
    mkdir -p "/root/backups/$name"
    
    # Backup config
    cp "$APACHE_SITES/$name.conf" "/root/backups/$name/"
    
    # Backup directory (if exists)
    if [ -d "$WWW_ROOT/$name.local" ]; then
        cp -r "$WWW_ROOT/$name.local" "/root/backups/$name/"
    fi
    
    echo -e "${GREEN}✅ Backup saved to: /root/backups/$name${NC}"
}

# ============================================================
# VIEW ERROR LOGS
# ============================================================
view_logs() {
    echo -e "${CYAN}────────────────────────────────────────────────────${NC}"
    echo -e "${CYAN}   📜 VIEW ERROR LOGS${NC}"
    echo -e "${CYAN}────────────────────────────────────────────────────${NC}"
    
    read -p "Enter the Vhost name to view logs: " name
    if [[ -z "$name" ]]; then
        echo -e "${RED}[!] Name cannot be empty!${NC}"
        return
    fi

    if [ -f "/var/log/apache2/$name-error.log" ]; then
        echo -e "${GREEN}[+] Showing last 20 lines of error log...${NC}"
        tail -n 20 "/var/log/apache2/$name-error.log"
    else
        echo -e "${YELLOW}[!] No specific error log found for $name. Showing general error log:${NC}"
        tail -n 20 "/var/log/apache2/error.log"
    fi
}

# ============================================================
# CHECK SITE STATUS
# ============================================================
check_status() {
    echo -e "${CYAN}────────────────────────────────────────────────────${NC}"
    echo -e "${CYAN}   🩺 CHECK SITE STATUS${NC}"
    echo -e "${CYAN}────────────────────────────────────────────────────${NC}"
    
    read -p "Enter the ServerName (domain) to check: " servername
    if [[ -z "$servername" ]]; then
        echo -e "${RED}[!] ServerName cannot be empty!${NC}"
        return
    fi

    echo -e "${GREEN}[+] Pinging $servername...${NC}"
    if ping -c 1 "$servername" &> /dev/null; then
        echo -e "${GREEN}✅ $servername is reachable (Ping OK)!${NC}"
    else
        echo -e "${YELLOW}[!] $servername might not be reachable or DNS might be incorrect.${NC}"
    fi
    
    if curl -s -o /dev/null -w "%{http_code}" "http://$servername" | grep -q "200"; then
        echo -e "${GREEN}✅ Site is up and returning HTTP 200!${NC}"
    else
        echo -e "${YELLOW}[!] Site might not be loading correctly. Check Apache status!${NC}"
    fi
}

# ============================================================
# INSTALL WORDPRESS
# ============================================================
install_wordpress() {
    echo -e "${CYAN}────────────────────────────────────────────────────${NC}"
    echo -e "${CYAN}   🌐 INSTALL WORDPRESS${NC}"
    echo -e "${CYAN}────────────────────────────────────────────────────${NC}"
    
    read -p "Enter the Vhost name for WordPress: " name
    if [[ -z "$name" ]]; then
        echo -e "${RED}[!] Name cannot be empty!${NC}"
        return
    fi

    if [ ! -f "$APACHE_SITES/$name.conf" ]; then
        echo -e "${RED}[!] Vhost '$name' not found!${NC}"
        return
    fi

    read -p "Enter the ServerName (domain): " servername
    if [[ -z "$servername" ]]; then
        echo -e "${RED}[!] ServerName cannot be empty!${NC}"
        return
    fi

    echo -e "${GREEN}[+] Installing WordPress in $WWW_ROOT/$servername...${NC}"
    cd "$WWW_ROOT/$servername"
    
    # Check if wp-cli is installed
    if command -v wp &> /dev/null; then
        echo -e "${GREEN}[+] Downloading WordPress...${NC}"
        wp core download --allow-root
        echo -e "${GREEN}[+] Creating wp-config.php...${NC}"
        wp config create --dbname="wp_$name" --dbuser="root" --dbpass="" --allow-root
        echo -e "${GREEN}[+] Installing WordPress...${NC}"
        wp core install --url="http://$servername" --title="My WordPress Site" --admin_user="admin" --admin_password="admin123" --admin_email="admin@$servername" --allow-root
        echo -e "${GREEN}✅ WordPress installed successfully!${NC}"
        echo -e "${GREEN}   Username: admin${NC}"
        echo -e "${GREEN}   Password: admin123${NC}"
    else
        echo -e "${YELLOW}[!] WP-CLI is not installed. Install with: curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && sudo mv wp-cli.phar /usr/local/bin/wp${NC}"
    fi
}

# ============================================================
# MAIN MENU
# ============================================================
main_menu() {
    while true; do
        echo ""
        echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
        echo -e "${CYAN}   🐧 HEX-VHOST-MANAGER v3.0 - MAIN MENU${NC}"
        echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
        echo -e "${WHITE}   1. 🏗️  Create a New Virtual Host${NC}"
        echo -e "${WHITE}   2. 📋 List All Virtual Hosts${NC}"
        echo -e "${WHITE}   3. 🔒 Enable SSL (HTTPS)${NC}"
        echo -e "${WHITE}   4. 🗑️  Delete a Virtual Host${NC}"
        echo -e "${WHITE}   5. 💾 Backup a Virtual Host${NC}"
        echo -e "${WHITE}   6. 📜 View Error Logs${NC}"
        echo -e "${WHITE}   7. 🩺 Check Site Status${NC}"
        echo -e "${WHITE}   8. 🌐 Install WordPress${NC}"
        echo -e "${WHITE}   9. ℹ️  Version / Author Info${NC}"
        echo -e "${WHITE}   0. 🚪 Exit${NC}"
        echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
        read -p "Select an option [0-9]: " choice

        case $choice in
            1) create_vhost ;;
            2) list_vhosts ;;
            3) enable_ssl ;;
            4) delete_vhost ;;
            5) backup_vhost ;;
            6) view_logs ;;
            7) check_status ;;
            8) install_wordpress ;;
            9) version ;;
            0) 
                echo -e "${GREEN}👋 Exiting... Goodbye!${NC}"
                exit 0
                ;;
            *) echo -e "${RED}[!] Invalid option! Please choose a valid number.${NC}" ;;
        esac
    done
}

# ============================================================
# MAIN EXECUTION
# ============================================================
echo -e "${CYAN}====================================================${NC}"
echo -e "${CYAN}   🚀 INITIALIZING HEX-VHOST-MANAGER v3.0${NC}"
echo -e "${CYAN}====================================================${NC}"
sleep 1

check_root
check_apache

main_menu
