#!/bin/bash
set -e
#set -u
# Author: Tomas Nevar (tomas@lisenet.com)
# ShellCheck'ed.
#
# This script uploads JSON CF templates
# to the S3 bucket specified in S3_BUCKET.
#
# The script defaults to ${HOME}/.s3cfg for the
# AWS access and secret keys. You need to have
# this file configured before using the script:
#
# ./s3cmd --configure
#

MY_FILE="${1}";
S3_BUCKET="lisenet-cf-templates";

if ! type s3cmd >/dev/null 2>&1; then
  echo "ERROR: cannot find s3cmd!";
  exit 1;
fi

if [ -z "${MY_FILE}" ];then
  echo "Usage: ./upload_to_s3.sh <filename>";
  exit 1; 
elif ! [ -f "${MY_FILE}" ];then
  echo "ERROR: file does not exist!";
  exit 1;
else
  MY_STACK_NAME=$(echo "${MY_FILE}"|cut -d"-" -f 2-4|sed 's/-TEMPLATE.json//g');
  echo "INFO: validating JSON template before uploading."
  if ! type python >/dev/null 2>&1; then
    echo -e "WARN: python not found, no validation possible.\n";
  else
    python -m json.tool "${MY_FILE}" >/dev/null;
    exit_code=$?;
    if [ "${exit_code}" -eq 0 ];then
      echo -e "INFO: validation successful.\n";
    else
      echo "ERROR: validation failed. Is the file a valid JSON?";
      exit 1;
    fi
  fi
  s3cmd -f --acl-private --ssl --no-progress put "${MY_FILE}" "s3://${S3_BUCKET}";
  echo -e "\nINFO: template URL to use with CloudFormation:"
  echo -e "\nhttps://s3-eu-west-1.amazonaws.com/${S3_BUCKET}/${MY_FILE}";
  echo -e "\nINFO: aws cli to update CloudFormation stack:"
  echo -e "\naws cloudformation update-stack \
  --stack-name ${MY_STACK_NAME} \
  --template-url https://s3-eu-west-1.amazonaws.com/${S3_BUCKET}/${MY_FILE} \
  --region eu-west-2";

fi

exit 0;
