#!/bin/bash

# Navigate to the directory, suppressing errors
cd /etc/apache2/sites-available/ 2> /dev/null

# Check if the directory change was successful
if [ $? -ne 0 ]; then
    echo "It has an error!"
    exit 1
else
    echo "Success"

    # Prompt the user for the virtual host name
    read -p "Enter the name of your virtual host: " name

    # Copy the default configuration to a new file
    cp 000-default.conf ${name}.conf

    # Prompt the user for the server name (domain name)
    read -p "Now, enter your server name (e.g., example.com): " servername

    # Replace 'ServerName' placeholder in the copied config file with the user's input
    sed -i "s|#ServerName www.example.com|ServerName $servername|" ${name}.conf

    # Optionally, add or replace the DocumentRoot in the config (you can modify this line if needed)
    sed -i "s|DocumentRoot /var/www/html|DocumentRoot /var/www/html/$servername|" ${name}.conf

    # Optionally, enable the site and reload Apache (uncomment if needed)
    # a2ensite ${name}.conf
    # systemctl reload apache2

    echo "Virtual host configuration for $servername has been created as ${name}.conf."
    exit 0
fi

