# Backpac 🎒

A simple and comprehensive backup script for Linux using Rsync and Tar

## Configuration

* Backup path 			(default `/`)
* Exclude list 			(default `~/.config/backpac/exclude_list.txt`)
* Destination disk mount point 	(default `/mnt/backup`)
* Backup file path 		(default `/mnt/backup/archlinux_backup`)
* File name 			(default `Backup--2016-2-28`)
* Compression 			(default `false`)
* Auto unmount 			(default `false`)

## Install
The default config file should be placed as `~/.config/backpac/config`
The exclude list should also be placed as `~/.config/backpac/exclude_list.txt` by default

## Using custom config files

By calling backpac with `-F` you can specify a custom config file for that backup operation.

`sudo ./backpac -F home_backup.bpac`

## Overriding config options

You can override certain config options for a single backup using these arguments

* `-B`	Backup path
* `-E`	Exclude List
* `-D`	Destination disk mount
* `-P`	Backup file path
* `-N`	File name
* `-C`	Compression
* `-A`	Auto unmount

So a single backup using the default config, but allowing compression and changing the file name
would look like:

	sudo ./backpac -N Single_Backup_Home -A true
