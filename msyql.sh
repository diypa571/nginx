#!/bin/bash

# Generate a strong password that will be used for mysql_secure_installation
PASSWORD=""
while [[ ! $(echo $PASSWORD | tr -d -c '[:lower:]' | wc -m) -ge 2 || 
          ! $(echo $PASSWORD | tr -d -c '[:upper:]' | wc -m) -ge 2 || 
          ! $(echo $PASSWORD | tr -d -c '[:digit:]' | wc -m) -ge 2 || 
          ! $(echo $PASSWORD | tr -d -c '#$' | wc -m) -ge 2 ]]; do 
  PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9#$' | fold -w 15 | head -n 1)
done

echo "Generated Password: $PASSWORD"
# Write the password to a file
echo "$PASSWORD" > db_password.txt
echo "Password has been written to db_password.txt"

# Running mysql_secure_installation using expect
SECURE_MYSQL=$(expect -c "
set timeout 10
spawn sudo mysql_secure_installation

# Expecting various prompts from mysql_secure_installation
expect \"Remove test database and access to it? (Press y|Y for Yes, any other key for No) :\"
send \"Y\r\"

expect \"Disallow root login remotely? (Press y|Y for Yes, any other key for No) :\"
send \"Y\r\"

expect \"Remove test database and access to it? (Press y|Y for Yes, any other key for No) :\"
send \"Y\r\"

expect \"Reload privilege tables now? (Press y|Y for Yes, any other key for No) :\"
send \"Y\r\"

expect eof
")

# Provide instructions for changing the password manually
echo "Remember to change the MySQL root password using the following command:"
echo "mysql-> ALTER USER 'root'@'localhost' IDENTIFIED BY '$PASSWORD'; flush privileges; exit;"

echo "$SECURE_MYSQL"
