# Syntax-highlight JSON strings or files
# Usage: `json '{"foo":42}'` or `echo '{"foo":42}' | json`
debit() {


        if [[ $1 == 10G ]] ; then
                file=10485760.rnd
    else
            file=1048576.rnd
        fi
    wget -O /dev/null http://test-debit.free.fr/$file

}
