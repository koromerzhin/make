echo "waiting ${1}"
until [ "`docker inspect -f {{.State.Status}} ${1}`" = "running" ]; do
    echo "..."
    sleep 1
done
echo "..."
status="`docker inspect -f {{.State.Status}} ${1}`"
if [ "$status" = "running" ]
then
    echo "${1} running"
else
    echo "${1} not running"
    fi