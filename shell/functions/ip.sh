#!/usr/bin/env bash


filename=ip.sh
echo "$(date +"%Y%m%d %H:%M:%S");$$;$(tty);Loading $filename" >> ~/.bash_log

ip_missing_curl=false

if ! [ -x "$(command -v curl)" ]; then
    echo "$(date +"%Y%m%d %H:%M:%S");$$;$(tty);$filename;curl is not installed" >> ~/.bash_log
    ip_missing_curl=true 
fi

ip_missing_jq=false
if ! [ -x "$(command -v jq)" ]; then
    echo "$(date +"%Y%m%d %H:%M:%S");$$;$(tty);$filename;jq is not installed" >> ~/.bash_log
    ip_missing_jq=true
fi

ip.getexternal() {
    if [ $ip_missing_curl = true ] ; then
        echo "curl is not installed"
    else
        curl -s http://whatismyip.akamai.com 2>/dev/null
    fi
}


ip.getlocation() {
    if [ $ip_missing_curl = true ] ; then
        echo "curl is not installed"
    else
        curl -s ipinfo.io/$1 2>/dev/null
    fi

}


ip.getmylocation() {

    if [ $ip_missing_jq = true ] ; then
        echo "jq is not installed"
    else
        ip=$(ip.getexternal)
        ip.getlocation $ip | jq ".$1" | tr -d \"
    fi

}