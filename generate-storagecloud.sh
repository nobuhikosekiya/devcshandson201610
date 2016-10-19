#!/bin/bash

cat <<EOF > storagecloud.sh
USERNAME=${OPC_USER}
PASSWORD=${OPC_PASSWORD}
ID_DOMAIN=${IDENTITY_DOMAIN}

EOF

cat <<'EOF' >> storagecloud.sh
gettoken() {

  if [ -z "$AUTH_TOKEN" ]; then
  
    curl -i -X GET -H "X-Storage-User: Storage-${ID_DOMAIN}:${USERNAME}" \
    -H "X-Storage-Pass: ${PASSWORD}" \
    --dump-header curl.out \
    https://${ID_DOMAIN}.storage.oraclecloud.com/auth/v1.0

    AUTH_TOKEN=`cat curl.out | grep X-Auth-Token | sed -e "s/.*\: //"`
  fi
  echo "TOKEN IS $AUTH_TOKEN"
}

create_container() {

  gettoken

  # Create Container
  curl -i -X PUT \
  -H "X-Auth-Token: $AUTH_TOKEN" \
  https://${ID_DOMAIN}.storage.oraclecloud.com/v1/Storage-${ID_DOMAIN}/${CONTAINER_NAME}
}

upload_files() {

  gettoken

  for FILE in $FILE_LIST
  do
    curl -i -X PUT \
    -H "X-Auth-Token: $AUTH_TOKEN" \
    -T "${FILE}" \
    https://${ID_DOMAIN}.storage.oraclecloud.com/v1/Storage-${ID_DOMAIN}/${CONTAINER_NAME}/${FILE}
  done
}

list_files() {
  gettoken
  
  curl -i -X GET \
  -H "X-Auth-Token: $AUTH_TOKEN" \
  https://${ID_DOMAIN}.storage.oraclecloud.com/v1/Storage-${ID_DOMAIN}/${CONTAINER_NAME}
}

download_files() {

  gettoken

  for FILE in $FILE_LIST
  do
    curl -i -X GET \
     -H "X-Auth-Token: $AUTH_TOKEN" \
     -o "$FILE" \
     https://${ID_DOMAIN}.storage.oraclecloud.com/v1/Storage-${ID_DOMAIN}/${CONTAINER_NAME}/$FILE
  done
}

showhelp () {
  echo "
  $0 -a action -c container file1 file2 file3 ...
  ACTIONS:
    gettoken
    create_container
    upload_files
    download_files
    list_files
  "
}

#------------------------ MAIN ---------------------#

while getopts a:c: OPT
do
  case $OPT in
    a) CMD=$OPTARG ;;
    c) CONTAINER_NAME=$OPTARG ;;
    h) showhelp; exit 0;;
    *) showhelp; exit 1 ;;
  esac
done

shift `expr $OPTIND - 1`

FILE_LIST=$*

eval $CMD

EOF