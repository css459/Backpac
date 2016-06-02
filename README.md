# Backpac DEVELOPMENT

Todo
* Implement if statement on parsing custom backpac argument
* Implement support for incremental backups
* Add protections against dangerous operations (needless unmount, etc)
* Make AUTOMOUNT false by default

A simple and comprehensive backup script for Linux using Rsync and Tar

Configuration allows for:

* Backup path 			(default '/')
* Exclude list 			(default provided)
* Destination disk mount point 	(default '/mnt/backup')
* Backup file path 		(default '/mnt/backup/archlinux_backup')
* File name 			(default example 'Backup--2016-2-28)
* Compression 			(default on)
* Auto unmount 			(default on)
