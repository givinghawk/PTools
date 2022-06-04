#!/bin/bash
echo -e "\e[1;41m WARNING: This script will not work on CentOS! If you are running CentOS then please do not use this script! \e[0m"
PS3='Choose an option: '
options=("Turn on maintainence mode" "Turn off maintainence mode" "Update Pterodactyl" "Quit")
select slec in "${options[@]}"; do
    case $slec in
        "Turn on maintainence mode")
            cd /var/www/pterodactyl && php artisan down
            exit
            ;;
        "Turn off maintainence mode")
            cd /var/www/pterodactyl && php artisan up
            exit
            ;;
        "Update Pterodactyl")
                       cd /var/www/pterodactyl
            php artisan down
            curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzv
            chmod -R 755 storage/* bootstrap/cache
            composer install --no-dev --optimize-autoloader
            php artisan view:clear
            php artisan config:clear
            php artisan migrate --seed --force
            chown -R www-data:www-data /var/www/pterodactyl/*
            php artisan queue:restart
            php artisan up
            echo -e "\e[1;42m Updated Pterodactyl! \e[0m"
            exit
            ;;
	"Quit")
	    exit
	    ;;
        *) echo "Invalid option $REPLY";;
    esac
done
