#!/bin/sh

#Need to add defaults to these following two environment variables if they don't exist if not supplied by user. If not supplied should default to 0 (root).

if [ -z $USERID ]; then
 	USERID=0
fi

if [ -z $GROUPID ]; then
	GROUPID=0
fi

USER=$USERID
GROUP=$GROUPID

if [ -z "$ENTRYPOINT" ]; then
	ENTRYPOINT=/borg/borg
fi

if ! getent group $GROUP >/dev/null 2>&1; then
	groupadd --gid $GROUP user >/dev/null 2>&1
fi

if ! getent passwd $USER >/dev/null 2>&1; then	
	adduser --disabled-password --home /home/user --gecos "" --uid $USER --gid $GROUP user >/dev/null 2>&1

fi

if [ $(id -g $USER) -ne $GROUP ]; then
	usermod -g $GROUP "$(id -un -- $USER)" >/dev/null 2>&1

fi


if [ -x $ENTRYPOINT ]; then
	exec sudo -u "$(id -un -- $USER)" "$ENTRYPOINT" "$@" < /dev/stdin
else
	echo "ERROR: Cannot execute or find binary at $ENTRYPOINT. Please ensure it is properly mounted to container before proceeding."
fi
