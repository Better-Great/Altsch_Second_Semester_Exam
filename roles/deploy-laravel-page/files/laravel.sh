#!/bin/bash

# Variables
NAME="web_app"
LOCATION="/var/www/$NAME"
DATABASE="ProjectDB"
USERNAME="BetterGreat"
PASSWORD="s3cur3P@ssw0rd"

# Function to update and install packages
setup_environment() {
    echo "Updating package repositories..."
    sudo apt update -y 
    echo "Installing Apache2..."
    sudo apt install apache2 -y 
    echo "Adding PHP repository..."
    sudo add-apt-repository ppa:ondrej/php -y 
    sudo apt update -y
    sudo apt-get update -y 
    echo "Installing PHP and dependencies..."
    sudo apt install php8.2 php8.2-curl php8.2-dom php8.2-mbstring php8.2-xml php8.2-mysql zip unzip git -y 
    sudo a2enmod php8.2 
    echo "Environment setup completed."
}


# Function to install Composer
get_composer() {
    echo "Installing Composer..."
    cd /usr/local/bin
    sudo curl -sS https://getcomposer.org/installer | sudo php -q
    sudo mv composer.phar composer
    echo "Composer installation completed."
}

# Function to clone repo and set ownership
clone_project() {
    echo "Cloning project repository..."
    cd /var/www/
    sudo git clone https://github.com/laravel/laravel.git $NAME
    sudo chown -R $USER:$USER $LOCATION
    echo "Project cloned and ownership set."
}

# Function to install Composer dependencies
setup_dependencies() {
    echo "Installing Composer dependencies..."
    cd $LOCATION
    composer install --no-interaction --optimize-autoloader --no-dev
    composer update --no-interaction
    echo "Composer dependencies installed."
}

# Function to create .env file
create_env_file() {
    echo "Creating .env file..."
    sudo cp $LOCATION/.env.example $LOCATION/.env
    sudo chown -R www-data $LOCATION/storage
    sudo chown -R www-data $LOCATION/bootstrap/cache
    echo ".env file created."
}

# Function to configure Apache
configure_server() {
    echo "Configuring Apache server..."
    sudo tee /etc/apache2/sites-available/$NAME.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerName 192.168.50.16
    DocumentRoot $LOCATION/public
    <Directory $LOCATION>
        AllowOverride All
    </Directory>
    ErrorLog \${APACHE_LOG_DIR}/$NAME-error.log
    CustomLog \${APACHE_LOG_DIR}/$NAME-access.log combined
</VirtualHost>
EOF
    sudo a2ensite $NAME.conf > /dev/null 2>&1
    sudo a2dissite 000-default.conf > /dev/null 2>&1
    echo "Apache server configured."
}

# Function to install and configure MySQL
setup_database() {
    echo "Installing and configuring MySQL..."
    sudo apt install mysql-server mysql-client -y
    sudo systemctl start mysql
    sudo mysql -uroot -e "CREATE DATABASE $DATABASE;"
    sudo mysql -uroot -e "CREATE USER '$USERNAME'@'localhost' IDENTIFIED BY '$PASSWORD';"
    sudo mysql -uroot -e "GRANT ALL PRIVILEGES ON $DATABASE.* TO '$USERNAME'@'localhost';"
    echo "MySQL installed and configured."
}


# Function to modify .env file
configure_env() {
    echo "Configuring .env file..."
    sudo sed -i "23 s/^#//g" $LOCATION/.env
    sudo sed -i "24 s/^#//g" $LOCATION/.env
    sudo sed -i "25 s/^#//g" $LOCATION/.env
    sudo sed -i "26 s/^#//g" $LOCATION/.env
    sudo sed -i "27 s/^#//g" $LOCATION/.env
    sudo sed -i '22 s/=sqlite/=mysql/' $LOCATION/.env
    sudo sed -i '23 s/=127.0.0.1/=localhost/' $LOCATION/.env
    sudo sed -i '24 s/=3306/=3306/' $LOCATION/.env 
    sudo sed -i '25 s/=laravel/='$DATABASE'/' $LOCATION/.env
    sudo sed -i '26 s/=root/='$USERNAME'/' $LOCATION/.env
    sudo sed -i '27 s/=/='$PASSWORD'/' $LOCATION/.env
    echo ".env file configured."
}

# Function to run artisan commands
run_artisan() {
    echo "Running artisan commands..."
    cd $LOCATION
    sudo php artisan key:generate
    sudo php artisan storage:link
    sudo php artisan migrate
    sudo php artisan db:seed
    echo "Artisan commands executed."
}

# Function to restart Apache
restart_server() {
    echo "Restarting Apache server..."
    sudo systemctl restart apache2
    echo "Apache server restarted."
}

# Main deployment function
deploy() {
    setup_environment
    restart_server
    get_composer
    clone_project
    setup_dependencies
    create_env_file
    configure_server
    restart_server
    setup_database
    configure_env
    run_artisan
    restart_server
    echo "Deployment successful!"
}

# Execute deployment function
deploy





