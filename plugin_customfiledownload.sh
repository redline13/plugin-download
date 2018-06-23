# Plugin install script.  Download and extracts files.
function plugin_install()
{
	# Get user info
	userHome=$1
	user=$2

	# Get file to download
	url=$(plugin_setting customfiledownload_filename)
	if [ "${url}" != "" ]; then
		# Set up directory
		cd "${userHome}"
		if [ ! -d downloads ]; then
			mkdir downloads
			chown "${user}:${user}" downloads
		fi
		cd downloads
		# Download
		rl_logger "Downloading ${url}"
		file=$(basename "${url}")
		curl "${url}" > "${file}"
		chown "${user}:${user}" "${file}"
		if [ $? -ne 0 ]; then
			rl_logger "Failed to download ${url}"
		else
			# Extra file if desired
			tarExtract=$(plugin_setting customfiledownload_tar_extract)
			if [ "${tarExtract}" = "T" ]; then
				rl_logger "Extracting ${file}"
				sudo -u "${user}" tar xf "${file}"
				if [ $? -ne 0 ]; then
					rl_logger "Failed to extract file"
				fi
			fi
		fi
	fi
}