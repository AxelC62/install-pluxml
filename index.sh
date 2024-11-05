#!/bin/bash


#Script d'installation de Pluxml sur debian 11 by AxelC62

echo "Installation des paquets et installation d'Apache et PHP..."
sudo apt update && sudo apt upgrade -y 
sudo apt install -y apache2 php libapache2-mod-php php-gd php-xml unzip wget

echo "Téléchargement de PluXml..."
cd /var/www/html
wget https://www.pluxml.org/download/pluxml-latest.zip

echo "Décompression de PluXml..."
unzip pluxml-latest.zip
rm pluxml-latest.zip
mv PluXml-* pluxml

echo "Configuration des permissions..."
sudo chown -R www-data:www-data /var/www/html/pluxml
sudo chmod -R 755 /var/www/html/pluxml

echo "Configuration d'Apache pour PluXml..."
sudo bash -c 'cat > /etc/apache2/sites-available/pluxml.conf <<EOF
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html/pluxml

    <Directory /var/www/html/pluxml>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF'

echo "Activation de la configuration Apache et du module rewrite..."
sudo a2ensite pluxml.conf
sudo a2enmod rewrite
sudo systemctl restart apache2

echo "Installation de PluXml terminée ! Accédez à http://[IP_DU_CONTENEUR]/pluxml pour finaliser l'installation."