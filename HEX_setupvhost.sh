#!/bin/bash

# this is a script for set up virtual host

cd /etc/apache2/sites-available/ 2> /dev/null

if [ $? -ne 0 ]; then
    echo "It has an error!"
else
    echo "Success"




    read -p "Enter the name your virtual host:" name;

    cp /etc/apache2/sites-available/000-default.conf $name.conf
    read -p "now, Enter the your server name:" servername 
# this command for finding # that be delete it.
# this command search from google 
  sed -i.bk 's/^\s*#\s*ServerName/ServerName/' $name.conf 
    rm $name.conf.bk
    cat $name.conf | grep -i www.example.com | sed -i.bk -e "s/www.example.com/$servername/" $name.conf

    sed -i.bk -e "s|/var/www/html/|/var/www/html/$servername/|g" $name.conf
    rm $name.conf.bk
    mkdir -p /var/www/html/$servername


#now let's enable virtualhost:


    a2ensite $name.conf > /dev/null 2>&1
    systemctl reload apache2
    sleep 3
    echo "###"
    sleep 1
    echo "#######"
    sleep 1
    echo "###########"
    sleep 2
    echo "apache2 is reloaded :) "
    sleep 1
######################################################################
    echo 127.0.0.1 $servername.com >> /etc/hosts 2> /dev/null
    
read -p "enter the index.html's name:" index;
touch $index.html;

mv $index.html /var/www/html/$servername/$index.html

sleep 1

cat <<  test > /var/www/html/$servername/$index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to My Website</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f4f4f4;
        }
        header {
            background: #007bff;
            color: white;
            padding: 10px 0;
            text-align: center;
        }
        main {
            margin-top: 20px;
        }
        footer {
            text-align: center;
            margin-top: 20px;
            padding: 10px 0;
            background: #007bff;
            color: white;
        }
    </style>
</head>
<body>

<header>
    <h1>Welcome to My Website</h1>
</header>

<main>
    <h2>Hello, World!</h2>
    <p>This is a simple HTML page. You can modify it as you like.</p>
    <p>Feel free to add more content here!</p>
</main>

<footer>
    <p>&copy; 2024 My Website</p>
</footer>

</body>
</html>
test
#this script is done 
echo "now you can to the browser and you can see  page .."



    exit 0
fi
#writtern by HEX
