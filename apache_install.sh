#!/bin/bash

update() {

        if ! sudo apt update; then
                echo "Update Failed"
                exit 1
        fi

        echo "Update Completed"

        if ! sudo apt upgrade -y; then
                echo "Upgrade failed"
                exit 1
        fi

        echo "Upgrade Completed"

}

apache_installation() {

        apache="/etc/apache2"

        if [[ -e $apache ]]; then
                echo "Apache is installed"
        else
                if ! sudo apt install apache2; then
                        echo "Apache Installation Failed"
                        exit 1
                fi
                echo "Apache Installation Completed"
        fi

}


apache_start() {

        if systemctl is-active --quiet apache2; then
                echo "Apache is Running"
        else
                sudo systemctl start apache2
                echo "Apache has Started"
                sudo systemctl enable apache2
                echo "Apache is Enabled"
                systemctl status apache2
        fi
}

apache_configuration() {

        site="/etc/apache2/sites-available/example.com.conf"

        sudo a2dissite 000-default.conf

        if [[ ! -e $site ]]; then
               cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/example.com.conf
        else
                echo "Path Exists"
        fi

        sed -i 's/ServerAdmin webmaster@localhost/ServerAdmin webmaster@example.com/g' /etc/apache2/sites-available/example.com.conf

        sed -i 's/DocumentRoot /var/www.html/ /var/www/example.com/public/g' /etc/apache/sites-available/example.com.conf


        sudo a2ensite example.com

        sudo systemctl restart apache2

}



update
apache_installation
apache_start
apache_configuration


