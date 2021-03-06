#!/bin/bash

set -e

if [ -z "${gradle_file}" ]; then
	printf "\e[31mNo gradle_file specified\e[0m\n"
	exit 1
fi

if [ -z "${gradle_task}" ]; then
	printf "\e[31mNo gradle_task specified\e[0m\n"
	exit 1
fi

if [ -z "${apk_file_include_filter}" ]; then
	apk_file_include_filter="*.apk"
fi

if [ -z "${apk_file_exclude_filter}" ]; then
	apk_file_exclude_filter=""
fi

echo "$" gradle --build-file "${gradle_file}" ${gradle_task}
gradle --build-file "${gradle_file}" ${gradle_task}

echo ""
echo "Moving APK files with filter: include-> '${apk_file_include_filter}', exclude-> '${apk_file_exclude_filter}'"
find . -name "${apk_file_include_filter}" ! -name "${apk_file_exclude_filter}" | while IFS= read -r apk; do 
	deploy_path="${BITRISE_DEPLOY_DIR}/$(basename "$apk")"
	
	printf "🚀  \e[32mCopy ${apk} to ${deploy_path}\e[0m\n"
	cp "${apk}" "${deploy_path}"
done