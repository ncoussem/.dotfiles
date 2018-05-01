dck_cleanup(){
        local containers
        mapfile -t containers < <(docker ps -aq 2>/dev/null)
        docker rm "${containers[@]}" 2>/dev/null
        local volumes
        mapfile -t volumes < <(docker ps --filter status=exited -q 2>/dev/null)
        docker rm -v "${volumes[@]}" 2>/dev/null
        local images
        mapfile -t images < <(docker images --filter dangling=true -q 2>/dev/null)
        docker rmi "${images[@]}" 2>/dev/null
}


dck_del_stopped(){
        local name=$1
        local state
        state=$(docker inspect --format "{{.State.Running}}" "$name" 2>/dev/null)

        if [[ "$state" == "false" ]]; then
            docker rm  "$name"
        fi
}


dck_get_ip(){
    local name=$1
    if [ -z "$name" ]; then
        name=$(docker ps | grep -v ^CONTAINER | head -n1 | awk '{print $1}')
    fi

    if [ ! -z "$name" ]; then
        docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$name"
    else
        echo "No running containers!"
    fi


}