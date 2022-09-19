#!/usr/bin/env bash

FILE_CSV='users.csv'
IFS=','

if [ ! -f ${FILE_CSV} ] ; then
    echo "file users.csv not found"
    exit 1
fi

if ! which aws &>> /dev/null ; then
    echo "check if package: ${check_package}"
    exit 2
fi

while read -r username email user_group ; do
    if [ -z ${IGNORE_FIRTS_LINE} ]; then
        IGNORE_FIRTS_LINE=true
        continue
    fi

    aws iam remove-user-from-group --user-name ${username} --group-name ${user_group}
    aws iam delete-login-profile --user-name ${username}
    aws iam delete-user --user-name ${username}
done < ${FILE_CSV}
