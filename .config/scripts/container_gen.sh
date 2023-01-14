#!/bin/sh

#https://docs.podman.io/en/latest/markdown/podman-run.1.html
#--mount podman command can mount files to container
#https://www.howtogeek.com/devops/how-to-mount-or-symlink-a-single-file-in-a-docker-container/
#copy distrobox-export

conteiner_gen() {
# Set the container hostname the same as the container name.
	result_command="${container_manager} create"
	# use the host's namespace for ipc, network, pid, ulimit
	result_command="${result_command}
		--hostname \"${container_name}.$(uname -n)\"
		--ipc host
		--name \"${container_name}\"
		--network host
		--privileged
		--security-opt label=disable
		--user root:root"

	if [ "${init}" -eq 0 ]; then
		result_command="${result_command}
			--pid host"
	fi
	# Mount useful stuff inside the container.
	# We also mount host's root filesystem to /run/host, to be able to syphon
	# dynamic configurations from the host.
	#
	# Mount user home, dev and host's root inside container.
	# This grants access to external devices like usb webcams, disks and so on.
	#
	# Mount also the distrobox-init utility as the container entrypoint.
	# Also mount in the container the distrobox-export and distrobox-host-exec
	# utilities.
	result_command="${result_command}
		--label \"manager=distrobox\"
		--env \"SHELL=${SHELL:-"/bin/bash"}\"
		--env \"HOME=${container_user_home}\"
		--volume \"${container_user_home}\":\"${container_user_home}\":rslave
		--volume /:/run/host:rslave
		--volume /dev:/dev:rslave
		--volume /sys:/sys:rslave
		--volume /tmp:/tmp:rslave"

	# This fix is needed as on Selinux systems, the host's selinux sysfs directory
	# will be mounted inside the rootless container.
	#
	# This works around this and allows the rootless container to work when selinux
	# policies are installed inside it.
	#
	# Ref. Podman issue 4452:
	#    https://github.com/containers/podman/issues/4452
	if [ -e "/sys/fs/selinux" ]; then
		result_command="${result_command}
			--volume /sys/fs/selinux"
	fi

	# This fix is needed as systemd (or journald) will try to set ACLs on this
	# path. For now overlayfs and fuse.overlayfs are not compatible with ACLs
	#
	# This works around this using an unnamed volume so that this path will be
	# mounted with a normal non-overlay FS, allowing ACLs and preventing errors.
	#
	# This work around works in conjunction with distrobox-init's package manager
	# setups.
	# So that we can use pre/post hooks for package managers to present to the
	# systemd install script a blank path to work with, and mount the host's
	# journal path afterwards.
	result_command="${result_command}
			--volume /var/log/journal"

	# In some systems, for example using sysvinit, /dev/shm is a symlink
	# to /run/shm, instead of the other way around.
	# Resolve this detecting if /dev/shm is a symlink and mount original
	# source also in the container.
	if [ -L "/dev/shm" ]; then
		result_command="${result_command}
			--volume $(realpath /dev/shm):$(realpath /dev/shm)"
	fi

	# If you are using NixOS, or have Nix installed, /nix is a volume containing
	# you binaries and many configs.
	# /nix needs to be mounted if you want to execute those binaries from within
	# the container. Therefore we need to mount /nix as a volume, but only if it exists.
	if [ -d "/nix" ]; then
		result_command="${result_command}
        --volume /nix:/nix"
	fi

	# If we have a custom home to use,
	#	1- override the HOME env variable
	#	2- expor the DISTROBOX_HOST_HOME env variable pointing to original HOME
	# 	3- mount the custom home inside the container.
	if [ -n "${container_user_custom_home}" ]; then
		result_command="${result_command}
		--env \"HOME=${container_user_custom_home}\"
		--env \"DISTROBOX_HOST_HOME=${container_user_home}\"
		--volume ${container_user_custom_home}:${container_user_custom_home}:rslave"
	fi

	# Mount also the /var/home dir on ostree based systems
	# do this only if $HOME was not already set to /var/home/username
	if [ "${container_user_home}" != "/var/home/${container_user_name}" ] &&
		[ -d "/var/home/${container_user_name}" ]; then

		result_command="${result_command}
		--volume \"/var/home/${container_user_name}\":\"/var/home/${container_user_name}\":rslave"
	fi

	# Mount also the XDG_RUNTIME_DIR to ensure functionality of the apps.
	if [ -d "/run/user/${container_user_uid}" ]; then
		result_command="${result_command}
		--volume /run/user/${container_user_uid}:/run/user/${container_user_uid}:rslave"
	fi

	# These are dynamic configs needed by the container to function properly
	# and integrate with the host
	#
	# We're doing this now instead of inside the init because some distros will
	# have symlinks places for these files that use absolute paths instead of
	# relative paths.
	# This is the bare minimum to ensure connectivity inside the container.
	# These files, will then be kept updated by the main loop every 15 seconds.
	result_command="${result_command}
		--volume /etc/hosts:/etc/hosts:ro
		--volume /etc/localtime:/etc/localtime:ro
		--volume /etc/resolv.conf:/etc/resolv.conf:ro"

	# These flags are not supported by docker, so we use them only if our
	# container manager is podman.
	if [ -z "${container_manager#*podman*}" ]; then
		result_command="${result_command}
			--ulimit host
			--annotation run.oci.keep_original_groups=1
			--mount type=devpts,destination=/dev/pts"
		if [ "${init}" -eq 1 ]; then
			result_command="${result_command}
				--systemd=always"
		fi
		# Use keep-id only if going rootless.
		if [ "${rootful}" -eq 0 ]; then
			result_command="${result_command}
				--userns keep-id"
		fi
	fi

	# Add additional flags
	result_command="${result_command} ${container_manager_additional_flags}"

	# Now execute the entrypoint, refer to `distrobox-init -h` for instructions
	#
	# Be aware that entrypoint corresponds to distrobox-init, the copying of it
	# inside the container is moved to distrobox-enter, in the start phase.
	# This is done to make init, export and host-exec location independent from
	# the host, and easier to upgrade.
	result_command="${result_command} ${container_image}
		/usr/bin/entrypoint -v --name \"${container_user_name}\"
		--user ${container_user_uid}
		--group ${container_user_gid}
		--home \"${container_user_custom_home:-"${container_user_home}"}\"
		--init \"${init}\"
		${container_pre_init_hook}
		-- '${container_init_hook}'
		"
	# use container_user_custom_home if defined, else fallback to normal home.

	# Return generated command.
	printf "%s" "${result_command}"
}

# Check if the container already exists.
# If it does, notify the user and exit.
if ${container_manager} inspect --type container "${container_name}" > /dev/null 2>&1; then
	printf "Distrobox named '%s' already exists.\n" "${container_name}"
	printf "To enter, run:\n\n"
	if [ "${rootful}" -ne 0 ]; then
		printf "distrobox-enter --root %s\n\n" "${container_name}"
	else
		printf "distrobox-enter %s\n\n" "${container_name}"
	fi
	exit 0
fi

# First, check if the image exists in the host or auto-pull is enabled
# If not prompt to download it.
if [ "${container_always_pull}" -eq 1 ] ||
	! ${container_manager} inspect --type image "${container_image}" > /dev/null 2>&1; then

	# If we do auto-pull, don't ask questions
	if [ "${non_interactive}" -eq 1 ] || [ "${container_always_pull}" -eq 1 ]; then
		response="yes"
	else
		# Prompt to download it.
		printf >&2 "Image %s not found.\n" "${container_image}"
		printf >&2 "Do you want to pull the image now? [Y/n]: "
		read -r response
		response="${response:-"Y"}"
	fi

	# Accept only y,Y,Yes,yes,n,N,No,no.
	case "${response}" in
		y | Y | Yes | yes | YES)
			# Pull the image
			${container_manager} pull "${container_image}"
			;;
		n | N | No | no | NO)
			printf >&2 "next time, run this command first:\n"
			printf >&2 "\t%s pull %s\n" "${container_manager}" "${container_image}"
			exit 0
			;;
		*) # Default case: If no more options then break out of the loop.
			printf >&2 "Invalid input.\n"
			printf >&2 "The available choices are: y,Y,Yes,yes,YES or n,N,No,no,NO.\nExiting.\n"
			exit 1
			;;
	esac
fi

# Generate the create command and run it
printf >&2 "Creating '%s' using image %s\t" "${container_name}" "${container_image}"
cmd="$(generate_command)"
# Eval the generated command. If successful display an helpful message.
# shellcheck disable=SC2086
if eval ${cmd} > /dev/null; then
	printf >&2 "\033[32m [ OK ]\n\033[0mDistrobox '%s' successfully created.\n" "${container_name}"
	printf >&2 "To enter, run:\n\n"
	if [ "${rootful}" -ne 0 ]; then
		printf "distrobox enter --root %s\n\n" "${container_name}"
	else
		printf "distrobox enter %s\n\n" "${container_name}"
	fi
	exit 0
fi
printf >&2 "\033[31m [ ERR ]\n\033[0m"