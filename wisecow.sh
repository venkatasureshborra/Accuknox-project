#!/usr/bin/env bash

SRVPORT=4499
RSPFILE=response

rm -f $RSPFILE
mkfifo $RSPFILE

get_api() {
    read line
    echo $line
}

handleRequest() {
   # 1) Process the request
    get_api

    # Static message
    static_msg="Hello from Wisecow App 🐮"

    # Dynamic message (fortune + cowsay)
    dynamic_msg="$(fortune | cowsay)"

    cat <<EOF > $RSPFILE
HTTP/1.1 200


<pre>
$static_msg

$dynamic_msg
</pre>
EOF
}

prerequisites() {
    command -v cowsay >/dev/null 2>&1 &&
    command -v fortune >/dev/null 2>&1 ||
    {
        echo "Install prerequisites (cowsay, fortune)."
        exit 1
    }
}

main() {
    prerequisites
    echo "Wisecow running on port=$SRVPORT (static + dynamic mode)"

    while true; do
        cat $RSPFILE | nc -lN $SRVPORT | handleRequest
        sleep 0.01
    done
}

main

