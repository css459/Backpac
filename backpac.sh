#! /bin/bash
#
#	BACKPAC
#
# 		An Arch Backup script with Rsync and Tar
# 		Cole Smith | css459@cims.nyu.edu

#
#	CONFIGURATION
#

# Excluding Files
# Add any files and folders to be exlcuded to the list below
EXCLUDE_LIST='src/exclude_list.txt'

# Disk to write backup to
# This is the disk that the backup will be stored on
DEST_DISK="/mnt/backup"

# Conststant Backup Path
# By default, the backup path is supplied as an argument but you
# can specify a constant one here, include mount point in the path
FILE_PATH="/mnt/backup/archlinux_backup"

# Backup File Name
# This is the name the backup file will have
# By default, it's in a form like: Backup--2016-2-23
FILE_NAME="Backup--$(date +%Y-%m-%d)"

# Compression
# Compression is enabled by default
# This can be resource intensive
COMPRESSION=true

# Auto Unmount
# Automatically unmount the backup disk
AUTOUNMOUNT=true

#
#	SCRIPT
#

# Check that we are root
if [ "$EUID" -ne 0 ]; then
	echo "Please run as root"
	exit
fi

# Check rsync and tar are installed
if [ ! -f /sbin/tar ] || [ ! -f /sbin/rsync ]; then
	echo "Tar or Rsync not installed, exiting..."
	exit
fi

# Check mount point
echo "Checking mount point: ${DEST_DISK}"
if [ $(mount | grep -c ${DEST_DISK}) != 1 ]; then
	# Disk is not mounted
	echo "Disk not mounted, attempting remount"
	sudo mount -o force,rw ${DEST_DISK}
	if [ $(mount | grep -c ${DEST_DISK}) != 1 ]; then
		echo "Could not mount ${DEST_DISK} as read write"
		exit
	fi
fi

echo "Disk mounted successfully, continuing..."

# Check that we have a file path
if [[ -n "$FILE_PATH" ]]; then

	# Remove extra '/' if needed
	FILE_PATH=${FILE_PATH%/}
	FULL_PATH="$FILE_PATH/$FILE_NAME"

	echo "Backing up '/' to ${FULL_PATH}"
	echo "----------------------------------------------"

	# Begin the backup operation
	sudo rsync -aAXH --human-readable --delete --info=progress2 --exclude-from=${EXCLUDE_LIST} / ${FULL_PATH}
	echo "----------------------------------------------"
	if [ $? -eq 0 ]; then
		echo "Backup successful"

		# Tarball the backup
		if [ ${COMPRESSION} == true ]; then
			echo "Compressing ${FULL_PATH} as ${FILE_NAME}.tar.gz"
			sudo tar czf "${FULL_PATH}.tar.gz" ${FULL_PATH}
			if [ $? -eq 0 ]; then
				# Clean up
				sudo rm -rf ${FULL_PATH}
				
				# Report size of compression
				echo "----------------------------------------------"
				echo "Final backup size: "
				sudo du -sh "${FULL_PATH}.tar.gz"
			fi
		fi

		# Auto-unmount
		if [ ${AUTOUNMOUNT} == true ]; then
			echo "Unmounting backup disk: ${DEST_DISK} ..."
			sudo umount ${DEST_DISK}
			if [ $? -eq 0 ]; then
				echo "Umount successful"
			else
				echo "Failed to unmount ${DEST_DISK}"
			fi
		fi

		exit
	else
		echo "Rsync exited with errors (exit value ${?})"
		echo "Partial backup at ${FULL_PATH}"
		exit
	fi

else
	echo "Missing backup destination path, exiting..."
	exit
fi
