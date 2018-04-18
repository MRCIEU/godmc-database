#!/bin/bash
mysql -u root -p"qnwNQ6wBW" -Bse 'SET PASSWORD FOR root@'localhost' = PASSWORD("<root-password>");'
mysql -u root -p"<root-password>" -Bse "CREATE USER 'godmc'@'%' IDENTIFIED BY '<godmc-password>';"
mysql -u root -p"<root-password>" -Bse "GRANT SELECT PRIVILEGES ON godmc.* TO 'godmc'@'%';"
mysql -u root -p"<root-password>" -Bse "FLUSH PRIVILEGES;"
