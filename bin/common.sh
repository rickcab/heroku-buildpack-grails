#!/usr/bin/env bash

get_property() {
    local file=${1?"No file specified"}
    local key=${2?"No key specified"}
 
    # escape for regex
    local escaped_key=$(echo $key | sed "s/\./\\\./g")

    [ -f $file ] && \
    grep -E ^$escaped_key[[:space:]=]+ $file | \
    sed -E -e "s/$escaped_key([\ \t]*=[\ \t]*|[\ \t]+)\"?([A-Za-z0-9\.-]*)\"?.*/\2/g"
}

send_deploy_notification() {
	PROJECT=$1
	SUBJECT=$2
	VERSION=$3
	INFO=$4
	
	URL='https://api.flowdock.com/messages/team_inbox/418e0cc9c040bcdeefcad45c7aa2a034'
	
	CONTENT="<html><body><h1>$PROJECT  Version: $VERSION</h1><h3>Built and deployed!</h3>\
<a href=\\\"http://www.youtube.com/watch?v=vCadcBR95oU\\\">\
<img src=\\\"http://userserve-ak.last.fm/serve/252/23905581.jpg\\\" alt=\\\"Push It Real Good!\\\"/>\
</a>\
<div>\
<h3>Information</h3>\
<hr/>\
$INFO\
</div>\
</body></html>"

	PAYLOAD="{ \"source\": \"Builder\", \"from_address\": \"bobTheBuilder@findexp.com\", \
\"subject\": \"$SUBJECT\", \"project\": \"$PROJECT\", \
\"tags\": [\"#builds\"], \"content\": \"$CONTENT\" }"

	echo "PROJECT: $PROJECT   SUBJECT:  $SUBJECT  PAYLOAD: $PAYLOAD"
	curl -v -H 'Content-Type: application/json' -H 'Accept: application/json' -X POST -d "$PAYLOAD" $URL
}

