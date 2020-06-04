dck_cleanup(){
    echo "$(date +"%Y%m%d %H:%M:%S");$$;$(tty);Running ${FUNCNAME[0]} $*" >> ~/.bash_log

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
    echo "$(date +"%Y%m%d %H:%M:%S");$$;$(tty);Running ${FUNCNAME[0]} $*" >> ~/.bash_log

    local name=$1
    local state
    state=$(docker inspect --format "{{.State.Running}}" "$name" 2>/dev/null)

    if [[ "$state" == "false" ]]; then
        docker rm  "$name"
    fi
}



dck_kill(){
    echo "$(date +"%Y%m%d %H:%M:%S");$$;$(tty);Running ${FUNCNAME[0]} $*" >> ~/.bash_log

    local name=$1
    local state
    state=$(docker inspect --format "{{.State.Running}}" "$name" 2>/dev/null)

    if [[ "$state" == "true" ]]; then
        docker kill "$name"
    fi
}


dck_get_ip(){
    echo "$(date +"%Y%m%d %H:%M:%S");$$;$(tty);Running ${FUNCNAME[0]} $*" >> ~/.bash_log
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


dck_latex() {
    echo "$(date +"%Y%m%d %H:%M:%S");$$;$(tty);Running ${FUNCNAME[0]} $*" >> ~/.bash_log
    local image=blang/latex:ctanfull
    #IMAGE=blang/latex:ubuntu
    #IMAGE=blang/latex:ctanbasic
    docker run --rm -i --user="$(id -u):$(id -g)" --net=none -v "$PWD":/data "$image" "$@"
}

sage_notebook() {

    echo "$(date +"%Y%m%d %H:%M:%S");$$;$(tty);Running ${FUNCNAME[0]} $*" >> ~/.bash_log
    dck_del_stopped sage_notebook
    docker run -p 8888:8888 --name sage_notebook sagemath/sagemath-jupyter


}