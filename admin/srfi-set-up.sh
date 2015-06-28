#!/bin/bash

SOURCE=~/srfi/split
DESTINATION=/var/www/srfi
PARENT=`dirname $DESTINATION`
TEMP=`mktemp --directory --tmpdir=$PARENT`

cd $SOURCE

SRFI=(`find . -maxdepth 1 -type d -regex './srfi-[0-9]+'|awk -F './srfi-' '{print $2'}`)

cd $TEMP/
for DIR in common email
do
    echo $DIR
    ((cd $SOURCE/srfi-$DIR && git archive --format=tgz HEAD)|tar xzf -)
done
$SOURCE/srfi-common/admin/link-to-new-archives.sh
for I in ${SRFI[@]}
do
    echo srfi-$I
    (cd $SOURCE/srfi-$I && git archive --format=tgz HEAD)|(cd $TEMP/srfi-$I; tar xzf -)
done
cp -p $TEMP/README.html $TEMP/index.html
chmod -R 0755 $TEMP
cd $PARENT
mv --force `basename $TEMP` `basename $DESTINATION`