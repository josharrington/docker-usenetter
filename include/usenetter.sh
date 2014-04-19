#!/bin/bash

LOGDIR=/root/logs
DLDIR=/root/downloads
UPLOADS=/root/uploads
REALPATH=`readlink -m "$1"`
RARSIZE=15m
FILE=`python -c "print '$REALPATH'.split('/')[-1:][0]"`
TEMPDIR="$UPLOADS/$FILE"


rm "$LOGDIR/$FILE.log"
mkdir "$UPLOADS"

log() {
	local prefix="[$(date +%Y/%m/%d\ %H:%M:%S)]: "
	echo "${prefix} $@" >> "$LOGDIR/$FILE.log"
}

logcmd() {
	while read data
	do
		log $data
	done
}

if [[ -z $1 ]]
then
	log "No file was specified for upload"
	exit 1
fi

if [[ -z $FILE ]]
then
	log "FILE was empty. Directory?"
	exit 1
fi

if [[ $REALPATH != $DLDIR* ]]
then
	echo "File not in $DLDIR" 
	log "File not in $DLDIR"
	exit 1
fi

log "Uploading $1 to usenet"


#Create temp folder for file
log "-----------------------------------"
log "Creating folder $TEMPDIR"
mkdir -p "$TEMPDIR" 2>&1 | logcmd

#RAR the file
log "RARing files to $TEMPDIR"
/usr/bin/rar a "$TEMPDIR/$FILE" "$REALPATH" -v$RARSIZE -m0 -ep1 2>&1 | logcmd

#Create the pars
log "-----------------------------------"
log "Creating the pars"
/usr/bin/par2create -r10 -n7 "$TEMPDIR/$FILE" "$TEMPDIR/*.rar" 2>&1 | logcmd

#Upload the files
/root/GoPostStuff -c /root/GoPostStuff.conf -d "$TEMPDIR" 2>&1 | logcmd

#cleanup
if [[ "$TEMPDIR" != "$UPLOADS" ]]
then
	log "Deleting " $TEMPDIR
	rm -vrf "$TEMPDIR"
fi

log "Deleting " $REALPATH
rm -vrf "$REALPATH"
