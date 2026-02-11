function onUpdateDatabase()
	logger.info("Updating database to version 54 (feat: support to summer update 2025)")
	db.query("ALTER TABLE `players` ADD `weapon_proficiencies` mediumblob DEFAULT NULL;")
end
