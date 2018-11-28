echo "Hello!"

echo $HOME

HOME=. aptible login --email support@trialspark.com --password "${1}" --lifetime "1 day"

token=$(cat ~/.aptible/tokens.json | sed 's/"/ /g' | awk '{print $4}')

backup_id=$(APTIBLE_ACCESS_TOKEN=${token} aptible backup:list spark-staging-1 | head -n 1 | awk '{ print \$1; }' | sed 's/:\$//')
timestamp=$(date +"%Y%m%d%H%M%S")
backup_handle="${timestamp}_spark-staging-1"

echo "Restoring backup ${backup_id} to ${backup_handle}"
HOME=. APTIBLE_ACCESS_TOKEN=${token} aptible backup:restore ${backup_id} --handle=${backup_handle}
