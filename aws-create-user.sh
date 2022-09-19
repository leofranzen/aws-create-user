#!/usr/bin/env bash

AWS_PAGE_LOGIN="https://123456789012.signin.aws.amazon.com/console"
FILE_CSV='users.csv'
IFS=','

if [ ! -f ${FILE_CSV} ] ; then
    echo "file users.csv not found"
    exit 1
fi

for check_package in 'aws' 'openssl' ; do
    if ! which ${check_package} &>> /dev/null ; then
        echo "check if package: ${check_package}"
        exit 2
    fi
done

while read -r username email user_group ; do
    if [ -z ${IGNORE_FIRTS_LINE} ]; then
        IGNORE_FIRTS_LINE=true
        continue
    fi

    random_password=$(openssl rand -base64 20)

    aws iam create-user --user-name ${username}
    aws iam create-login-profile --password-reset-required --user-name ${username} --password ${random_password}
    aws iam add-user-to-group --user-name ${username} --group-name ${user_group}

    echo "generated: ${username} ${random_password}"
done < ${FILE_CSV}
