USE mysql;

# Deleting 'pDonkeyS'@'localhost' ...
DELETE FROM `user` WHERE `User` = "pDonkeyS" AND `Host` = "localhost";

DELETE FROM `db` WHERE `User` = "pDonkeyS" AND `Host` = "localhost";

DELETE FROM `tables_priv` WHERE `User` = "pDonkeyS" AND `Host` = "localhost";

DELETE FROM `columns_priv` WHERE `User` = "pDonkeyS" AND `Host` = "localhost";

DROP DATABASE IF EXISTS `pDonkey` ;

# Reloading the privileges ...
FLUSH PRIVILEGES ;

