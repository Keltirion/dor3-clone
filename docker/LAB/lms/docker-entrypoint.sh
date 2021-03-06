#!/bin/sh

LMS_INI_FILE=/etc/lms/lms.ini
LMS_INI_SAMPLE=/usr/share/lms/sample/lms.ini

if [ -f "${LMS_INI_FILE}" ]
then 
    echo "${LMS_INI_FILE} found. Starting Apache"
    apachectl -D FOREGROUND "$@"
else
    echo "${LMS_INI_FILE} not found. Copy sample"
    sed -i -e 's/; type               = mysql/type               = ${SQL_TYPE}/' ${LMS_INI_SAMPLE}
    sed -i -e 's/; host               = localhost/host               = ${MYSQL_HOST}/' ${LMS_INI_SAMPLE}
    sed -i -e 's/; user               = mysql/user               = ${MYSQL_USER}/' ${LMS_INI_SAMPLE}
    sed -i -e 's/; password          = password/password          = ${MYSQL_PASSWORD}/' ${LMS_INI_SAMPLE}
    sed -i -e 's/; database          = lms/database          = ${MYSQL_DATABASE}/' ${LMS_INI_SAMPLE}
    mkdir -p /etc/lms
    envsubst < ${LMS_INI_SAMPLE} >> ${LMS_INI_FILE}
fi

exec "$@"
