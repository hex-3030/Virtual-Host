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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to My Website</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f4f4f4; }
        header { background: #007bff; color: white; padding: 10px 0; text-align: center; }
        main { margin-top: 20px; }
        footer { text-align: center; margin-top: 20px; padding: 10px 0; background: #007bff; color: white; }
    </style>
</head>
<body>
    <header><h1>Welcome to My Website</h1></header>
    <main>
        <h2>Hello, World!</h2>
        <p>This is a simple HTML page. You can modify it as you like.</p>
    </main>
    <footer><p>&copy; 2024 My Website</p></footer>
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
