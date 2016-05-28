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
EXCLUDE_LIST={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/home/*/.cache/mozilla/*","/home/*/.cache/chromium/*","/home/*/.local/share/Trash/*","/home/*/.gvfs/"}

# Conststant Backup Path
# By default, the backup path is supplied as an argument but you
# can specify a constant one here
FILE_PATH=$1

# Backup File Name
# This is the name the backup file will have
# By default, it's in a form like: Backup--2016-2-23
FILE_NAME="Backup--$(date +%Y-%m-%d)"

# Compression
# Compression is enabled by default
COMPRESSION=true

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

# Check that we have a file path
if [[ -n "$FILE_PATH" ]]; then

	# Remove extra '/' if needed
	FILE_PATH=${FILE_PATH%/}
	FULL_PATH="$FILE_PATH/$FILE_NAME"

	echo "Backing up '/' to ${FULL_PATH}"
	echo "----------------------------------------------"

	# Debugging
	#echo "Compressing ${FULL_PATH} as ${FILE_NAME}.tar.gz"
	#exit

	# Begin the backup operation
	sudo rsync -aAXvHl --exclude={${EXLCUDE_LIST}} / ${FULL_PATH}
	echo "----------------------------------------------"
	if [ "$?" -eq "0" ]; then
		echo "Backup successful, compressing..."
	else
		echo "Rsync exited with errors (exit value ${?})"
		echo "Partial backup at ${FULL_PATH}"
		exit
	fi

	# Tarball the backup
	if [ ${COMPRESSION} == true ]; then
		echo "Compressing ${FULL_PATH} as ${FILE_NAME}.tar.gz"
		sudo tar czf "${FILE_NAME}.tar.gz" ${FULL_PATH} ${FILE_PATH}
	fi

	exit
else
	echo "Missing backup destination path, exiting..."
	exit
fi
